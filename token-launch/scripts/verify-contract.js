/**
 * Verify Contract Script
 * Verifies deployed contracts on Etherscan/BSCScan
 *
 * Usage:
 *   npx hardhat run scripts/verify-contract.js --network <network>
 *
 * Note: Run AFTER successful deployment
 */

const hre = require("hardhat");

// Configuration - UPDATE THESE AFTER DEPLOYMENT
const VERIFY_CONFIG = {
  tokenAddress: "YOUR_TOKEN_ADDRESS",
  vestingAddress: "YOUR_VESTING_ADDRESS",
  deployerAddress: "YOUR_DEPLOYER_ADDRESS",
  tokenName: "Tokencoin",
  tokenSymbol: "TOKEN",
  initialSupply: "10000000000000000000000000000", // 10 billion * 10^18 in wei
};

async function main() {
  console.log("===========================================");
  console.log("Contract Verification");
  console.log("===========================================");
  console.log("Network:", hre.network.name);
  console.log("===========================================\n");

  if (hre.network.name === "localhost" || hre.network.name === "hardhat") {
    console.log("Skipping verification for local network");
    return;
  }

  try {
    // Verify MyToken
    console.log("1. Verifying MyToken...");
    console.log("   Address:", VERIFY_CONFIG.tokenAddress);
    console.log("   Constructor args:", [
      VERIFY_CONFIG.tokenName,
      VERIFY_CONFIG.tokenSymbol,
      VERIFY_CONFIG.initialSupply,
      VERIFY_CONFIG.deployerAddress,
    ]);

    await hre.run("verify:verify", {
      address: VERIFY_CONFIG.tokenAddress,
      constructorArguments: [
        VERIFY_CONFIG.tokenName,
        VERIFY_CONFIG.tokenSymbol,
        VERIFY_CONFIG.initialSupply,
        VERIFY_CONFIG.deployerAddress,
      ],
    });
    console.log("   MyToken verified successfully!");

    // Verify TokenVesting
    console.log("\n2. Verifying TokenVesting...");
    console.log("   Address:", VERIFY_CONFIG.vestingAddress);
    console.log("   Constructor args:", [VERIFY_CONFIG.tokenAddress, VERIFY_CONFIG.deployerAddress]);

    await hre.run("verify:verify", {
      address: VERIFY_CONFIG.vestingAddress,
      constructorArguments: [VERIFY_CONFIG.tokenAddress, VERIFY_CONFIG.deployerAddress],
    });
    console.log("   TokenVesting verified successfully!");

    console.log("\n===========================================");
    console.log("Verification Complete!");
    console.log("===========================================");
  } catch (error) {
    console.error("Verification failed:", error.message);
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
