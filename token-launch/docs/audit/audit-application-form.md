# 智能合约审计申请表
# Smart Contract Audit Application Form

**申请编号 / Application ID**: [自动生成]
**申请日期 / Date**: 2026-04-24
**预计预算 / Budget Range**: 待定
**推荐来源 / Referral Source**: 官网表单

---

## 1. 项目基本信息 / Project Basic Information

| 字段 | 内容 |
|------|------|
| **项目名称 / Project Name** | Tokencoin |
| **代币符号 / Token Symbol** | TOKEN |
| **项目类型 / Project Type** | DeFi / Token |
| **官网 / Website** | TBD |
| **白皮书 / Whitepaper** | 已准备 |

### 1.1 联系信息 / Contact Information

| 字段 | 内容 |
|------|------|
| **联系人 / Contact Person** | [填写] |
| **邮箱 / Email** | [填写] |
| **Telegram** | [填写] |
| **Twitter** | [填写] |
| **Discord** | [填写] |

---

## 2. 代币信息 / Token Information

| 参数 | 值 |
|------|-----|
| 代币名称 | Tokencoin |
| 符号 | TOKEN |
| 代币标准 | ERC-20, BEP-20 |
| 总供应量 | 10,000,000,000 |
| 小数位数 | 18 |

### 合约列表 / Contract List

| # | 合约名称 | 文件 | 行数 | 用途 |
|---|---------|------|------|------|
| 1 | MyToken | MyToken.sol | 125 | 主代币合约 |
| 2 | TokenVesting | TokenVesting.sol | 130 | 锁仓释放合约 |

---

## 3. 审计范围 / Audit Scope

### 3.1 需要审计的合约

- [x] MyToken.sol - 主代币合约
- [x] TokenVesting.sol - 锁仓释放合约

### 3.2 需要检查的内容

- [x] 重入攻击防护
- [x] 溢出/下溢检查
- [x] 访问控制
- [x] 代币经济学正确性
- [x] 暂停/黑名单功能
- [x] 锁仓释放逻辑
- [x] 紧急提取功能

### 3.3 不在审计范围内

- 前端应用
- 后端服务
- 预言机
- 跨链桥接

---

## 4. 部署信息 / Deployment Information

### 4.1 测试网部署 / Testnet Deployment

| 链 | 合约 | 地址 | 状态 |
|----|------|------|------|
| Sepolia | MyToken | TBD | 待部署 |
| BSC Testnet | MyToken | TBD | 待部署 |

### 4.2 计划主网部署 / Planned Mainnet Deployment

| 优先级 | 链 | 计划时间 |
|--------|-----|----------|
| 1 | Solana | TBD |
| 2 | Ethereum | TBD |
| 3 | BSC | TBD |

---

## 5. 安全措施 / Security Measures

- [x] 使用 OpenZeppelin 最新版本
- [x] 代码遵循 Solidity 最佳实践
- [ ] 第三方审计 (申请中)
- [ ] Bug Bounty 计划 (计划中)

---

## 6. 审计要求 / Audit Requirements

### 6.1 审计标准

- [x] OWASP Smart Contract Top 10
- [x] CertiK Audit Standard
- [x] Trail of Bits Analysis

### 6.2 交付物要求

- [x] 审计报告 (PDF)
- [x] 代码问题清单
- [x] 修复建议
- [x] 修复后验证

### 6.3 紧急程度

- [ ] 标准 (4-6 周)
- [x] 优先 (2-3 周)
- [ ] 加急 (1 周，额外费用)

---

## 7. 预算信息 / Budget Information

| 项目 | 范围 |
|------|------|
| 初步预算 | $15,000 - $30,000 USD |
| 最高预算 | $50,000 USD |
| 付款方式 | USDT / USDC / ETH / fiat |

---

## 8. 附加信息 / Additional Information

**特殊要求 / Special Requirements**:
- 需要中文报告 (可选)
- 上市前需要快速完成

**如何了解本项目 / How did you hear about us**:
- Google / 搜索引擎
- 社区推荐
- 加密货币媒体

---

## 9. 声明与授权

我/我们声明：

1. 所提供的项目信息真实有效
2. 拥有智能合约代码的完整版权
3. 同意审计机构将审计报告公开
4. 接受审计结果并承诺修复发现的问题

**申请人签名 / Signature**: _________________

**日期 / Date**: 2026-04-24

---

## 附件清单 / Attachment Checklist

- [x] 项目白皮书 (whitepaper.md)
- [x] 代币经济学文档 (token-economics.md)
- [x] 智能合约源代码
- [x] 部署脚本
- [ ] 项目团队介绍
- [ ] 法律意见书 (如已有)
- [ ] 之前的审计报告 (如有)
