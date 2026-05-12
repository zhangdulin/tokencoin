/**
 * Fixed Security Tests - Tokencoin
 * 运行命令: npx hardhat test test/SimpleSecurityTests.test.js
 */

const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Tokencoin Security Tests - AFTER FIX", function () {
  const TOKEN_NAME = "Tokencoin";
  const TOKEN_SYMBOL = "TOKEN";
  const INITIAL_SUPPLY = ethers.utils.parseUnits("10000000000", 18); // 100亿
  const TIMELOCK_DELAY = 7200; // 2 hours
  const MAX_EMERGENCY_BPS = 1000; // 10%
  const EMERGENCY_DELAY = 172800; // 48 hours

  let token;
  let vesting;
  let owner;
  let addr1;
  let addr2;
  let attacker;

  beforeEach(async function () {
    [owner, addr1, addr2, attacker] = await ethers.getSigners();

    // Deploy token
    const TokenFactory = await ethers.getContractFactory("MyToken");
    token = await TokenFactory.deploy(TOKEN_NAME, TOKEN_SYMBOL, INITIAL_SUPPLY, owner.address, TIMELOCK_DELAY);

    // Deploy vesting
    const VestingFactory = await ethers.getContractFactory("TokenVesting");
    vesting = await VestingFactory.deploy(token.address, owner.address, MAX_EMERGENCY_BPS, EMERGENCY_DELAY);
  });

  // ============================================
  // TEST 1: MAX_SUPPLY now enforced
  // ============================================
  it("FIXED: Minting now has max supply limit", async function () {
    const initialSupply = await token.totalSupply();

    // Minting way too much should fail
    const hugeMint = ethers.utils.parseUnits("99999999999", 18); // Way over max

    let failed = false;
    try {
      await token.mint(addr1.address, hugeMint);
    } catch (e) {
      failed = true;
      expect(e.message).to.include("MyToken: exceeds max supply");
    }
    expect(failed).to.be.true;

    console.log("  ✓  FIXED: Minting now enforces MAX_SUPPLY limit");
  });

  // ============================================
  // TEST 2: burnFrom now requires authorization
  // ============================================
  it("FIXED: burnFrom now requires authorization", async function () {
    // Transfer tokens to addr1
    const transferAmount = ethers.utils.parseUnits("1000", 18);
    await token.transfer(addr1.address, transferAmount);

    // Try to burn from addr1 without authorization (should fail)
    let failed = false;
    try {
      await token.burnFrom(addr1.address, ethers.utils.parseUnits("100", 18));
    } catch (e) {
      failed = true;
      expect(e.message).to.include("MyToken: not authorized for burn");
    }
    expect(failed).to.be.true;
    console.log("  ✓  FIXED: Cannot burn without authorization");

    // Authorize addr1
    await token.authorizeBurnFrom(addr1.address);
    expect(await token.authorizedBurnFrom(addr1.address)).to.be.true;

    // Now owner can burn
    await token.burnFrom(addr1.address, ethers.utils.parseUnits("100", 18));
    const addr1Balance = await token.balanceOf(addr1.address);
    expect(addr1Balance.toString()).to.equal(ethers.utils.parseUnits("900", 18).toString());

    // Deauthorize
    await token.deauthorizeBurnFrom(addr1.address);
    expect(await token.authorizedBurnFrom(addr1.address)).to.be.false;

    console.log("  ✓  FIXED: Authorization mechanism for burnFrom works");
  });

  // ============================================
  // TEST 3: TokenVesting cannot be re-initialized
  // ============================================
  it("FIXED: TokenVesting cannot be re-initialized", async function () {
    // Deposit tokens first
    const vestingAmount = ethers.utils.parseUnits("100000", 18);
    await token.transfer(vesting.address, vestingAmount);

    // Initialize vesting
    const duration = 365 * 24 * 60 * 60;
    await vesting.initializeVesting(addr1.address, vestingAmount, duration, 0);
    expect(await vesting.isInitialized()).to.be.true;
    expect(await vesting.beneficiary()).to.equal(addr1.address);

    // Try to re-initialize (should fail)
    let failed = false;
    try {
      await vesting.initializeVesting(attacker.address, vestingAmount, duration, 0);
    } catch (e) {
      failed = true;
      expect(e.message).to.include("TokenVesting: already initialized");
    }
    expect(failed).to.be.true;

    console.log("  ✓  FIXED: TokenVesting cannot be re-initialized");
  });

  // ============================================
  // TEST 4: EmergencyWithdraw now requires balance
  // ============================================
  it("FEATURE: EmergencyWithdraw checks for balance", async function () {
    // Try to request withdraw from empty contract
    let failed = false;
    try {
      await vesting.requestEmergencyWithdraw();
    } catch (e) {
      failed = true;
      expect(e.message).to.include("TokenVesting: no tokens to withdraw");
    }
    expect(failed).to.be.true;
    console.log("  ✓  FEATURE: EmergencyWithdraw has balance check");
  });

  // ============================================
  // TEST 5: Blacklist still works (with timelock)
  // ============================================
  it("FEATURE: Blacklist prevents transfers (with timelock)", async function () {
    await token.transfer(addr1.address, ethers.utils.parseUnits("100", 18));
    await token.blacklist(addr1.address);
    await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
    await ethers.provider.send("evm_mine");
    await token.executeBlacklist(addr1.address);

    let failed = false;
    try {
      await token.connect(addr1).transfer(addr2.address, ethers.utils.parseUnits("50", 18));
    } catch (e) {
      failed = true;
    }
    expect(failed).to.be.true;
    console.log("  ✓  FEATURE: Blacklist still works correctly");
  });

  // ============================================
  // TEST 6: Pause still works (with timelock)
  // ============================================
  it("FEATURE: Pause prevents all transfers (with timelock)", async function () {
    await token.pause();
    await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
    await ethers.provider.send("evm_mine");
    await token.executePause();
    expect(await token.paused()).to.be.true;

    let failed = false;
    try {
      await token.transfer(addr1.address, ethers.utils.parseUnits("100", 18));
    } catch (e) {
      failed = true;
    }
    expect(failed).to.be.true;
    console.log("  ✓  FEATURE: Pause still works correctly");
  });

  // ============================================
  // TEST 7: Owner cannot blacklist themselves
  // ============================================
  it("FEATURE: Owner cannot blacklist themselves", async function () {
    let failed = false;
    try {
      await token.blacklist(owner.address);
    } catch (e) {
      failed = true;
    }
    expect(failed).to.be.true;
    console.log("  ✓  FEATURE: Owner cannot blacklist themselves");
  });

  // ============================================
  // TEST 8: Regular burn works (no authorization needed)
  // ============================================
  it("FEATURE: Regular burn works without authorization", async function () {
    const initialSupply = await token.totalSupply();
    const burnAmount = ethers.utils.parseUnits("10", 18);

    // Anyone can burn their own tokens without authorization
    await token.burn(burnAmount);

    const newSupply = await token.totalSupply();
    expect(newSupply.toString()).to.equal(initialSupply.sub(burnAmount).toString());

    console.log("  ✓  FEATURE: Regular burn works without authorization");
  });
});
