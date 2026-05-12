/**
 * Add Liquidity Script
 * Prepares tokens for liquidity provision on DEX
 *
 * Usage:
 *   npx hardhat run scripts/add-liquidity.js --network <network>
 *
 * Note: This script transfers tokens to a liquidity address.
 *       Actual liquidity provision should be done on the DEX UI for security.
 */

const hre = require("hardhat");

// Liquidity configuration - UPDATE THESE VALUES
const LIQUIDITY_CONFIG = {
  tokenAddress: "TOKEN_ADDRESS", // Update after deployment
  liquidityAmount: hre.ethers.utils.parseUnits("100000", 18), // Amount for liquidity
  liquidityRecipient: "RECIPIENT_ADDRESS", // Update with your address
};

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("===========================================");
  console.log("Liquidity Preparation");
  console.log("===========================================");
  console.log("Network:", hre.network.name);
  console.log("Token Address:", LIQUIDITY_CONFIG.tokenAddress);
  console.log("Amount:", hre.ethers.utils.formatUnits(LIQUIDITY_CONFIG.liquidityAmount, 18));
  console.log("Recipient:", LIQUIDITY_CONFIG.liquidityRecipient);
  console.log("===========================================\n");

  // Get token contract
  const token = await hre.ethers.getContractAt("MyToken", LIQUIDITY_CONFIG.tokenAddress);

  // Check deployer balance
  const balance = await token.balanceOf(deployer.address);
  console.log("Deployer balance:", hre.ethers.utils.formatUnits(balance, 18));

  if (balance.lt(LIQUIDITY_CONFIG.liquidityAmount)) {
    console.error("Insufficient balance for liquidity!");
    process.exit(1);
  }

  // Transfer tokens for liquidity
  console.log("\nTransferring tokens for liquidity...");
  const tx = await token.transfer(
    LIQUIDITY_CONFIG.liquidityRecipient,
    LIQUIDITY_CONFIG.liquidityAmount
  );
  await tx.wait();

  console.log("Transfer complete!");
  console.log("Transaction:", tx.hash);

  // Verify transfer
  const recipientBalance = await token.balanceOf(LIQUIDITY_CONFIG.liquidityRecipient);
  console.log("\nRecipient balance:", hre.ethers.utils.formatUnits(recipientBalance, 18));

  console.log("\n===========================================");
  console.log("Next Steps");
  console.log("===========================================");
  console.log("1. Go to Uniswap (Ethereum) or PancakeSwap (BSC)");
  console.log("2. Connect your wallet");
  console.log("3. Add liquidity for TOKEN/USDT, TOKEN/ETH, or TOKEN/BNB");
  console.log("4. Lock LP tokens for at least 12 months");
  console.log("===========================================\n");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
