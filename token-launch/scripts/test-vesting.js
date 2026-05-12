const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  console.log("===========================================");
  console.log("Testing TokenVesting - Lock & Release");
  console.log("===========================================\n");

  const tokenAddress = "0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B";
  const vestingAddress = "0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934";

  // Attach to deployed contracts
  const token = await ethers.getContractAt("MyToken", tokenAddress);
  const vesting = await ethers.getContractAt("TokenVesting", vestingAddress);

  // Get signers
  const signers = await ethers.getSigners();
  const signer = signers[0];
  const beneficiary = signers[1] || signers[0];
  console.log("Owner:", signer.address);
  console.log("Beneficiary:", beneficiary.address);
  console.log("");

  // 1. Check if already initialized
  console.log("1. Checking Vesting Status...");
  const isInitialized = await vesting.isInitialized();
  console.log("   Already initialized:", isInitialized);

  if (!isInitialized) {
    // Transfer tokens to vesting contract
    console.log("\n2. Transferring tokens to Vesting contract...");
    const vestingAmount = ethers.utils.parseUnits("1000000", 18); // 100万代币
    const transferTx = await token.transfer(vestingAddress, vestingAmount);
    await transferTx.wait();
    console.log("   Transferred:", ethers.utils.formatUnits(vestingAmount, 18), "TOKEN to vesting");

    // Initialize vesting
    console.log("\n3. Initializing Vesting...");
    const duration = 365 * 24 * 60 * 60; // 1年
    const cliffDuration = 30 * 24 * 60 * 60; // 30天 cliff
    const initTx = await vesting.initializeVesting(
      beneficiary.address,
      vestingAmount,
      duration,
      cliffDuration
    );
    await initTx.wait();
    console.log("   Beneficiary:", beneficiary.address);
    console.log("   Total tokens:", ethers.utils.formatUnits(vestingAmount, 18));
    console.log("   Duration:", duration / (24 * 60 * 60), "days");
    console.log("   Cliff:", cliffDuration / (24 * 60 * 60), "days");
  } else {
    console.log("\n   Vesting already initialized, skipping setup");
  }
  console.log("");

  // 4. Get vesting details
  console.log("4. Vesting Details...");
  const totalTokens = await vesting.totalTokens();
  const vestBeneficiary = await vesting.beneficiary();
  const startTime = await vesting.startTime();
  const duration = await vesting.duration();
  const cliffDuration = await vesting.cliffDuration();
  const released = await vesting.released();
  const vestingBalance = await token.balanceOf(vestingAddress);

  console.log("   Beneficiary:", vestBeneficiary);
  console.log("   Total tokens:", ethers.utils.formatUnits(totalTokens, 18));
  console.log("   Duration:", duration / (24 * 60 * 60), "days");
  console.log("   Cliff:", cliffDuration / (24 * 60 * 60), "days");
  console.log("   Start time:", new Date(startTime.toNumber() * 1000).toISOString());
  console.log("   Already released:", ethers.utils.formatUnits(released, 18));
  console.log("   Contract balance:", ethers.utils.formatUnits(vestingBalance, 18));
  console.log("");

  // 5. Check releasable
  console.log("5. Checking Releasable Amount...");
  const releasable = await vesting.releasable();
  console.log("   Currently releasable:", ethers.utils.formatUnits(releasable, 18), "TOKEN");

  // Calculate time passed
  const now = Math.floor(Date.now() / 1000);
  const timePassed = now - startTime.toNumber();
  const cliffEnd = startTime.toNumber() + cliffDuration.toNumber();
  const vestEnd = startTime.toNumber() + duration.toNumber();

  console.log("   Time passed:", Math.floor(timePassed / (24 * 60 * 60)), "days");
  console.log("   Cliff ends:", new Date(cliffEnd * 1000).toISOString());
  console.log("   Vesting ends:", new Date(vestEnd * 1000).toISOString());

  if (now < cliffEnd) {
    const daysUntilCliff = Math.floor((cliffEnd - now) / (24 * 60 * 60));
    console.log("   Status: In cliff period. Unlocks in", daysUntilCliff, "days");
  } else if (now < vestEnd) {
    console.log("   Status: Active vesting period");
  } else {
    console.log("   Status: Vesting period ended");
  }
  console.log("");

  // 6. Test emergency withdraw limits
  console.log("6. Emergency Withdraw Configuration...");
  const maxBps = await vesting.maxEmergencyWithdrawBps();
  const emergencyDelay = await vesting.EMERGENCY_WITHDRAW_DELAY();
  console.log("   Max emergency withdraw:", maxBps.toNumber() / 100, "%");
  console.log("   Emergency delay:", emergencyDelay.toNumber() / (60 * 60), "hours");
  console.log("   Max withdraw amount:", ethers.utils.formatUnits(totalTokens.mul(maxBps).div(10000), 18), "TOKEN");
  console.log("");

  // 7. Show release transaction if releasable > 0
  if (releasable.gt(0)) {
    console.log("7. Releasing Tokens...");
    console.log("   To release:", ethers.utils.formatUnits(releasable, 18), "TOKEN");
    console.log("   Run: vesting.connect(beneficiary).release()");
  } else {
    console.log("7. No tokens available to release yet");
    console.log("   Wait until cliff period ends to start releasing");
  }
  console.log("");

  console.log("===========================================");
  console.log("Vesting Setup Verified!");
  console.log("===========================================");
  console.log("\nView on BSCScan:");
  console.log("- Token:", tokenAddress);
  console.log("- Vesting:", vestingAddress);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Error:", error.message);
    process.exit(1);
  });
