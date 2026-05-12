# Deployment Scripts

This directory contains scripts for deploying and managing the token contracts.

## Scripts

### 1. deploy-token.js
Deploys MyToken and TokenVesting contracts.

```bash
# Localhost
npx hardhat run scripts/deploy-token.js --network localhost

# Sepolia testnet
npx hardhat run scripts/deploy-token.js --network sepolia

# BSC testnet
npx hardhat run scripts/deploy-token.js --network bscTestnet

# Mainnet (BE CAREFUL!)
npx hardhat run scripts/deploy-token.js --network mainnet
```

### 2. add-liquidity.js
Prepares tokens for liquidity provision.

```bash
# Update LIQUIDITY_CONFIG in the script first!
npx hardhat run scripts/add-liquidity.js --network <network>
```

### 3. verify-contract.js
Verifies deployed contracts on block explorers.

```bash
# Update VERIFY_CONFIG in the script first!
npx hardhat run scripts/verify-contract.js --network <network>
```

## Workflow

### Local Development
1. Start local node: `npx hardhat node`
2. Deploy: `npx hardhat run scripts/deploy-token.js --network localhost`
3. Test interactions

### Testnet Deployment
1. Update `.env` with your private key and RPC URLs
2. Deploy: `npx hardhat run scripts/deploy-token.js --network sepolia`
3. Verify: `npx hardhat run scripts/verify-contract.js --network sepolia`
4. Add liquidity (via DEX UI for security)

### Mainnet Deployment
1. Double-check all configurations
2. Ensure you have sufficient ETH/BNB for gas
3. Deploy: `npx hardhat run scripts/deploy-token.js --network mainnet`
4. Verify: `npx hardhat run scripts/verify-contract.js --network mainnet`
5. Add liquidity (via DEX UI for security)
6. Lock LP tokens

## Security Notes

- Never commit private keys to version control
- Use hardware wallets for mainnet deployments
- Verify contracts on block explorers after deployment
- Lock LP tokens for minimum 12 months
- Consider multi-sig for contract ownership
