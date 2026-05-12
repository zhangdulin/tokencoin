# PancakeSwap Liquidity Setup Guide

## Prerequisites
1. TOKEN has been deployed and verified on BSC
2. You have BNB for gas fees
3. You have TOKEN and BNB for liquidity provision

## Contract Configuration

### Add Liquidity Pair to MyToken

After providing liquidity on PancakeSwap, update the contract:

```javascript
// Set the LP pair address (PancakeSwap V2 pair)
await token.setLiquidityPair("0x...your-LP-pair-address...");

// Lock liquidity for 1 year
await token.lockLiquidity(Math.floor(Date.now() / 1000) + 365 * 24 * 60 * 60);
```

### Recommended Configuration

```javascript
// Set transfer limits for trading
await token.setTransferLimits(
  "10000000000",    // Max per transfer: 10,000 TOKEN
  "100000000000"    // Max per wallet: 100,000 TOKEN
);

// Set cooldown
await token.setBuyCooldown(60);   // 60 seconds buy cooldown
await token.setSellCooldown(60);  // 60 seconds sell cooldown

// Enable flash loan protection
await token.enableFlashLoanProtection(100);  // 1% of supply max
```

## PancakeSwap Setup Steps

### 1. Create Trading Pair
1. Go to https://pancakeswap.finance/
2. Connect your wallet
3. Go to "Trade" > "Liquidity"
4. Click "Add Liquidity"
5. Select TOKEN and BNB (or USDT)
6. Enter amounts and confirm

### 2. Get LP Pair Address
1. After adding liquidity, you receive LP tokens
2. LP pair address: https://docs.pcs.org/contracts/pair-addresses
3. Or find it on BSCScan in your transaction logs

### 3. Configure Contract (via Gnosis Safe)

Call these functions through your Gnosis Safe:

```
setLiquidityPair(address pair)
setExcludedFromLimits(address, true)  // Exclude LP pair from limits
lockLiquidity(uint256 unlockTimestamp)
```

## Security Notes

- Lock LP tokens to prevent rug pulls
- Set reasonable transfer limits
- Enable anti-bot protection
- Configure knownPairs for cooldown system

## Contract Addresses (Mainnet)

| Contract | Address |
|----------|---------|
| MyToken | 0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B |
| TokenVesting | 0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934 |
| Gnosis Safe | 0x886A0ffE290c476F66dc05AACd854e5FD93fDA12 |
| PancakeSwap Router | 0x10ED43C718714eb63d5aA57B78B54788E80F2 |
