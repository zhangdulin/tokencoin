# Auditor Quick Reference - Tokencoin (TOKEN)

## Quick Facts

| Item | Value |
|------|-------|
| **Solidity** | 0.8.24 (overflow protection built-in) |
| **Total Supply** | 10,000,000,000 TOKEN |
| **Owner Model** | Single Ownable (Gnosis Safe recommended) |
| **Timelock** | 2 hours (testnet) / 24 hours (production) |

## Contract Addresses (BSC Testnet)

```
MyToken:      0x2D8b87AeC0d1984B30A7552167753D07D28c5e2E
TokenVesting: 0x93F5e8D1FFA4bFcd3E728D9C58C1AecE82ce64E2
```

## Key Security Mechanisms

### MyToken.sol
```
✅ Pausable with timelock
✅ Blacklist with timelock
✅ Transfer limits (per tx & per wallet)
✅ Anti-bot delay
✅ Anti-whale (sell limits)
✅ Buy/Sell cooldown
✅ Flash loan protection
✅ Router/Pair validation
✅ Supply lock (irreversible option)
```

### TokenVesting.sol
```
✅ Linear vesting with cliff
✅ Emergency withdrawal (2-step + delay)
✅ Max 20% of locked tokens per withdrawal
✅ Delay stored at request time
✅ ReentrancyGuard
```

## Critical Functions (Timelocked)

```solidity
// 2-step execution
schedulePause() → executePause()
scheduleBlacklist(addr) → executeBlacklist(addr)
setTransferLimits(a, b) → executeSetTransferLimits(a, b)
setMaxSellAmounts(a, b) → executeSetMaxSellAmounts(a, b)
lockSupply() → executeLockSupply()
```

## Recent Security Fixes (2026-05-02)

1. **Fixed**: Vesting precision loss → capped at actual balance
2. **Fixed**: Emergency withdraw now uses lockedTokens not totalTokens
3. **Fixed**: Daily mint limit actually enforced
4. **Added**: Timelock to lockSupply, setTransferLimits, setMaxSellAmounts
5. **Added**: emergencyWithdrawDelayAtRequest prevents delay manipulation

## Test Results

```
51 tests passing
Slither: 23 informational (no critical/high issues)
Coverage: Core functions fully tested
```

## Files for Review

```
contracts/token/MyToken.sol      (~760 lines)
contracts/token/TokenVesting.sol (~280 lines)
test/token/MyToken.test.js
test/token/TokenVesting.test.js
docs/security-audit-report.md
```

## Known Trade-offs

| Feature | Design Choice | Rationale |
|---------|---------------|-----------|
| Single owner | Simplicity for MVP | Multi-sig recommended for production |
| timestamp-based daily limits | Gas efficiency | Accepted risk for non-financial limits |
| Known pairs for cooldowns | DEX compatibility | May miss P2P transfers |

---

*For full documentation, see /docs/security-audit-report.md*
