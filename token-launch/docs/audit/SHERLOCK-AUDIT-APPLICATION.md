# Sherlock Audit Application - Tokencoin (TOKEN)

## Project Overview

| Item | Details |
|------|---------|
| **Project Name** | Tokencoin (TOKEN) |
| **Network** | Binance Smart Chain (BSC) |
| **Contract Type** | ERC-20 / BEP-20 Token with Vesting |
| **Source Code** | Solidity 0.8.24 |
| **License** | MIT |
| **Status** | MAINNET DEPLOYED |

## Contracts

### MyToken.sol
- **Address (Mainnet)**: `0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B`
- **Address (Testnet)**: `0x2D8b87AeC0d1984B30A7552167753D07D28c5e2E`
- **Total Supply**: 10,000,000,000 TOKEN
- **Features**: Pausable, Blacklist with Timelock, Transfer Limits, Anti-Bot, Anti-Whale, Cooldown System, Liquidity Lock, Flash Loan Protection

### TokenVesting.sol
- **Address (Mainnet)**: `0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934`
- **Address (Testnet)**: `0x93F5e8D1FFA4bFcd3E728D9C58C1AecE82ce64E2`
- **Features**: Linear Vesting, Cliff Period, Emergency Withdrawal with 2-Step + 48h Delay

## Security Architecture

### Timelock Protection (2-Step Execution)
All critical operations require timelock delay before execution:

| Operation | Delay |
|-----------|-------|
| `pause()` / `unpause()` | 2 hours |
| `blacklist()` / `unBlacklist()` | 2 hours |
| `setTransferLimits()` | 2 hours |
| `setMaxSellAmounts()` | 2 hours |
| `lockSupply()` | 2 hours |

### Anti-Bot Features
- Per-transaction transfer limits
- Per-wallet balance limits
- 24-hour sell limits
- Anti-whale sell protection
- Buy/Sell cooldown system
- Flash loan protection (configurable threshold)
- Known pairs validation

### Vesting Security
- Emergency withdrawal limited to **20% max** of locked tokens
- Withdrawal delay stored at request time (cannot be manipulated)
- Precision loss protection (capped at actual balance)

### Access Control
- **Gnosis Safe multi-sig** controls both contracts (2 of 2)
- All privileged operations require multi-sig approval
- All privileged operations emit events

## Security Audits Completed

| Date | Type | Status |
|------|------|--------|
| 2026-05-02 | Internal Security Review (AI-assisted) | ✅ 2 CRITICAL, 4 HIGH issues fixed |
| 2026-05-02 | Slither Static Analysis | ✅ 21 informational results (no critical/high issues) |
| 2026-05-02 | Test Suite | ✅ 51 tests passing |
| 2026-05-02 | Owner transferred to Gnosis Safe | ✅ Complete |

## Known Security Measures

1. **Reentrancy Protection**: `ReentrancyGuard` on TokenVesting.release()
2. **Overflow Protection**: Solidity 0.8.24 built-in checked math
3. **Pausable**: Emergency stop mechanism with timelock
4. **Blacklist**: Time-locked address restriction
5. **Transfer Limits**: Configurable per-transaction and per-wallet caps
6. **Supply Lock**: Permanent minting prevention option

## Deployment Configuration

### Mainnet (Current)
```javascript
Timelock Delay: 86400 seconds (24 hours)
Max Emergency Withdraw BPS: 500 (5%)
Emergency Withdraw Delay: 172800 seconds (48 hours)
Owner: Gnosis Safe (0x886A0ffE290c476F66dc05AACd854e5FD93fDA12)
```

## External Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| OpenZeppelin Contracts | ^4.9.0 | ERC20, Ownable, Pausable, ReentrancyGuard |
| OpenZeppelin Interfaces | ^4.9.0 | IERC20 |

## Audit Focus Areas

Please pay special attention to:

1. **TokenVesting.sol**
   - Vesting calculation precision
   - Emergency withdrawal logic
   - Locked tokens tracking

2. **MyToken.sol**
   - Timelock action scheduling/execution
   - Anti-bot/anti-whale bypass vectors
   - Flash loan protection effectiveness

3. **Integration**
   - Interaction between MyToken and TokenVesting
   - Front-running opportunities
   - MEV extraction possibilities

## Bounty Pool

**Recommended Bounty**: 10,000 - 25,000 USDC
**Distribution**: 50% Critical, 25% High, 15% Medium, 10% Low

## Contact

| Role | Info |
|------|------|
| Primary | Project team via GitHub |
| Documentation | `/docs/security-audit-report.md` |
| Tests | `/test/` directory |

## Links

- **Mainnet Explorer**: https://bscscan.com/
- **MyToken**: https://bscscan.com/address/0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B
- **TokenVesting**: https://bscscan.com/address/0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934
- **Gnosis Safe**: https://app.safe.global/home?safe=bsc:0x886A0ffE290c476F66dc05AACd854e5FD93fDA12
- **Testnet Explorer**: https://testnet.bscscan.com/
