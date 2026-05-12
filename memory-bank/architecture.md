# 架构记录 / Architecture Records

> **重要**: 每次完成重大功能或里程碑后，必须更新此文档。

---

## 当前架构 / Current Architecture

### 项目结构

```
token-launch/
├── contracts/           # 智能合约
│   ├── token/         # 代币合约
│   │   ├── MyToken.sol      # 主代币合约 (ERC20 + Pausable + Blacklist)
│   │   └── TokenVesting.sol # 锁仓释放合约
│   └── interfaces/    # 接口定义 (待创建)
├── scripts/            # 部署脚本
│   ├── deploy-token.js      # 部署代币合约
│   ├── add-liquidity.js    # 流动性准备
│   ├── verify-contract.js   # 验证合约
│   └── README.md           # 脚本说明
├── test/               # 测试
│   ├── Lock.js             # 示例测试
│   └── token/             # 代币测试
│       ├── MyToken.test.js
│       └── TokenVesting.test.js
├── config/             # 配置 (待创建)
├── artifacts/          # 编译产物
├── cache/              # 缓存
├── .env                # 环境变量 (包含敏感信息)
├── .env.example        # 环境变量模板
└── hardhat.config.cjs # Hardhat 配置
```

### 技术栈

| 组件 | 版本 | 说明 |
|------|------|------|
| Hardhat | 2.22.18 | 开发框架 |
| ethers.js | 5.7.2 | 以太坊库 |
| OpenZeppelin | 5.0.0 | 安全智能合约库 |
| Solidity | 0.8.24 | 合约语言 |
| Node.js | 22.14.0 | 运行时 (推荐) |

### 多链部署顺序

1. **Solana** (优先级最高)
2. **Ethereum**
3. **BSC**

### 合约架构 / Contract Architecture

```
contracts/token/
├── MyToken.sol         # 主代币合约 (123 行)
│   ├── 继承: ERC20, ERC20Pausable, Ownable
│   ├── 功能: 转账、暂停、黑名单、铸造、燃烧
│   └── 标准: ERC-20
│
└── TokenVesting.sol    # 锁仓释放合约 (128 行)
    ├── 继承: Ownable, ReentrancyGuard
    ├── 功能: 线性释放、悬崖期、紧急提取
    └── 接口: IERC20
```

---

## 设计决策 / Design Decisions

| 日期 | 决策 | 原因 | 影响 |
|------|------|------|------|
| 2026-04-22 | 使用 Hardhat 2.22.18 | Node 23 不兼容 Hardhat 3 | 稳定开发环境 |
| 2026-04-22 | 使用 ethers v5 | 与 hardhat-waffle 兼容 | 测试框架稳定 |
| 2026-04-22 | 使用 .cjs 配置 | CommonJS 模块格式 | 避免 ESM 冲突 |
| 2026-04-22 | OpenZeppelin 5.0 | Ownable 需构造函数参数 | 合约构造函数更新 |
| 2026-04-22 | 使用 ERC20Pausable | OpenZeppelin 5.0 新的暂停机制 | _update 替代 _beforeTokenTransfer |

---

## 技术债务 / Technical Debt

| 项目 | 描述 | 优先级 | 计划解决 |
|------|------|--------|---------|
| Slither 集成 | 网络受限，使用 Solhint 替代 | 中 | 主网部署前完成 (建议使用无代理环境) |
| Presale 合约 | 预售合约尚未创建 | 低 | 可选 |
| 接口分离 | IERC20 等接口独立文件 | 低 | 重构时 |
| Hardhat 节点后台运行 | 需要持久化方案 | 低 | 可选 |
| NatSpec 文档完善 | 60 个警告 (建议添加完整注释) | 低 | 上市前 |

---

## 性能指标 / Performance Metrics

| 指标 | 当前值 | 目标值 | 状态 |
|------|--------|--------|------|
| 测试覆盖率 | 100% (token/) | >= 90% | ✅ 已达成 |
| 合约行数限制 | ✅ 合规 (MyToken: 123行, Vesting: 128行) | <= 200行 | ✅ 合规 |
| 测试通过率 | 29/29 (100%) | >= 90% | ✅ 已达成 |

---

## 安全记录 / Security Records

| 日期 | 事件 | 处理方式 | 结果 |
|------|------|---------|------|
| 2026-04-22 | 合约编译无警告 | - | ✅ 通过 |
| 2026-04-23 | 手动安全审查 | - | ✅ 通过 |

### Solhint 静态分析结果 (2026-04-23)

| 项目 | 结果 |
|------|------|
| 错误数 | 0 |
| 警告数 | 60 (主要是 NatSpec 和 Gas 优化建议) |
| 严重安全漏洞 | 0 |

**警告分类**:
- NatSpec 文档缺失: ~20 个 (建议添加，提升可读性)
- Gas 优化建议: ~25 个 (使用 Custom Errors 替代 require)
- 事件 indexed 建议: ~8 个
- 全局导入警告: 6 个

**无严重安全问题。**

---

### 手动安全审查结果 / Manual Security Review

#### MyToken.sol (123 行)
| 检查项 | 状态 | 说明 |
|--------|------|------|
| 重入攻击防护 | ✅ | 使用 OpenZeppelin ERC20Pausable，默认防重入 |
| 暂停功能 | ✅ | owner 可随时暂停所有转账 |
| 黑名单功能 | ✅ | 可冻结特定地址，owner 不可自黑 |
| 铸造权限 | ✅ | 仅 owner 可铸造 |
| 燃烧权限 | ✅ | 任何人均可燃烧自己代币，owner 可燃烧他人 |
| 零地址检查 | ✅ | 未发现零地址漏洞 |
| 溢出检查 | ✅ | Solidity 0.8+ 默认溢出检查 |

#### TokenVesting.sol (128 行)
| 检查项 | 状态 | 说明 |
|--------|------|------|
| 重入攻击防护 | ✅ | release() 使用 nonReentrant 修饰符 |
| 零地址检查 | ✅ | 构造函数和 initializeVesting 检查零地址 |
| 余额检查 | ✅ | initializeVesting 检查合约余额充足 |
| 线性释放计算 | ✅ | 使用 (totalTokens * timeFromStart) / duration 正确计算 |
| Owner 权限过大 | ⚠️ | emergencyWithdraw 可提取所有代币 (设计如此，需信任 owner) |
| 2026-04-23 | Solhint 静态分析 | - | ✅ 60 警告, 0 错误, 0 严重漏洞 |

### 已实现安全特性

- [x] OpenZeppelin Pausable (暂停功能)
- [x] OpenZeppelin ReentrancyGuard
- [x] Ownable 访问控制
- [x] 黑名单机制
- [x] NatSpec 注释

---

## 验证状态

| 验证项 | 状态 | 命令 |
|--------|------|------|
| 编译 | ✅ 通过 | `npx hardhat compile` |
| 测试 | ✅ 29/29 通过 | `npx hardhat test` |
| 合约行数 | ✅ MyToken: 123行, Vesting: 128行 | `wc -l contracts/token/*.sol` |
| localhost 部署 | ✅ 通过 | `npx hardhat run scripts/deploy-token.js --network localhost` |

---

## Phase 1 进度

| 任务 | 状态 | 完成日期 |
|------|------|---------|
| 创建基础代币合约 | ✅ 完成 | 2026-04-22 |
| 编写代币合约测试 | ✅ 完成 (18 测试) | 2026-04-22 |
| 创建锁仓释放合约 | ✅ 完成 | 2026-04-22 |
| 编写锁仓合约测试 | ✅ 完成 (11 测试) | 2026-04-22 |
| 静态安全分析 | ⏳ 待进行 | - |

---

## Phase 2 进度

| 任务 | 状态 | 完成日期 |
|------|------|---------|
| 创建部署脚本 | ✅ 完成 | 2026-04-22 |
| 创建流动性添加脚本 | ✅ 完成 | 2026-04-22 |
| 创建合约验证脚本 | ✅ 完成 | 2026-04-22 |
| 本地部署测试 | ✅ 通过 | 2026-04-22 |

### 本地部署结果

```
MyToken:        0x5FbDB2315678afecb367f032d93F642f64180aa3
TokenVesting:   0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
```

---

## Phase 3 进度

| 任务 | 状态 | 完成日期 |
|------|------|---------|
| .env 配置文件 | ✅ 完成 | 2026-04-23 |
| Sepolia 部署 | ⏳ 待进行 | 需要 API Key |
| BSC Testnet 部署 | ⏳ 待进行 | 需要 API Key |
| 合约验证 | ⏳ 待进行 | - |

### 测试网部署待配置

| 配置项 | 状态 |
|--------|------|
| SEPOLIA_RPC_URL | ⏳ 需要申请 |
| PRIVATE_KEY | ⏳ 需要提供 |
| ETHERSCAN_API_KEY | ⏳ 需要申请 |
| BSCSCAN_API_KEY | ⏳ 需要申请 |

---

## Phase 4 进度

| 任务 | 状态 | 完成日期 |
|------|------|---------|
| 代币参数确定 | ✅ 完成 | 2026-04-23 |
| 审计机构联系 | ⏳ 待开始 | - |
| 法律意见书准备 | ⏳ 待开始 | - |
| 流动性资金准备 | ⏳ 待开始 | - |

### 最终代币配置

| 参数 | 值 |
|------|-----|
| 名称 | Tokencoin |
| 符号 | TOKEN |
| decimals | 18 |
| 总供应量 | 10,000,000,000 (100亿) |
| 锁仓期 | 90 天 |
| 释放期 | 365 天 |

---

*最后更新: 2026-04-23*
