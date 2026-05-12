# 代码规范 / Coding Conventions

## 一、Solidity 规范

### 1.1 编译器与版本

```solidity
// 必须指定编译器版本
pragma solidity ^0.8.24;

// 使用最新稳定版 OpenZeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
```

### 1.2 命名规范

| 元素 | 规范 | 示例 |
|------|------|------|
| 合约名 | PascalCase | `MyToken` |
| 函数名 | camelCase | `mintTokens` |
| 变量名 | camelCase | `totalSupply` |
| 常量名 | UPPER_SNAKE | `MAX_SUPPLY` |
| 事件名 | PascalCase | `Transfer` |
| 事件参数 | PascalCase | `from` |

### 1.3 函数可见性

```solidity
// 按以下顺序声明
constructor()     // 1. 构造函数
external         // 2. 外部函数
public           // 3. 公开函数
internal         // 4. 内部函数
private          // 5. 私有函数
```

### 1.4 NatSpec 注释

```solidity
/**
 * @title MyToken
 * @dev ERC20 token implementation with minting and burning capabilities.
 * @author Project Team
 */
contract MyToken is ERC20 {
    /**
     * @dev Mints `amount` tokens to account `to`.
     * @param to The address receiving the tokens.
     * @param amount The quantity of tokens to mint.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
```

---

## 二、TypeScript 规范

### 2.1 严格模式

```json
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true
  }
}
```

### 2.2 命名规范

| 元素 | 规范 | 示例 |
|------|------|------|
| 文件名 | kebab-case | `deploy-token.ts` |
| 类名 | PascalCase | `TokenContract` |
| 函数名 | camelCase | `deployToken` |
| 变量名 | camelCase | `contractAddress` |
| 常量名 | UPPER_SNAKE | `MAX_GAS_LIMIT` |
| 接口名 | PascalCase | `TokenConfig` |

### 2.3 类型规则

```typescript
// ✅ 正确: 显式类型
const totalSupply: bigint = 1000000n;

// ❌ 错误: 禁止 any
const amount: any = 100;

// ✅ 正确: 导入类型
import type { HardhatRuntimeEnvironment } from 'hardhat/types';
```

### 2.4 导入顺序

```typescript
// 1. Node 内置模块
import fs from 'fs';
import path from 'path';

// 2. 第三方库
import { ethers } from 'ethers';

// 3. 项目内部模块
import { MyToken } from '../contracts/token/MyToken';

// 4. 类型导入
import type { TokenConfig } from '../types';
```

---

## 三、测试规范

### 3.1 文件结构

```typescript
// test/token/MyToken.test.ts

import { expect } from 'chai';
import { ethers } from 'hardhat';
import type { MyToken } from '../../typechain';

describe('MyToken', function () {
  let token: MyToken;

  beforeEach(async function () {
    // 部署合约
    const TokenFactory = await ethers.getContractFactory('MyToken');
    token = (await TokenFactory.deploy('MyToken', 'MTK')) as MyToken;
  });

  describe('Deployment', function () {
    it('should set the correct name', async function () {
      expect(await token.name()).to.equal('MyToken');
    });
  });
});
```

### 3.2 测试命名

```typescript
// ✅ 正确: describe/it("should ...")
describe('TokenVesting', function () {
  describe('Release', function () {
    it('should release tokens after vesting period', async function () {
      // test code
    });

    it('should not release tokens before vesting period', async function () {
      // test code
    });
  });
});

// ❌ 错误: 模糊命名
it('test vesting', async function () { ... });
```

### 3.3 测试隔离

```typescript
// 每个测试必须独立，不依赖其他测试状态
beforeEach(async function () {
  // 重新部署合约
  token = await ethers.deployContract('MyToken');
});
```

### 3.4 覆盖率要求

| 类型 | 最低覆盖率 |
|------|-----------|
| 语句 | 90% |
| 分支 | 85% |
| 函数 | 95% |
| 行 | 90% |

---

## 四、文档规范

### 4.1 README 模板

```markdown
# Token Name

## 概述
[代币简介]

## 合约地址

| 网络 | 地址 |
|------|------|
| Ethereum | [address] |
| BSC | [address] |

## 功能
- [功能列表]

## 接口

### `balanceOf(address account) → uint256`
[函数说明]

## 部署步骤

1. [步骤1]
2. [步骤2]

## 安全

- [审计报告链接]
- [安全特性说明]
```

### 4.2 API 文档格式

```markdown
## 函数名

### 描述
[函数功能描述]

### 参数
| 名称 | 类型 | 说明 |
|------|------|------|

### 返回值
[返回值说明]

### 示例
```solidity
[代码示例]
```
```

---

## 五、Git 提交规范

### 5.1 提交类型

| 类型 | 说明 |
|------|------|
| feat | 新功能 |
| fix | 修复 bug |
| docs | 文档更新 |
| test | 测试相关 |
| chore | 构建/工具 |
| refactor | 重构 |

### 5.2 提交格式

```
feat: add vesting contract with linear release

- implement TokenVesting contract
- add beneficiary management
- add release schedule verification
- add emergency revoke function

Closes #123
```

---

*规范版本: 1.0*
*最后更新: 2026-04-22*
