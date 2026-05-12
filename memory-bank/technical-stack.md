# 技术栈与 Agent 规则 / Technical Stack & Agent Rules

## 一、技术栈选择原则 / Technical Stack Selection Principles

1. **简单性**: 最少依赖，最小复杂度
2. **健壮性**: 经过大量实战验证，安全性高
3. **可扩展性**: 支持未来功能扩展
4. **社区支持**: 活跃的开发者社区和丰富的文档

---

## 二、推荐技术栈 / Recommended Technical Stack

### 2.1 智能合约开发 / Smart Contract Development

| 层级 | 技术选择 | 说明 |
|------|---------|------|
| **语言** | Solidity ^0.8.24 | 以太坊生态最广泛使用 |
| **框架** | Hardhat | 开发体验好，调试方便 |
| **替代框架** | Foundry | 最高性能，适合测试 |
| **标准库** | OpenZeppelin ^5.0 | 安全审计通过，模块化 |
| **液化检测** | Slither | 静态分析工具 |

### 2.2 开发工具链 / Development Toolchain

```
核心工具:
├── Node.js ^20.x          (运行时)
├── npm / yarn / pnpm      (包管理器)
├── Hardhat                (开发框架)
├── TypeScript             (可选，类型安全)
└── ESLint + Prettier      (代码规范)
```

### 2.3 测试工具 / Testing Tools

| 工具 | 用途 |
|------|------|
| Hardhat Network | 本地测试网 |
| Mocha / Chai | 测试框架 |
| Waffle | Ethereum 测试库 |
| Echidna | 模糊测试 |
| Mythril | 符号执行 |

### 2.4 部署工具 / Deployment Tools

| 工具 | 用途 |
|------|------|
| Hardhat Deploy | 自动化部署脚本 |
| Tenderly | 合约监控与调试 |
| OpenZeppelin Defender | 合约管理平台 |

### 2.5 前端 (可选) / Frontend (Optional)

| 技术 | 用途 |
|------|------|
| Next.js | 官网 |
| wagmi + viem | Web3 交互 |
| RainbowKit | 钱包连接 |

---

## 三、项目结构 / Project Structure

### 3.1 目录结构原则 / Directory Structure Principles

> **强制要求**: 禁止单体巨文件，所有功能必须模块化拆分

```
token-launch/
├── contracts/                    # 智能合约 (必须)
│   ├── token/                   # 代币相关合约
│   │   ├── MyToken.sol
│   │   └── TokenVesting.sol
│   ├── interfaces/              # 接口定义
│   │   ├── IERC20.sol
│   │   └── IVesting.sol
│   └── utils/                   # 工具合约
│       └── SafeMath.sol
├── scripts/                     # 部署脚本 (必须)
│   ├── deploy-token.ts
│   ├── verify-token.ts
│   └── add-liquidity.ts
├── test/                        # 测试文件 (必须)
│   ├── token/
│   │   ├── MyToken.test.ts
│   │   └── Vesting.test.ts
│   └── integration/
├── docs/                        # 文档 (必须)
│   ├── deployment.md
│   ├── audit-report.md
│   └── contract-api.md
├── config/                      # 配置文件 (必须)
│   ├── hardhat.config.ts
│   ├── .env.example
│   └── constants.ts
├── frontend/                    # 前端 (可选)
│   ├── components/
│   ├── pages/
│   └── utils/
└── SPEC.md                      # 规范文档 (必须)
```

### 3.2 文件大小限制 / File Size Limits

| 文件类型 | 最大行数 | 超过处理方式 |
|---------|---------|-------------|
| 智能合约 .sol | 200 行 | 拆分为库合约 |
| 测试文件 .test.ts | 300 行 | 拆分为 describe blocks |
| 脚本文件 .ts | 150 行 | 拆分为子任务 |
| 配置文件 | 100 行 | 模块化常量 |

---

## 四、Agent 规则 / Agent Rules

### 4.1 `/init` 命令规范

执行 `/init` 时，必须生成以下规则文件：

```
memory-bank/.claude/
├── CLAUDE.md                    # 项目上下文
├── RULES.md                     # Agent 行为规则
└── CONVENTIONS.md               # 代码规范
```

### 4.2 RULES.md 强制内容

```markdown
# Agent 行为规则

## 代码生成规则

1. **模块化强制要求**
   - 每个智能合约功能单独文件
   - 每个测试场景单独 describe block
   - 每个部署步骤单独脚本

2. **禁止事项**
   - ❌ 禁止生成超过 200 行的 .sol 文件
   - ❌ 禁止生成超过 300 行的 .test.ts 文件
   - ❌ 禁止在单个文件内实现多个不相关功能
   - ❌ 禁止硬编码敏感信息

3. **必须包含**
   - ✅ Natspec 注释 (所有合约和公开函数)
   - ✅ 完整测试覆盖 (至少 90%)
   - ✅ NatSpec 格式的 require 错误信息

## 安全审计规则

1. 合约部署前必须通过 Slither 检测
2. 必须有至少 2 个独立审计报告
3. 敏感操作必须有时间锁定

## 文件组织规则

1. 遵循 3.1 目录结构
2. 文件命名遵循 snake_case (.sol) / kebab-case (.ts)
3. 相同功能集文件放同一目录
```

### 4.3 CONVENTIONS.md 规范

```markdown
# 代码规范

## Solidity 规范

- 编译器版本: ^0.8.24
- 命名: ContractName, functionName, variableName, CONSTANT_NAME
- 访问控制: 所有外部调用函数必须有权限检查
- 错误处理: 使用 require + NatSpec

## TypeScript 规范

- 严格模式: strict: true
- 类型: 禁止 any，必须显式类型
- 导入: 使用绝对路径 @/...

## 测试规范

- 覆盖率: >= 90%
- 命名: describe/it("should ...")
- 每个测试必须独立，不依赖其他测试状态
```

---

## 五、安全检查清单 / Security Checklist

### 5.1 部署前必须完成

- [ ] Slither 静态分析无高危问题
- [ ] 代码覆盖率 >= 90%
- [ ] 所有公开函数有权限控制
- [ ] 持有者验证测试通过
- [ ] 边界条件测试通过

### 5.2 合约审计清单

- [ ] OpenZeppelin 版本为最新稳定版
- [ ] 无重复依赖问题
- [ ] 合约可升级性评估 (如适用)
- [ ] 豚特异性攻击向量分析

---

## 六、环境配置 / Environment Configuration

### 6.1 必须的环境变量

```bash
# .env 文件模板
RPC_URL_ETHEREUM=       # Ethereum 主网 RPC
RPC_URL_BSC=            # BSC 主网 RPC
PRIVATE_KEY=            # 部署私钥 (never commit!)
ETHERSCAN_API_KEY=      # 合约验证 API Key
BSCSCAN_API_KEY=        # BSC 验证 API Key
```

### 6.2 网络配置

```javascript
// hardhat.config.ts 网络配置
networks: {
  mainnet: { ... },
  bsc: { ... },
  sepolia: { ... },      // 测试网
  bscTestnet: { ... },   // BSC 测试网
}
```

---

*文档版本: 1.0*
*最后更新: 2026-04-22*
