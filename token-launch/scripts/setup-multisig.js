/**
 * Multi-Sig Wallet Setup Guide
 *
 * This script shows how to configure multi-signature wallet for production
 *
 * STEP 1: Create Gnosis Safe Multi-Sig
 * ------------------------------------
 * 1. Go to https://app.safe.global/welcome
 * 2. Create new Safe with 2 owners
 * 3. Set threshold to 2 (requires BOTH signatures)
 *
 * STEP 2: Get your Safe address
 * ------------------------------------
 * Your Safe address will be the main wallet that owns the contracts
 *
 * STEP 3: Get owner addresses
 * ------------------------------------
 * Export private keys from your owner wallets
 * These are used by Hardhat to sign transactions
 *
 * STEP 4: Update .env.bscMainnet
 * ------------------------------------
 * MULTISIG_OWNER1=<Owner1 Address>
 * MULTISIG_OWNER2=<Owner2 Address>
 * PRIVATE_KEY=<Owner1 private key>
 * OWNER_THRESHOLD=2
 *
 * STEP 5: Deploy to mainnet
 * ------------------------------------
 * export $(cat .env.bscMainnet | xargs)
 * npx hardhat run scripts/deploy-production.js --network bsc
 */

const MULTISIG_GUIDE = `
╔══════════════════════════════════════════════════════════════╗
║              MULTI-SIG WALLET SETUP GUIDE                   ║
╠══════════════════════════════════════════════════════════════╣
║                                                              ║
║  1. CREATE GNOSIS SAFE                                      ║
║     → https://app.safe.global/welcome                        ║
║     → Create new Safe                                       ║
║     → Add 2 owner wallets                                   ║
║     → Set threshold to 2 (BOTH required)                   ║
║                                                              ║
║  2. COLLECT ADDRESSES                                       ║
║     → Safe Address: The multi-sig wallet address            ║
║     → Owner 1: Address of first owner                        ║
║     → Owner 2: Address of second owner                      ║
║                                                              ║
║  3. UPDATE .env.bscMainnet                                  ║
║     MULTISIG_OWNER1=0x...                                   ║
║     MULTISIG_OWNER2=0x...                                   ║
║     OWNER_THRESHOLD=2                                        ║
║                                                              ║
║  4. DEPLOY                                                  ║
║     export $(cat .env.bscMainnet | xargs)                   ║
║     npx hardhat run scripts/deploy-production.js --network bsc║
║                                                              ║
║  PRODUCTION CONFIGURATION                                    ║
║  ─────────────────────────────────                          ║
║  Timelock Delay:        2 hours (7200 seconds)           ║
║  Owner Threshold:       2 of 2 owners (BOTH required)       ║
║  Max Emergency Withdraw: 5% of vested tokens                 ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
`;

console.log(MULTISIG_GUIDE);

// Configuration for production
const PRODUCTION_CONFIG = {
  timelockDelay: 43200,      // 12 hours in seconds
  ownerThreshold: 2,         // 2 of 2 signatures required (both owners)
  maxEmergencyWithdrawBps: 500, // 5%
};

console.log("\nProduction Configuration:");
console.log(JSON.stringify(PRODUCTION_CONFIG, null, 2));
