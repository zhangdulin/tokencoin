# Security Disclosure Policy - Tokencoin (TOKEN)

## Bug Bounty Program

We appreciate responsible disclosure of security vulnerabilities in our smart contracts.

## Scope

### In-Scope Contracts
- `contracts/token/MyToken.sol`
- `contracts/token/TokenVesting.sol`

### Out-of-Scope
- `contracts/Lock.sol` (example/unittest contract)
- Third-party dependencies (OpenZeppelin)
- Test files

## Severity Classification

| Severity | Criteria | Bounty |
|----------|----------|--------|
| **Critical** | Fund loss, permanent lock, unauthorized minting | 10,000+ USDC |
| **High** | Temporary fund loss, pause bypass | 5,000 USDC |
| **Medium** | Economic attacks, limit bypass | 1,000 USDC |
| **Low** | Informational, gas optimization | 100 USDC |

## Critical Security Features

### Timelock Protection
All privileged operations use 2-step execution with configurable delay.

### Emergency Mechanisms
- Pause/Unpause with timelock
- Blacklist with timelock
- Emergency withdrawal with 48h delay and 20% cap

### Anti-Bot Protection
- Transfer limits
- Cooldown system
- Flash loan protection
- Router validation

## Disclosure Process

1. **Report**: Email security@tokencoin.example (replace with actual)
2. **Response**: Within 24 hours acknowledgment
3. **Assessment**: 7 days for severity classification
4. **Resolution**: 30 days for critical issues
5. **Public**: Credit given after resolution (if desired)

## Safe Harbor

Actions taken in accordance with this policy will not be pursued legally.

## Security Audit History

| Date | Auditor | Report |
|------|---------|--------|
| 2026-05-02 | Internal + Slither | All critical issues resolved |

---

*Last Updated: 2026-05-02*
