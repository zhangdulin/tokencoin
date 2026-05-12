const { ethers } = require("hardhat");
const { expect } = require("chai");

describe("Lock", function () {
  async function deployOneYearLockFixture() {
    const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
    const ONE_GWEI = 1_000_000_000;

    const provider = ethers.provider;
    const unlockTime = (await provider.getBlock("latest")).timestamp + ONE_YEAR_IN_SECS;

    const Lock = await ethers.getContractFactory("Lock");
    const lock = await Lock.deploy(unlockTime, { value: ONE_GWEI });

    return { lock, unlockTime, ONE_GWEI };
  }

  describe("Deployment", function () {
    it("should set the correct unlockTime", async function () {
      const { lock, unlockTime } = await deployOneYearLockFixture();
      expect((await lock.unlockTime()).toString()).to.equal(unlockTime.toString());
    });

    it("should set the correct owner", async function () {
      const { lock } = await deployOneYearLockFixture();
      const [owner] = await ethers.getSigners();
      expect(await lock.owner()).to.equal(owner.address);
    });
  });

  describe("Withdrawals", function () {
    it("should revert with the right error if called too soon", async function () {
      const { lock } = await deployOneYearLockFixture();
      try {
        await lock.withdraw();
        expect.fail("Should have reverted");
      } catch (err) {
        expect(err.message).to.include("you can't withdraw yet");
      }
    });

    it("should succeed after the unlock time", async function () {
      const { lock, unlockTime } = await deployOneYearLockFixture();

      await ethers.provider.send("evm_increaseTime", [unlockTime]);
      await ethers.provider.send("evm_mine", []);

      // Should not revert
      await lock.withdraw();
      expect(true).to.be.true;
    });
  });
});
