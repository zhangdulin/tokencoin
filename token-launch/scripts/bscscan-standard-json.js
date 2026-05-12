/**
 * BSCScan Standard JSON Input Generator
 * Generates the correct JSON input for BSCScan contract verification
 *
 * Usage:
 *   node scripts/bscscan-standard-json.js
 */

const fs = require('fs');
const path = require('path');

async function main() {
  const flattenedDir = path.join(__dirname, '..', 'flattened');

  // Compiler settings (must match hardhat.config.cjs)
  // Note: BSCScan doesn't support metadata.bytecodeFormat
  const compilerSettings = {
    optimizer: {
      enabled: true,
      runs: 200
    },
    evmVersion: "paris"
  };

  // Generate for MyToken
  console.log('=== MyToken Standard JSON Input ===\n');
  const myTokenContent = fs.readFileSync(path.join(flattenedDir, 'MyToken.sol'), 'utf8');

  // Remove the first line (Node.js warning) if present
  const cleanContent = myTokenContent.replace(/^WARNING:.*\n/, '');

  const myTokenJson = {
    language: "Solidity",
    sources: {
      "MyToken.sol": {
        content: cleanContent
      }
    },
    settings: compilerSettings
  };

  console.log(JSON.stringify(myTokenJson, null, 2));

  // Save to file
  const outputPath = path.join(flattenedDir, 'MyToken-standard-json.json');
  fs.writeFileSync(outputPath, JSON.stringify(myTokenJson, null, 2));
  console.log(`\nSaved to: ${outputPath}`);

  console.log('\n---\n');

  // Generate for TokenVesting
  console.log('=== TokenVesting Standard JSON Input ===\n');
  const tokenVestingContent = fs.readFileSync(path.join(flattenedDir, 'TokenVesting.sol'), 'utf8');
  const cleanVestingContent = tokenVestingContent.replace(/^WARNING:.*\n/, '');

  const tokenVestingJson = {
    language: "Solidity",
    sources: {
      "TokenVesting.sol": {
        content: cleanVestingContent
      }
    },
    settings: compilerSettings
  };

  console.log(JSON.stringify(tokenVestingJson, null, 2));

  const vestingOutputPath = path.join(flattenedDir, 'TokenVesting-standard-json.json');
  fs.writeFileSync(vestingOutputPath, JSON.stringify(tokenVestingJson, null, 2));
  console.log(`\nSaved to: ${vestingOutputPath}`);

  console.log('\n=== BSCScan Verification Steps ===');
  console.log('1. Go to https://bscscan.com/address/0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B#code');
  console.log('2. Click "Verify Contract"');
  console.log('3. Select "Solc (Standard JSON Input)"');
  console.log('4. Compiler Version: 0.8.24');
  console.log('5. For "Standard Input JSON", copy content from flattened/MyToken-standard-json.json');
  console.log('6. Click "Verify"');
}

main().catch(console.error);
