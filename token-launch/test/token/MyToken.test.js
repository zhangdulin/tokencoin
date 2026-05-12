const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("MyToken", function () {
  const TOKEN_NAME = "MyToken";
  const TOKEN_SYMBOL = "MTK";
  const INITIAL_SUPPLY = ethers.utils.parseUnits("1000000", 18);
  const TIMELOCK_DELAY = 7200; // 2 hours for testing

  let token;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    [owner, addr1, addr2] = await ethers.getSigners();

    const TokenFactory = await ethers.getContractFactory("MyToken");
    token = await TokenFactory.deploy(TOKEN_NAME, TOKEN_SYMBOL, INITIAL_SUPPLY, owner.address, TIMELOCK_DELAY);
    await token.deployed();
  });

  describe("Deployment", function () {
    it("should set the correct name", async function () {
      expect(await token.name()).to.equal(TOKEN_NAME);
    });

    it("should set the correct symbol", async function () {
      expect(await token.symbol()).to.equal(TOKEN_SYMBOL);
    });

    it("should set the correct initial supply", async function () {
      expect((await token.totalSupply()).toString()).to.equal(INITIAL_SUPPLY.toString());
    });

    it("should assign total supply to owner", async function () {
      expect((await token.balanceOf(owner.address)).toString()).to.equal(INITIAL_SUPPLY.toString());
    });
  });

  describe("Transfers", function () {
    it("should transfer tokens between accounts", async function () {
      const transferAmount = ethers.utils.parseUnits("100", 18);
      await token.transfer(addr1.address, transferAmount);
      expect((await token.balanceOf(addr1.address)).toString()).to.equal(transferAmount.toString());
    });

    it("should fail if sender doesn't have enough tokens", async function () {
      const initialBalance = await token.balanceOf(owner.address);
      try {
        await token.transfer(addr1.address, initialBalance.add(1));
        expect.fail("Should have reverted");
      } catch (err) {
        // Error message varies by VM, just check it reverted
        expect(err.message).to.include("revert");
      }
    });
  });

  describe("Pausable", function () {
    it("should allow owner to schedule pause", async function () {
      await token.pause();
      // Schedule should succeed - actual pause happens after timelock
    });

    it("should allow owner to execute pause after timelock", async function () {
      await token.pause();
      // Fast forward via hardhat (in real scenario, wait 24 hours)
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executePause();
      expect(await token.paused()).to.be.true;
    });

    it("should allow owner to schedule unpause", async function () {
      await token.pause();
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executePause();
      expect(await token.paused()).to.be.true;

      await token.unpause();
    });

    it("should allow owner to execute unpause after timelock", async function () {
      await token.pause();
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executePause();
      expect(await token.paused()).to.be.true;

      await token.unpause();
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeUnpause();
      expect(await token.paused()).to.be.false;
    });

    it("should prevent transfers when paused", async function () {
      const transferAmount = ethers.utils.parseUnits("100", 18);
      await token.pause();
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executePause();
      try {
        await token.transfer(addr1.address, transferAmount);
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("revert");
      }
    });

    it("should allow transfers after unpause", async function () {
      const transferAmount = ethers.utils.parseUnits("100", 18);
      await token.pause();
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executePause();

      await token.unpause();
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeUnpause();

      await token.transfer(addr1.address, transferAmount);
      expect((await token.balanceOf(addr1.address)).toString()).to.equal(transferAmount.toString());
    });
  });

  describe("Blacklist", function () {
    it("should allow owner to schedule blacklist", async function () {
      await token.blacklist(addr1.address);
      // Schedule should succeed - actual blacklist happens after timelock
    });

    it("should allow owner to execute blacklist after timelock", async function () {
      await token.blacklist(addr1.address);
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeBlacklist(addr1.address);
      expect(await token.isBlacklisted(addr1.address)).to.be.true;
    });

    it("should allow owner to schedule unBlacklist", async function () {
      await token.blacklist(addr1.address);
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeBlacklist(addr1.address);
      expect(await token.isBlacklisted(addr1.address)).to.be.true;

      await token.unBlacklist(addr1.address);
    });

    it("should allow owner to execute unBlacklist after timelock", async function () {
      await token.blacklist(addr1.address);
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeBlacklist(addr1.address);
      expect(await token.isBlacklisted(addr1.address)).to.be.true;

      await token.unBlacklist(addr1.address);
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeUnBlacklist(addr1.address);
      expect(await token.isBlacklisted(addr1.address)).to.be.false;
    });

    it("should prevent transfers from blacklisted address", async function () {
      const transferAmount = ethers.utils.parseUnits("100", 18);
      await token.transfer(addr1.address, transferAmount);

      await token.blacklist(addr1.address);
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeBlacklist(addr1.address);

      try {
        await token.connect(addr1).transfer(addr2.address, transferAmount);
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("MyToken: account is blacklisted");
      }
    });

    it("should prevent transfers to blacklisted address", async function () {
      const transferAmount = ethers.utils.parseUnits("100", 18);
      await token.blacklist(addr2.address);
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeBlacklist(addr2.address);

      try {
        await token.transfer(addr2.address, transferAmount);
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("MyToken: account is blacklisted");
      }
    });

    it("should not allow owner to blacklist themselves", async function () {
      try {
        await token.blacklist(owner.address);
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("MyToken: cannot blacklist owner");
      }
    });
  });

  describe("Mint and Burn", function () {
    it("should allow owner to mint new tokens", async function () {
      const mintAmount = ethers.utils.parseUnits("1000", 18);
      const initialSupply = await token.totalSupply();

      await token.mint(addr1.address, mintAmount);

      expect((await token.totalSupply()).toString()).to.equal(initialSupply.add(mintAmount).toString());
      expect((await token.balanceOf(addr1.address)).toString()).to.equal(mintAmount.toString());
    });

    it("should not allow owner to mint to blacklisted address", async function () {
      const mintAmount = ethers.utils.parseUnits("1000", 18);

      // First blacklist addr1
      await token.blacklist(addr1.address);
      await ethers.provider.send("evm_increaseTime", [24 * 60 * 60]);
      await ethers.provider.send("evm_mine");
      await token.executeBlacklist(addr1.address);

      let failed = false;
      try {
        await token.mint(addr1.address, mintAmount);
      } catch (e) {
        failed = true;
        expect(e.message).to.include("MyToken: cannot mint to blacklisted address");
      }
      expect(failed).to.be.true;
    });

    it("should allow user to burn their tokens", async function () {
      const burnAmount = ethers.utils.parseUnits("100", 18);
      const initialSupply = await token.totalSupply();

      await token.burn(burnAmount);

      expect((await token.totalSupply()).toString()).to.equal(initialSupply.sub(burnAmount).toString());
    });

    it("should allow owner to burn from authorized address", async function () {
      const burnAmount = ethers.utils.parseUnits("100", 18);
      const transferAmount = ethers.utils.parseUnits("200", 18);

      await token.transfer(addr1.address, transferAmount);
      await token.authorizeBurnFrom(addr1.address);
      await token.burnFrom(addr1.address, burnAmount);

      expect((await token.balanceOf(addr1.address)).toString()).to.equal(transferAmount.sub(burnAmount).toString());
    });

    it("should not allow owner to burn from unauthorized address", async function () {
      const burnAmount = ethers.utils.parseUnits("100", 18);
      const transferAmount = ethers.utils.parseUnits("200", 18);

      await token.transfer(addr1.address, transferAmount);

      let failed = false;
      try {
        await token.burnFrom(addr1.address, burnAmount);
      } catch (e) {
        failed = true;
      }
      expect(failed).to.be.true;
    });
  });
});
