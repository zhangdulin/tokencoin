# Tokencoin (TOKEN)

> Multi-chain ERC-20 Token with Linear Vesting — 目标：在主流交易所发行安全合规的加密货币代币

[![Solidity](https://img.shields.io/badge/Solidity-0.8.24-blue)](https://soliditylang.org)
[![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-5.0.0-blue)](https://openzeppelin.com)
[![Tests](https://img.shields.io/badge/tests-29%20passing-green)](https://github.com)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

## 项目概述

**Tokencoin (TOKEN)** 是一个多链代币项目，计划在 Solana、Ethereum 和 BSC 网络部署，目标是在 >= 3 家主流 CEX 上市。

### 代币参数

| 参数 | 值 |
|------|-----|
| 名称 | Tokencoin |
| 符号 | TOKEN |
| 总供应量 | 10,000,000,000 (100亿) |
| 小数位数 | 18 |
| 标准 | ERC-20 / BEP-20 |

### 代币分配

```
总供应量: 10,000,000,000 TOKEN
├── 社区激励 (Community):  40% (4,000,000,000)
├── 生态系统 (Ecosystem):  20% (2,000,000,000)
├── 流动性 (Liquidity):     20% (2,000,000,000)
├── 团队 (Team):            10% (1,000,000,000) — 锁仓 12 个月
└── 私募 (Private Sale):    10% (1,000,000,000) — 锁仓 6 个月
```

### 锁仓释放机制

| 类别 | 锁仓期 | 释放期 | 释放方式 |
|------|--------|--------|---------|
| 团队 | 12 个月 | 24 个月 | 线性释放 |
| 私募 | 6 个月 | 12 个月 | 线性释放 |
| 生态系统 | 6 个月 | 12 个月 | 线性释放 |
| 社区 | 无 | TGE | 另行公布 |

## 智能合约

| 合约 | 描述 | 代码行数 |
|------|------|---------|
| [MyToken.sol](token-launch/contracts/token/MyToken.sol) | ERC-20 + 暂停 + 黑名单 | ~125 |
| [TokenVesting.sol](token-launch/contracts/token/TokenVesting.sol) | 线性锁仓释放 | ~130 |

### MyToken 功能

- 标准 ERC-20 转账功能
- **暂停 (Pausable)**: Owner 可暂停所有转账
- **黑名单 (Blacklist)**: Owner 可冻结特定地址
- **铸造 (Mintable)**: Owner 可铸造新代币
- **燃烧 (Burnable)**: 任何人均可燃烧自己的代币

### TokenVesting 功能

- 可配置锁仓期（默认 90 天）
- 可配置释放期（默认 365 天）
- Owner 紧急提取
- 重入攻击防护

## 安全

- 使用 OpenZeppelin 5.0.0
- Solidity 0.8.24（内置溢出保护）
- 29 个测试用例全部通过
- Solhint 静态分析：0 错误，60 警告（无严重漏洞）
- 手动安全审查通过
- **专业审计申请进行中**

## 项目状态

| 项目 | 状态 | 完成日期 |
|------|------|---------|
| Phase 0: 环境准备 | ✅ 完成 | 2026-04-22 |
| Phase 1: 代币合约开发 | ✅ 完成 | 2026-04-22 |
| Phase 2: 部署脚本开发 | ✅ 完成 | 2026-04-22 |
| Phase 3: 测试网部署 | ⏭ 跳过 | 需要 API Key |
| Phase 4: 主网部署准备 | 🔄 进行中 | 审计申请待开始 |
| Phase 5: 主网部署 | ⏳ 待开始 | — |
| Phase 6: 交易所申请 | ⏳ 待开始 | Binance / Coinbase / Kraken |

## 快速开始

### 安装依赖

```bash
cd token-launch
npm install
```

### 编译合约

```bash
npx hardhat compile
```

### 运行测试

```bash
npx hardhat test
```

### 本地部署

```bash
npx hardhat node
npx hardhat run scripts/deploy-token.js --network localhost
```

## 项目结构

```
.
├── memory-bank/              # 项目文档与进度
│   ├── architecture.md       # 架构记录
│   ├── game-design-document.md  # 代币设计文档
│   ├── implementation-plan.md  # 实施计划
│   └── progress.md           # 进度记录
├── token-launch/             # 智能合约代码
│   ├── contracts/
│   │   └── token/
│   │       ├── MyToken.sol
│   │       └── TokenVesting.sol
│   ├── scripts/
│   │   ├── deploy-token.js
│   │   ├── add-liquidity.js
│   │   └── verify-contract.js
│   ├── test/
│   │   └── token/
│   │       ├── MyToken.test.js
│   │       └── TokenVesting.test.js
│   ├── docs/                 # 审计/法律/市场文档
│   ├── hardhat.config.cjs
│   └── package.json
└── README.md
```

## 技术栈

| 组件 | 版本 |
|------|------|
| Hardhat | 2.22.18 |
| ethers.js | 5.7.2 |
| OpenZeppelin | 5.0.0 |
| Solidity | 0.8.24 |
| Node.js | >= 18.0.0 |

## 部署计划

1. **Solana** — 优先级 ★★★★★
2. **Ethereum** — 优先级 ★★★★☆
3. **BSC** — 优先级 ★★★☆☆

## 交易所目标

**第一梯队**: Binance, Coinbase, Kraken
**第二梯队**: OKX, Bybit, KuCoin, Gate.io
**DEX**: Uniswap, PancakeSwap, Raydium

## 文档

- [白皮书](token-launch/docs/marketing/whitepaper.md)
- [代币经济学](token-launch/docs/legal/token-economics.md)
- [审计申请表](token-launch/docs/audit/audit-application-form.md)

## License

MIT License — 参见 [LICENSE](LICENSE)

---

**免责声明**: 本项目正在开发中。主网部署前所有合约均需完成专业安全审计。
