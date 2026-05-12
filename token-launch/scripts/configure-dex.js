/**
 * Configure DEX Script
 * Configures MyToken contract after adding PancakeSwap liquidity
 *
 * Usage:
 *   npx hardhat run scripts/configure-dex.js --network bsc
 *
 * Note: After running, use Gnosis Safe to execute the transactions
 */

const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  // MyToken contract address
  const MY_TOKEN = "0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B";

  // PancakeSwap Router V2 address
  const PANCAKE_ROUTER = "0x10ED43C718714eb63d5aA57B78B54788E80F2";

  // LP Pair address (您需要替换为实际的LP Pair地址)
  // 在PancakeSwap添加流动性后，可以从交易记录中找到
  const LP_PAIR = "0x91F041DC6fd47Cd54cd3FCBDf120C4938aa23597";

  console.log("===========================================");
  console.log("DEX Configuration Script");
  console.log("===========================================");
  console.log("Network:", hre.network.name);
  console.log("MyToken:", MY_TOKEN);
  console.log("===========================================\n");

  // Get contract
  const MyToken = await ethers.getContractFactory("MyToken");
  const token = MyToken.attach(MY_TOKEN);

  console.log("Current Configuration:");
  console.log("  liquidityPair:", await token.liquidityPair());
  console.log("  maxTransferAmount:", ethers.utils.formatUnits(await token.maxTransferAmount(), 18));
  console.log("  maxWalletBalance:", ethers.utils.formatUnits(await token.maxWalletBalance(), 18));
  console.log("  antiBotDelay:", (await token.antiBotDelay()).toString());
  console.log("  buyCooldown:", (await token.buyCooldown()).toString());
  console.log("  sellCooldown:", (await token.sellCooldown()).toString());
  console.log("  flashLoanProtectionEnabled:", await token.flashLoanProtectionEnabled());
  console.log("");

  console.log("===========================================");
  console.log("Recommended Configuration After Liquidity:");
  console.log("===========================================");
  console.log("");
  console.log("1. Set LP Pair Address:");
  console.log(`   token.setLiquidityPair("${LP_PAIR}")`);
  console.log("");
  console.log("2. Exclude LP from transfer limits:");
  console.log(`   token.setExcludedFromLimits("${LP_PAIR}", true)`);
  console.log("");
  console.log('3. Set reasonable transfer limits:');
  console.log('   token.setTransferLimits("10000000000", "100000000000")');
  console.log('   // Max 10,000 TOKEN per tx, Max 100,000 TOKEN per wallet');
  console.log("");
  console.log("4. Set cooldown (60 seconds):");
  console.log("   token.setBuyCooldown(60)");
  console.log("   token.setSellCooldown(60)");
  console.log("");
  console.log("5. Enable flash loan protection (1%):");
  console.log("   token.enableFlashLoanProtection(100)");
  console.log("");
  console.log("6. Lock liquidity (1 year):");
  const oneYearLater = Math.floor(Date.now() / 1000) + 365 * 24 * 60 * 60;
  console.log(`   token.lockLiquidity(${oneYearLater})`);
  console.log("");
  console.log("===========================================");
  console.log("IMPORTANT: These must be executed via Gnosis Safe!");
  console.log("===========================================\n");

  console.log("Finding LP Pair automatically...");
  // Try to find LP pair from Router
  try {
    // This would need the actual token addresses to compute pair
    console.log("LP Pair address needs to be determined from your PancakeSwap transaction.");
    console.log("Check your wallet transaction history on BSCScan for the AddLiquidity call.");
  } catch (error) {
    console.log("Could not auto-detect LP pair");
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
