/**
 * Transfer Ownership Script
 * Transfers contract ownership to Gnosis Safe multi-sig wallet
 *
 * Usage:
 *   npx hardhat run scripts/transfer-ownership.js --network bsc
 */

const hre = require("hardhat");
const ethers = hre.ethers;

async function main() {
  // Gnosis Safe address
  const NEW_OWNER = "0x886A0ffE290c476F66dc05AACd854e5FD93fDA12";

  // Contract addresses from deployment
  const MY_TOKEN = "0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B";
  const TOKEN_VESTING = "0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934";

  const [deployer] = await ethers.getSigners();

  console.log("===========================================");
  console.log("Transfer Ownership to Gnosis Safe");
  console.log("===========================================");
  console.log("Network:", hre.network.name);
  console.log("Deployer:", deployer.address);
  console.log("New Owner:", NEW_OWNER);
  console.log("===========================================\n");

  // Get contracts
  const MyToken = await ethers.getContractFactory("MyToken");
  const TokenVesting = await ethers.getContractFactory("TokenVesting");

  const token = MyToken.attach(MY_TOKEN);
  const vesting = TokenVesting.attach(TOKEN_VESTING);

  // Check current owners
  console.log("Current Owners:");
  console.log("  MyToken owner:", await token.owner());
  console.log("  TokenVesting owner:", await vesting.owner());
  console.log("");

  // Transfer MyToken ownership
  console.log("1. Transferring MyToken ownership...");
  const tx1 = await token.connect(deployer).transferOwnership(NEW_OWNER);
  await tx1.wait();
  console.log("   Success! New owner:", await token.owner());
  console.log("   TX:", tx1.hash);
  console.log("");

  // Transfer TokenVesting ownership
  console.log("2. Transferring TokenVesting ownership...");
  const tx2 = await vesting.connect(deployer).transferOwnership(NEW_OWNER);
  await tx2.wait();
  console.log("   Success! New owner:", await vesting.owner());
  console.log("   TX:", tx2.hash);
  console.log("");

  console.log("===========================================");
  console.log("Ownership Transfer Complete!");
  console.log("===========================================");
  console.log("Both contracts are now controlled by Gnosis Safe:");
  console.log("  ", NEW_OWNER);
  console.log("");
  console.log("IMPORTANT: All future admin actions require");
  console.log("Gnosis Safe multi-sig approval (2 of 2).");
  console.log("===========================================\n");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
