# Tokencoin (TOKEN)

> Multi-chain ERC-20 Token with Linear Vesting

[![Audit](https://img.shields.io/badge/audit-requested-blue)](https://github.com)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-blue)](https://soliditylang.org)
[![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-5.0.0-blue)](https://openzeppelin.com)
[![Tests](https://img.shields.io/badge/tests-33%20passing-green)](https://github.com)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## Overview

**Tokencoin (TOKEN)** is a multi-chain token project planning to deploy on Solana, Ethereum, and BSC networks.

### Token Parameters

| Parameter | Value |
|-----------|-------|
| Name | Tokencoin |
| Symbol | TOKEN |
| Total Supply | 10,000,000,000 (10 billion) |
| Decimals | 18 |
| Standard | ERC-20 / BEP-20 |

## Contracts

| Contract | Description | Lines |
|----------|-------------|-------|
| [MyToken.sol](contracts/token/MyToken.sol) | ERC-20 with pause & blacklist | 125 |
| [TokenVesting.sol](contracts/token/TokenVesting.sol) | Linear vesting with cliff | 130 |

### MyToken Features

- Standard ERC-20 functionality
- **Pausable**: Owner can pause all transfers
- **Blacklist**: Owner can freeze specific addresses
- **Mintable**: Owner can mint new tokens
- **Burnable**: Anyone can burn their tokens

### TokenVesting Features

- Linear vesting over configurable duration
- Configurable cliff period (90 days default)
- Emergency withdrawal by owner
- Reentrancy protection

## Security

- Built with OpenZeppelin 5.0.0
- Solidity 0.8.24 (built-in overflow protection)
- Comprehensive test suite (33 passing tests)
- Manual security review completed
- Professional audit **in progress**

## Quick Start

### Install

```bash
npm install
```

### Compile

```bash
npx hardhat compile
```

### Test

```bash
npx hardhat test
```

### Deploy (Localhost)

```bash
npx hardhat node
npx hardhat run scripts/deploy-token.js --network localhost
```

## Documentation

- [Whitepaper](docs/marketing/whitepaper.md)
- [Token Economics](docs/legal/token-economics.md)
- [Audit Application Form](docs/audit/audit-application-form.md)

## Project Structure

```
token-launch/
├── contracts/
│   └── token/
│       ├── MyToken.sol
│       └── TokenVesting.sol
├── docs/
│   ├── audit/           # Audit related documents
│   ├── legal/           # Legal documents
│   └── marketing/       # Marketing materials
├── scripts/
│   ├── deploy-token.js
│   ├── add-liquidity.js
│   └── verify-contract.js
├── test/
│   └── token/
│       ├── MyToken.test.js
│       └── TokenVesting.test.js
├── hardhat.config.cjs
└── README.md
```

## Audit Status

| Item | Status |
|------|--------|
| Compilation | ✅ Passed |
| Unit Tests | ✅ 33/33 Passed |
| Solhint Analysis | ✅ 0 errors, 60 warnings |
| Manual Review | ✅ Passed |
| Professional Audit | 🔄 In Progress |

## Deployed Addresses (Testnet)

| Network | MyToken | TokenVesting |
|---------|---------|--------------|
| Sepolia | TBD | TBD |
| BSC Testnet | TBD | TBD |

## Token Allocation

```
Total Supply: 10,000,000,000 TOKEN

├── Liquidity:       20% (2,000,000,000)
├── Community:       40% (4,000,000,000)
├── Ecosystem:       20% (2,000,000,000)
├── Team:            10% (1,000,000,000) - 12 month lock
└── Private Sale:    10% (1,000,000,000) - 6 month lock
```

## Vesting Schedule

| Category | Cliff | Duration | Release |
|----------|-------|----------|---------|
| Team | 12 months | 24 months | Linear |
| Private Sale | 6 months | 12 months | Linear |
| Ecosystem | 6 months | 12 months | Linear |
| Community | None | TGE | As announced |

## Deployment Plan

1. **Solana** - Priority 1
2. **Ethereum** - Priority 2
3. **BSC** - Priority 3

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- Email: TBD
- Twitter: TBD
- Telegram: TBD

---

**Disclaimer**: This is a project in development. All contracts are subject to professional security audit before mainnet deployment.
