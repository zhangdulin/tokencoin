const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("TokenVesting", function () {
  const TOKEN_NAME = "TestToken";
  const TOKEN_SYMBOL = "TTK";
  const INITIAL_SUPPLY = ethers.utils.parseUnits("1000000", 18);
  const TIMELOCK_DELAY = 7200; // 2 hours
  const MAX_EMERGENCY_BPS = 1000; // 10%
  const EMERGENCY_DELAY = 172800; // 48 hours

  let token;
  let vesting;
  let owner;
  let beneficiary;

  beforeEach(async function () {
    [owner, beneficiary] = await ethers.getSigners();

    // Deploy token
    const TokenFactory = await ethers.getContractFactory("MyToken");
    token = await TokenFactory.deploy(TOKEN_NAME, TOKEN_SYMBOL, INITIAL_SUPPLY, owner.address, TIMELOCK_DELAY);
    await token.deployed();

    // Deploy vesting contract
    const VestingFactory = await ethers.getContractFactory("TokenVesting");
    vesting = await VestingFactory.deploy(token.address, owner.address, MAX_EMERGENCY_BPS, EMERGENCY_DELAY);
    await vesting.deployed();

    // Transfer tokens to vesting contract for testing
    const vestingAmount = ethers.utils.parseUnits("100000", 18);
    await token.transfer(vesting.address, vestingAmount);
  });

  describe("Initialization", function () {
    it("should set the correct token address", async function () {
      expect(await vesting.token()).to.equal(token.address);
    });

    it("should set the correct owner", async function () {
      expect(await vesting.owner()).to.equal(owner.address);
    });

    it("should initialize vesting correctly", async function () {
      const vestingAmount = ethers.utils.parseUnits("10000", 18);
      const duration = 365 * 24 * 60 * 60; // 1 year
      const cliff = 30 * 24 * 60 * 60; // 30 days

      await vesting.initializeVesting(beneficiary.address, vestingAmount, duration, cliff);

      expect(await vesting.beneficiary()).to.equal(beneficiary.address);
      expect((await vesting.totalTokens()).toString()).to.equal(vestingAmount.toString());
      expect((await vesting.duration()).toString()).to.equal(duration.toString());
      expect((await vesting.cliffDuration()).toString()).to.equal(cliff.toString());
    });

    it("should fail if beneficiary is zero address", async function () {
      try {
        await vesting.initializeVesting(
          ethers.constants.AddressZero,
          1000,
          365 * 24 * 60 * 60,
          0
        );
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("TokenVesting: beneficiary is zero");
      }
    });
  });

  describe("Vesting Schedule", function () {
    beforeEach(async function () {
      this.vestingAmount = ethers.utils.parseUnits("10000", 18);
      this.duration = 365 * 24 * 60 * 60; // 1 year
      this.cliff = 0;
      await vesting.initializeVesting(
        beneficiary.address,
        this.vestingAmount,
        this.duration,
        this.cliff
      );
    });

    it("should return 0 before cliff period", async function () {
      expect((await vesting.releasable()).toString()).to.equal("0");
    });

    it("should release tokens after vesting period", async function () {
      // Fast forward time
      await ethers.provider.send("evm_increaseTime", [this.duration + 1]);
      await ethers.provider.send("evm_mine", []);

      const releasable = await vesting.releasable();
      expect(releasable.toString()).to.equal(this.vestingAmount.toString());
    });

    it("should release partial tokens during vesting", async function () {
      const halfDuration = Math.floor(this.duration / 2);
      await ethers.provider.send("evm_increaseTime", [halfDuration]);
      await ethers.provider.send("evm_mine", []);

      const releasable = await vesting.releasable();
      // Calculate expected: half of vesting amount (use BigNumber operations)
      const expectedReleasable = this.vestingAmount.div(2);
      // Check releasable is approximately half (within 1 token tolerance)
      const diff = releasable.sub(expectedReleasable).abs();
      expect(diff.lte(1)).to.be.true;
    });
  });

  describe("Release", function () {
    beforeEach(async function () {
      this.vestingAmount = ethers.utils.parseUnits("10000", 18);
      this.duration = 365 * 24 * 60 * 60;
      await vesting.initializeVesting(
        beneficiary.address,
        this.vestingAmount,
        this.duration,
        0
      );
    });

    it("should release tokens to beneficiary", async function () {
      await ethers.provider.send("evm_increaseTime", [this.duration + 1]);
      await ethers.provider.send("evm_mine", []);

      const initialBalance = await token.balanceOf(beneficiary.address);
      await vesting.release();
      const finalBalance = await token.balanceOf(beneficiary.address);

      expect(finalBalance.sub(initialBalance).toString()).to.equal(this.vestingAmount.toString());
    });

    it("should not release before initialization", async function () {
      const newVesting = await (await ethers.getContractFactory("TokenVesting"))
        .connect(owner)
        .deploy(token.address, owner.address, MAX_EMERGENCY_BPS, EMERGENCY_DELAY);

      try {
        await newVesting.release();
        expect.fail("Should have reverted");
      } catch (err) {
        // Expected to revert
        expect(err.message).to.include("TokenVesting: not initialized");
      }
    });
  });

  describe("Emergency Withdraw", function () {
    beforeEach(async function () {
      // Initialize vesting to set totalTokens
      const vestingAmount = ethers.utils.parseUnits("100000", 18);
      const duration = 365 * 24 * 60 * 60;
      await vesting.initializeVesting(beneficiary.address, vestingAmount, duration, 0);
    });

    it("should allow owner to request emergency withdraw", async function () {
      await vesting.requestEmergencyWithdraw();
      // Request should succeed
      const requestedAt = await vesting.emergencyWithdrawRequestedAt();
      expect(requestedAt.gt(0)).to.be.true;
    });

    it("should allow owner to execute emergency withdraw after delay", async function () {
      const contractBalance = await token.balanceOf(vesting.address);
      const ownerBalance = await token.balanceOf(owner.address);

      await vesting.requestEmergencyWithdraw();
      // Fast forward 48 hours
      await ethers.provider.send("evm_increaseTime", [48 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await vesting.executeEmergencyWithdraw(owner.address);

      // Should only withdraw 10% max (maxEmergencyWithdrawBps = 1000)
      const expectedWithdraw = ethers.utils.parseUnits("10000", 18); // 10% of 100000
      expect((await token.balanceOf(owner.address)).toString()).to.equal(ownerBalance.add(expectedWithdraw).toString());
    });

    it("should fail if withdrawal to zero address on execute", async function () {
      await vesting.requestEmergencyWithdraw();
      await ethers.provider.send("evm_increaseTime", [48 * 60 * 60]);
      await ethers.provider.send("evm_mine");

      try {
        await vesting.executeEmergencyWithdraw(ethers.constants.AddressZero);
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("TokenVesting: cannot withdraw to zero");
      }
    });

    it("should fail if no pending request on execute", async function () {
      try {
        await vesting.executeEmergencyWithdraw(owner.address);
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("TokenVesting: no pending request");
      }
    });

    it("should fail if delay not passed", async function () {
      await vesting.requestEmergencyWithdraw();
      // Try to execute before 48 hours
      await ethers.provider.send("evm_increaseTime", [47 * 60 * 60]);
      await ethers.provider.send("evm_mine");

      try {
        await vesting.executeEmergencyWithdraw(owner.address);
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("TokenVesting: emergency withdraw delay not passed");
      }
    });

    it("should allow owner to cancel emergency withdraw", async function () {
      await vesting.requestEmergencyWithdraw();
      await vesting.cancelEmergencyWithdraw();

      // Now should be able to request again
      await vesting.requestEmergencyWithdraw();
    });
  });
});
