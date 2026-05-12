# Agent 行为规则 / Agent Behavior Rules

## 一、代码生成规则

### 1.1 模块化强制要求

- ✅ 每个智能合约功能**必须**单独文件
- ✅ 每个测试场景**必须**单独 `describe` block
- ✅ 每个部署步骤**必须**单独脚本
- ✅ 接口定义**必须**单独文件

### 1.2 禁止事项 (零容忍)

| 禁止行为 | 惩罚措施 |
|---------|---------|
| ❌ 生成超过 200 行的 `.sol` 文件 | 强制拆分 |
| ❌ 生成超过 300 行的 `.test.ts` 文件 | 强制拆分 |
| ❌ 在单个文件内实现多个不相关功能 | 重构 |
| ❌ 硬编码敏感信息 (私钥、API Key) | 立即删除并警告 |
| ❌ 生成超过 150 行的脚本文件 | 拆分为子任务 |
| ❌ 单体巨文件 | 立即拆分 |

### 1.3 必须包含

- ✅ 所有合约和公开函数必须有 **NatSpec 注释**
- ✅ 测试覆盖率 **>= 90%**
- ✅ 所有 `require` 语句必须有 NatSpec 格式的错误信息
- ✅ 每个合约必须继承 OpenZeppelin 安全模块

---

## 二、安全审计规则

### 2.1 部署前必须完成

| 检查项 | 工具 | 标准 |
|--------|------|------|
| 静态分析 | Slither | 高危问题 = 0 |
| 测试覆盖 | Hardhat Coverage | >= 90% |
| 编译检查 | Solc | 0 warnings |

### 2.2 合约审计要求

- [ ] 使用 OpenZeppelin **最新稳定版**
- [ ] 无重复依赖问题
- [ ] 权限控制完整
- [ ] 紧急暂停功能就绪
- [ ] 至少 **2 家独立机构**审计

---

## 三、文件组织规则

### 3.1 必须遵循的目录结构

```
token-launch/
├── contracts/           # 智能合约 (必须)
│   ├── token/         # 代币合约
│   ├── interfaces/    # 接口
│   └── utils/         # 工具合约
├── scripts/            # 部署脚本 (必须)
├── test/               # 测试 (必须)
├── docs/               # 文档 (必须)
├── config/             # 配置 (必须)
└── SPEC.md             # 规范 (必须)
```

### 3.2 文件命名规范

| 类型 | 规范 | 示例 |
|------|------|------|
| Solidity | PascalCase | `MyToken.sol` |
| TypeScript | kebab-case | `deploy-token.ts` |
| 测试文件 | `*.test.ts` | `my-token.test.ts` |
| 接口 | `I*.sol` | `IERC20.sol` |

---

## 四、权限控制规则

### 4.1 必须实现的权限

```solidity
// 每个敏感函数必须包含:
onlyOwner        // 仅部署者可调用
whenNotPaused    // 合约未暂停时可用
```

### 4.2 敏感操作清单

| 操作 | 权限要求 |
|------|---------|
| mint (铸造) | onlyOwner |
| burn (销毁) | onlyOwner 或授权 |
| pause (暂停) | onlyOwner |
| transferOwnership | onlyOwner |
| setVesting | onlyOwner |

---

## 五、错误处理规则

### 5.1 require 语句格式

```solidity
// ✅ 正确格式
require(
    beneficiary != address(0),
    "Vesting: beneficiary is zero address"
);

// ❌ 错误格式
require(beneficiary != address(0));
```

### 5.2 错误代码

| 代码 | 含义 |
|------|------|
| VE-001 | 受益人为零地址 |
| VE-002 | 释放金额超限 |
| VE-003 | 合约已暂停 |
| VE-004 | 无权执行此操作 |

---

## 六、验证与测试规则

### 6.1 每步验证测试

每个实现步骤完成后，**必须**执行对应的验证测试并确认通过:

```bash
# 编译验证
npx hardhat compile

# 静态分析
npx slither . --filter "high"

# 测试运行
npx hardhat test

# 覆盖率检查
npx hardhat coverage
```

### 6.2 部署前检查清单

- [ ] `npx hardhat compile` 成功
- [ ] `npx slither .` 无高危
- [ ] `npx hardhat coverage` >= 90%
- [ ] 所有测试通过
- [ ] 合约已验证 (如适用)

---

## 七、合规规则

### 7.1 KYC/AML

- [ ] 代币转账不记录个人身份
- [ ] 符合目标司法管辖区法规
- [ ] 必要时提供法律意见书

### 7.2 安全最佳实践

- [ ] 不在代码中存储私钥
- [ ] 使用硬件钱包或冷钱包
- [ ] 多签控制大额资金
- [ ] 流动性锁仓证明公开

---

*规则版本: 1.0*
*最后更新: 2026-04-22*
