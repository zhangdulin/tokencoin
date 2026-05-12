/**
 * Verify Bytecode Script
 * Compares deployed bytecode with locally compiled bytecode
 *
 * Usage:
 *   npx hardhat run scripts/verify-bytecode.js --network bsc
 */

const hre = require("hardhat");
const ethers = hre.ethers;
const fs = require('fs');
const path = require('path');

async function main() {
  const MY_TOKEN = "0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B";

  console.log("=== Bytecode Verification ===\n");
  console.log("Network:", hre.network.name);

  // Get deployed bytecode
  console.log("\n1. Fetching deployed bytecode...");
  const deployedBytecode = await hre.ethers.provider.getCode(MY_TOKEN);
  console.log("Deployed bytecode length:", deployedBytecode.length, "bytes");
  console.log("First 100 chars:", deployedBytecode.slice(0, 100));

  // Get locally compiled bytecode
  console.log("\n2. Getting locally compiled bytecode...");
  const artifactPath = path.join(__dirname, '..', 'artifacts', 'contracts', 'token', 'MyToken.sol', 'MyToken.json');

  if (fs.existsSync(artifactPath)) {
    const artifact = JSON.parse(fs.readFileSync(artifactPath, 'utf8'));
    console.log("Artifact bytecode length:", artifact.bytecode.length, "bytes");
    console.log("First 100 chars:", artifact.bytecode.slice(0, 100));

    // Compare
    console.log("\n3. Comparison:");
    if (deployedBytecode === artifact.bytecode) {
      console.log("✅ Bytecode MATCHES exactly!");
    } else {
      console.log("❌ Bytecode MISMATCH");
      console.log("Deployed:", deployedBytecode.slice(0, 50));
      console.log("Local:   ", artifact.bytecode.slice(0, 50));
    }
  } else {
    console.log("❌ Artifact file not found at:", artifactPath);
    console.log("Run 'npx hardhat compile' first");
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
