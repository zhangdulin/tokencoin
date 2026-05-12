/**
 * Deploy Token Script
 * Deploys MyToken and TokenVesting contracts to specified network
 *
 * Usage:
 *   npx hardhat run scripts/deploy-token.js --network <network>
 *
 * Networks: localhost, sepolia, bscTestnet, mainnet, bsc
 */

const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  // Configuration from environment or defaults
  const config = {
    name: process.env.TOKEN_NAME || "Tokencoin",
    symbol: process.env.TOKEN_SYMBOL || "TOKEN",
    decimals: parseInt(process.env.TOKEN_DECIMALS || "18"),
    initialSupply: ethers.utils.parseUnits(
      process.env.TOKEN_INITIAL_SUPPLY || "10000000000",
      18
    ),
    // Vesting config
    vestingDurationDays: parseInt(process.env.VESTING_DURATION_DAYS || "365"),
    vestingCliffDays: parseInt(process.env.VESTING_CLIFF_DAYS || "30"),
    // Timelock config
    timelockDelay: parseInt(process.env.TIMELOCK_DELAY || "7200"), // 2 hours default
    // Emergency withdraw config
    maxEmergencyWithdrawBps: parseInt(process.env.MAX_EMERGENCY_WITHDRAW_BPS || "1000"),
    emergencyWithdrawDelay: parseInt(process.env.EMERGENCY_WITHDRAW_DELAY || "172800"), // 48 hours default
  };

  const [deployer] = await ethers.getSigners();

  console.log("===========================================");
  console.log("Token Deployment");
  console.log("===========================================");
  console.log("Network:", hre.network.name);
  console.log("Deployer:", deployer.address);
  console.log("Balance:", ethers.utils.formatEther(await deployer.getBalance()));
  console.log("");
  console.log("Configuration:");
  console.log("  Timelock Delay:", config.timelockDelay, "seconds (", config.timelockDelay / 3600, "hours)");
  console.log("  Max Emergency Withdraw:", config.maxEmergencyWithdrawBps / 100, "%");
  console.log("  Emergency Withdraw Delay:", config.emergencyWithdrawDelay, "seconds (", config.emergencyWithdrawDelay / 3600, "hours)");
  console.log("===========================================\n");

  // Deploy MyToken
  console.log("1. Deploying MyToken...");
  const MyToken = await ethers.getContractFactory("MyToken");
  const token = await MyToken.deploy(
    config.name,
    config.symbol,
    config.initialSupply,
    deployer.address,
    config.timelockDelay
  );
  await token.deployed();
  console.log("   MyToken deployed to:", token.address);
  console.log("   Total Supply:", ethers.utils.formatUnits(await token.totalSupply(), config.decimals));

  // Deploy TokenVesting
  console.log("\n2. Deploying TokenVesting...");
  const TokenVesting = await ethers.getContractFactory("TokenVesting");
  const vesting = await TokenVesting.deploy(
    token.address,
    deployer.address,
    config.maxEmergencyWithdrawBps,
    config.emergencyWithdrawDelay
  );
  await vesting.deployed();
  console.log("   TokenVesting deployed to:", vesting.address);

  // Save deployment addresses
  const deploymentInfo = {
    network: hre.network.name,
    timestamp: new Date().toISOString(),
    deployer: deployer.address,
    contracts: {
      MyToken: token.address,
      TokenVesting: vesting.address,
    },
    config: {
      name: config.name,
      symbol: config.symbol,
      decimals: config.decimals,
      initialSupply: config.initialSupply.toString(),
      timelockDelay: config.timelockDelay,
      maxEmergencyWithdrawBps: config.maxEmergencyWithdrawBps,
      emergencyWithdrawDelay: config.emergencyWithdrawDelay,
    },
  };

  console.log("\n===========================================");
  console.log("Deployment Summary");
  console.log("===========================================");
  console.log("MyToken:       ", deploymentInfo.contracts.MyToken);
  console.log("TokenVesting:  ", deploymentInfo.contracts.TokenVesting);
  console.log("===========================================\n");

  // Verification instructions
  if (hre.network.name !== "localhost" && hre.network.name !== "hardhat") {
    console.log("Verification commands:");
    console.log(`  npx hardhat verify --network ${hre.network.name} ${token.address} "${config.name}" "${config.symbol}" ${config.initialSupply} ${deployer.address} ${config.timelockDelay}`);
    console.log(`  npx hardhat verify --network ${hre.network.name} ${vesting.address} ${token.address} ${deployer.address} ${config.maxEmergencyWithdrawBps} ${config.emergencyWithdrawDelay}`);
  }

  return deploymentInfo;
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
