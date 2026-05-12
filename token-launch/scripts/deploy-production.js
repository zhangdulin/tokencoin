/**
 * Production Deployment Script
 * Uses multi-signature wallet for ownership
 *
 * Usage:
 *   # Load production environment
 *   export $(cat .env.bscMainnet | xargs)
 *
 *   # Deploy to BSC mainnet
 *   npx hardhat run scripts/deploy-production.js --network bsc
 */

require("dotenv").config();
const hre = require("hardhat");

// Multi-sig configuration
const MULTISIG_CONFIG = {
  owner1: process.env.MULTISIG_OWNER1,
  owner2: process.env.MULTISIG_OWNER2,
  threshold: parseInt(process.env.OWNER_THRESHOLD || "2"),
};

// Contract configuration
const CONTRACT_CONFIG = {
  name: process.env.TOKEN_NAME || "Tokencoin",
  symbol: process.env.TOKEN_SYMBOL || "TOKEN",
  initialSupply: hre.ethers.utils.parseUnits(
    process.env.TOKEN_INITIAL_SUPPLY || "10000000000",
    18
  ),
  timelockDelay: parseInt(process.env.TIMELOCK_DELAY || "7200"), // 2 hours
  maxEmergencyWithdrawBps: parseInt(process.env.MAX_EMERGENCY_WITHDRAW_BPS || "500"), // 5%
  emergencyWithdrawDelay: parseInt(process.env.EMERGENCY_WITHDRAW_DELAY || "172800"), // 48 hours
};

async function main() {
  const network = hre.network.name;
  const isProd = network === 'bsc' || network === 'mainnet';

  console.log("===========================================");
  console.log("Production Deployment");
  console.log("===========================================");
  console.log("Network:", network);
  console.log("Production:", isProd ? "YES" : "NO");
  console.log("");

  // Validate production config
  if (isProd) {
    console.log("Multi-Sig Configuration:");
    console.log("  Safe Address:", MULTISIG_CONFIG.owner1);
    console.log("  Threshold:", MULTISIG_CONFIG.threshold, "of 2 (BOTH required)");
    console.log("");

    console.log("Contract Configuration:");
    console.log("  Timelock Delay:", CONTRACT_CONFIG.timelockDelay / 3600, "hours (", CONTRACT_CONFIG.timelockDelay, "seconds)");
    console.log("  Max Emergency Withdraw:", CONTRACT_CONFIG.maxEmergencyWithdrawBps / 100, "%");
    console.log("  Emergency Withdraw Delay:", CONTRACT_CONFIG.emergencyWithdrawDelay / 3600, "hours");
    console.log("");

    // Validate addresses
    if (!MULTISIG_CONFIG.owner1 || !MULTISIG_CONFIG.owner2) {
      console.error("ERROR: Multi-sig owners not configured!");
      console.error("Please set MULTISIG_OWNER1, MULTISIG_OWNER2 in .env.bscMainnet");
      process.exit(1);
    }
  }

  // Get deployer
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deployer:", deployer.address);
  console.log("Balance:", hre.ethers.utils.formatEther(await deployer.getBalance()), "ETH/BNB");
  console.log("");

  // Deploy MyToken
  console.log("1. Deploying MyToken...");
  const TokenFactory = await hre.ethers.getContractFactory("MyToken");
  const token = await TokenFactory.deploy(
    CONTRACT_CONFIG.name,
    CONTRACT_CONFIG.symbol,
    CONTRACT_CONFIG.initialSupply,
    deployer.address, // Temporary owner
    CONTRACT_CONFIG.timelockDelay
  );
  await token.deployed();
  console.log("   MyToken deployed to:", token.address);
  console.log("   Total Supply:", hre.ethers.utils.formatUnits(await token.totalSupply(), 18));
  console.log("");

  // Deploy TokenVesting
  console.log("2. Deploying TokenVesting...");
  const VestingFactory = await hre.ethers.getContractFactory("TokenVesting");
  const vesting = await VestingFactory.deploy(
    token.address,
    deployer.address, // Temporary owner
    CONTRACT_CONFIG.maxEmergencyWithdrawBps,
    CONTRACT_CONFIG.emergencyWithdrawDelay
  );
  await vesting.deployed();
  console.log("   TokenVesting deployed to:", vesting.address);
  console.log("");

  // Transfer ownership to multi-sig (production) or keep as deployer (testnet)
  if (isProd) {
    console.log("3. Transferring Ownership to Multi-Sig...");

    // Transfer MyToken ownership
    const tokenOwnerTx = await token.transferOwnership(MULTISIG_CONFIG.owner1);
    await tokenOwnerTx.wait();
    console.log("   MyToken owner ->", MULTISIG_CONFIG.owner1);

    // Transfer TokenVesting ownership
    const vestingOwnerTx = await vesting.transferOwnership(MULTISIG_CONFIG.owner1);
    await vestingOwnerTx.wait();
    console.log("   TokenVesting owner ->", MULTISIG_CONFIG.owner1);
  } else {
    console.log("3. Ownership kept at deployer address (testnet mode)");
  }
  console.log("");

  // Summary
  console.log("===========================================");
  console.log("Deployment Summary");
  console.log("===========================================");
  console.log("MyToken:", token.address);
  console.log("TokenVesting:", vesting.address);
  console.log("");

  // Verification commands
  console.log("Verification Commands:");
  console.log(`  npx hardhat verify --network ${network} ${token.address} "${CONTRACT_CONFIG.name}" "${CONTRACT_CONFIG.symbol}" ${CONTRACT_CONFIG.initialSupply} ${deployer.address} ${CONTRACT_CONFIG.timelockDelay}`);
  console.log(`  npx hardhat verify --network ${network} ${vesting.address} ${token.address} ${deployer.address} ${CONTRACT_CONFIG.maxEmergencyWithdrawBps} ${CONTRACT_CONFIG.emergencyWithdrawDelay}`);
  console.log("");

  // Save deployment addresses
  const deploymentInfo = {
    network,
    timestamp: new Date().toISOString(),
    deployer: deployer.address,
    contracts: {
      MyToken: token.address,
      TokenVesting: vesting.address,
    },
    config: {
      multiSig: {
        safeAddress: MULTISIG_CONFIG.owner1,
        threshold: MULTISIG_CONFIG.threshold,
      },
      tokenName: CONTRACT_CONFIG.name,
      tokenSymbol: CONTRACT_CONFIG.symbol,
      initialSupply: CONTRACT_CONFIG.initialSupply.toString(),
      timelockDelay: CONTRACT_CONFIG.timelockDelay,
      maxEmergencyWithdrawBps: CONTRACT_CONFIG.maxEmergencyWithdrawBps,
      emergencyWithdrawDelay: CONTRACT_CONFIG.emergencyWithdrawDelay,
    },
  };

  const fs = require("fs");
  const deploymentsDir = "./deployments";
  if (!fs.existsSync(deploymentsDir)) {
    fs.mkdirSync(deploymentsDir);
  }

  const filename = `${deploymentsDir}/${network}-${Date.now()}.json`;
  fs.writeFileSync(filename, JSON.stringify(deploymentInfo, null, 2));
  console.log("Deployment info saved to:", filename);

  console.log("");
  console.log("===========================================");
  console.log("Deployment Complete!");
  console.log("===========================================");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
