# Sherlock 审计申请指南 / Sherlock Audit Guide

> Sherlock (sherlock.xyz) 是一个专业的智能合约审计平台，通过安全研究员社区为项目提供全面审计服务。

---

## 目录

1. [Sherlock 简介](#1-sherlock-简介)
2. [审计机制](#2-审计机制)
3. [申请步骤](#3-申请步骤)
4. [申请信息模板](#4-申请信息模板)
5. [审计后流程](#5-审计后流程)
6. [注意事项](#6-注意事项)

---

## 1. Sherlock 简介

### 什么是 Sherlock

- 专业的智能合约审计平台
- 拥有安全研究员社区
- 为 DeFi、NFT、跨链协议等提供审计服务
- 审计报告被各大 CEX 和投资者认可

### Sherlock vs 其他审计机构

| 对比项 | Sherlock | CertiK | Trail of Bits |
|--------|----------|--------|---------------|
| 费用 | 中等 + 代币激励 | 较高 | 高 |
| 速度 | 快 | 中等 | 较慢 |
| 社区支持 | 有活跃研究员社区 | 无 | 无 |
| 报告认可度 | 高 | 最高 | 最高 |

---

## 2. 审计机制

### 费用结构

Sherlock 采用**美元费用 + 代币激励**的结构：

```
总费用 = 美元费用 + 项目代币

美元费用:  $10,000 - $30,000（根据项目复杂度和合约数量）
代币激励:  按私募价格折算，通常为市值的 1-3%
```

### 审计流程

```
1. 申请提交 → 2. 初步评估 → 3. 报价协商 → 4. 签署协议 → 5. 锁定代币 → 6. 开始审计 → 7. 报告交付
```

---

## 3. 申请步骤

### 步骤 1: 访问官网

打开 https://www.sherlock.xyz/audit

### 步骤 2: 提交申请

1. 点击 "Apply for Audit" 或 "Start Audit"
2. 填写项目信息表格
3. 等待 Sherlock 团队回复（通常 1-3 个工作日）

### 步骤 3: 初步评估

Sherlock 会评估：
- 合约复杂度
- 代码行数
- 项目类型（DeFi / NFT / Token 等）
- 需要的审计研究员数量

### 步骤 4: 获取报价

Sherlock 会提供：
- 美元费用报价
- 需要的代币数量
- 预计审计周期

### 步骤 5: 协商与签署

- 讨论具体条款
- 确认费用和代币激励
- 签署审计协议

### 步骤 6: 预付款与代币锁定

- 支付美元预付款
- 将代币转入指定地址（审计完成后释放）

### 步骤 7: 开始审计

- Sherlock 分配审计团队
- 审计周期：通常 2-4 周
- 期间可能需要回答问题

### 步骤 8: 获取报告

- 收到正式审计报告
- 如有问题，提供修复建议
- 确认问题修复后，报告发布

---

## 4. 申请信息模板

### 邮件申请模板

```
Subject: Tokencoin (TOKEN) Smart Contract Audit Request

To: contact@sherlock.xyz

---

Dear Sherlock Team,

My name is zhangdulin and I am reaching out to request a security audit for our cryptocurrency project.

=== PROJECT OVERVIEW ===

Project Name: Tokencoin
Token Symbol: TOKEN
Token Type: ERC-20 / BEP-20 (Multi-chain)
Total Supply: 10,000,000,000 (10 billion)
Chains Planned: Solana, Ethereum, BSC

=== CONTRACTS TO AUDIT ===

1. MyToken.sol (~125 lines)
   - ERC-20 token with pausable and blacklist functionality
   - Features: mint, burn, pause, blacklist
   - Inherits: ERC20, ERC20Pausable, Ownable (OpenZeppelin 5.0.0)

2. TokenVesting.sol (~130 lines)
   - Linear vesting with cliff period
   - Features: initializeVesting, release, emergencyWithdraw
   - Inherits: Ownable, ReentrancyGuard (OpenZeppelin 5.0.0)

=== TECHNICAL STACK ===

- Solidity: 0.8.24
- Framework: Hardhat 2.22.18
- OpenZeppelin: 5.0.0
- Tests: 29 passing (100% coverage)

=== PROJECT REPOSITORY ===

https://github.com/zhangdulin/tokencoin

=== BUDGET & TIMELINE ===

Budget Range: $15,000 - $30,000 USD
Flexible depending on scope and timeline
Planning mainnet launch in 4-6 weeks

=== QUESTIONS ===

1. Your current availability for our project?
2. Estimated timeline and cost?
3. What is the process to proceed?

I look forward to your response.

Best regards,

Name: zhangdulin
Email: zhangdulin@outlook.com
```

---

## 5. 审计后流程

### 收到报告后

1. **仔细阅读报告**
   - 理解每个发现的问题
   - 评估风险等级

2. **修复问题**
   - Critical / High: 必须修复
   - Medium: 建议修复
   - Low / Informational: 可选修复

3. **重新审计（如需要）**
   - 如果有重大修复，可能需要重新审计

4. **发布报告**
   - 项目方可以发布审计报告
   - 用于 CEX 申请、社区信任建立

### 后续工作

- 将报告链接添加到 README
- 在文档中展示审计状态
- 准备 CEX 上市申请材料

---

## 6. 注意事项

### 代币激励注意事项

- 代币数量按**私募价格**计算
- 确保私募价格合理（不要太低）
- 代币会在审计完成后释放

### 时间规划

```
总周期: 约 4-6 周
├── 申请与评估:   1 周
├── 报价协商:     3-5 天
├── 审计执行:     2-4 周
└── 报告交付:     3-5 天
```

### 建议

1. **提前申请** — Sherlock 排期可能较满
2. **准备完整文档** — 白皮书、代币经济学等
3. **代码质量要好** — 减少修复时间，加快审计速度
4. **保持沟通** — 审计期间及时回答问题

---

## 其他免费审计选项

如果 Sherlock 报价超出预算，可以同时申请：

| 平台 | 网址 | 说明 |
|------|------|------|
| CodeHawks | https://codehawks.io | 中小项目免费 |
| Immunefi | https://immunefi.com | Bug Bounty 平台 |
| Sherlock | https://www.sherlock.xyz | 付费 + 代币激励 |

---

**最后更新**: 2026-05-01
