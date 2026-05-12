# Tokencoin 项目启动指南
# Tokencoin Project Getting Started Guide

**版本**: 1.0
**日期**: 2026-04-24
**状态**: 完整教程

---

## 目录

1. [GitHub 仓库创建与提交](#1-github-仓库创建与提交)
2. [审计申请流程](#2-审计申请流程)
3. [下一步行动清单](#3-下一步行动清单)
4. [常见问题](#4-常见问题)

---

## 1. GitHub 仓库创建与提交

### 1.1 前置准备

- GitHub 账号 (如果没有，请访问 https://github.com 注册)
- Git 已安装 (Mac 默认已安装，Windows 请下载 Git SCM)

### 1.2 验证 Git 安装

```bash
# 打开终端，输入：
git --version

# 应该显示类似：
# git version 2.x.x
```

### 1.3 配置 Git 用户信息 (只需配置一次)

```bash
# 设置用户名 (替换为你的 GitHub 用户名)
git config --global user.name "你的 GitHub 用户名"

# 设置邮箱 (替换为你的 GitHub 邮箱)
git config --global user.email "你的 GitHub 邮箱"

# 验证配置
git config --global --list
```

### 1.4 创建 GitHub 远程仓库

**方法一: 通过 GitHub 网页创建 (推荐)**

1. 打开浏览器，访问: https://github.com
2. 登录你的账号
3. 点击右上角 **"+"** 按钮 → **"New repository"**
4. 填写仓库信息:

| 字段 | 填写内容 |
|------|----------|
| Repository name | `tokencoin` |
| Description | `Multi-chain ERC-20 Token with Linear Vesting` |
| Public/Private | 选择 **Public** (公开仓库，审计机构才能看到) |
| Add a README file | **不勾选** (我们已有 README.md) |
| Add .gitignore | **不勾选** (我们已有 .gitignore) |
| License | 选择 **MIT License** |

5. 点击 **"Create repository"**
6. 页面会显示你的仓库 URL，保存下来:

```
https://github.com/zhangdulin/tokencoin
```

### 1.5 本地 Git 初始化与提交

**打开终端，进入项目目录:**

```bash
cd /Users/yuzhang/dulin/learn/AI/vibe-coding-cn-main-fxb/token-launch
```

**初始化 Git 仓库:**

```bash
git init
```

**添加远程仓库地址 (替换 zhangdulin):**

```bash
git remote add origin https://github.com/zhangdulin/tokencoin.git
```

**检查状态:**

```bash
git status

# 应该显示类似:
# On branch master
# Untracked files:
#   (list of files...)
```

**添加所有文件到暂存区:**

```bash
git add .
```

**提交文件:**

```bash
git commit -m "Initial commit: Tokencoin token contracts and documentation

- MyToken.sol: ERC-20 with pause & blacklist
- TokenVesting.sol: Linear vesting with cliff
- 33 passing tests
- Project documentation (whitepaper, token economics)
- Audit application materials"
```

### 1.6 推送到 GitHub

**首次推送 (设置上游分支):**

```bash
git branch -M main
git push -u origin main
```

**输入 GitHub 用户名和密码/Token:**

- Username: 你的 GitHub 用户名
- Password: 你的 GitHub Personal Access Token (不是登录密码)

**验证推送成功:**

打开浏览器访问 `https://github.com/zhangdulin/tokencoin`，应该能看到所有文件。

---

## 2. 审计申请流程

### 2.1 发送审计申请邮件

**收件人**: audit@certik.io

**邮件主题**:
```
Tokencoin (TOKEN) Smart Contract Audit Request
```

**邮件正文**:

```
Dear CertiK Team,

My name is zhangdulin and I am reaching out to request a security audit for our cryptocurrency project.

=== PROJECT OVERVIEW ===

Project Name: Tokencoin
Token Symbol: TOKEN
Token Type: ERC-20 / BEP-20 (Multi-chain)
Total Supply: 10,000,000,000 (10 billion)
Chains Planned: Solana, Ethereum, BSC

=== CONTRACTS TO AUDIT ===

1. MyToken.sol (125 lines)
   - ERC-20 token with pausable and blacklist functionality
   - Features: mint, burn, pause, blacklist
   - Inherits: ERC20, ERC20Pausable, Ownable (OpenZeppelin 5.0)

2. TokenVesting.sol (130 lines)
   - Linear vesting with cliff period
   - Features: initializeVesting, release, emergencyWithdraw
   - Inherits: Ownable, ReentrancyGuard (OpenZeppelin 5.0)

=== TECHNICAL STACK ===

- Solidity: 0.8.24
- Framework: Hardhat 2.22.18
- OpenZeppelin: 5.0.0
- Tests: 33 passing (100% coverage)

=== PROJECT REPOSITORY ===

https://github.com/zhangdulin/tokencoin

=== BUDGET & TIMELINE ===

Budget Range: $15,000 - $30,000 USD
Flexible depending on scope and timeline
Planning mainnet launch in 4-6 weeks

=== QUESTIONS ===

1. Your current availability for our project?
2. Estimated timeline and cost?
3. Next steps to proceed?

I look forward to your response.

Best regards,

Name: zhangdulin
Email: zhangdulin@outlook.com
```

### 2.2 同时申请的审计机构

建议同时联系多家机构，增加成功率:

| 机构 | 邮箱 | 特点 |
|------|------|------|
| CertiK | audit@certik.io | 币圈首选 |
| SlowMist | audit@slowmist.com | 中文友好 |
| Trail of Bits | contracts@trailofbits.com | 最权威 |
| OpenZeppelin | contracts@openzeppelin.com | 官方库 |

### 2.3 免费审计申请

如果预算有限，同时申请以下免费选项:

| 平台 | 网址 | 说明 |
|------|------|------|
| CodeHawks | https://codehawks.io | 中小项目免费 |
| Sherlock | https://www.sherlock.xyz | 代币项目审计 |
| Immunefi | https://immunefi.com | Bug Bounty |

---

## 3. 下一步行动清单

### 3.1 立即执行 (今天)

| # | 任务 | 状态 | 说明 |
|---|------|------|------|
| 1 | 创建 GitHub 仓库 | ⏳ 待做 | 按本指南第 1 部分操作 |
| 2 | 推送代码到 GitHub | ⏳ 待做 | git push |
| 3 | 发送 CertiK 审计邮件 | ⏳ 待做 | 使用上方模板 |
| 4 | 发送其他机构审计邮件 | ⏳ 待做 | SlowMist, Trail of Bits |

### 3.2 本周内

| # | 任务 | 状态 | 说明 |
|---|------|------|------|
| 1 | 填写个人信息到文档 | ⏳ 待做 | 编辑 docs/ 下的 [填写] 部分 |
| 2 | 申请免费审计平台 | ⏳ 待做 | CodeHawks, Sherlock |
| 3 | 开始社区建设 | ⏳ 待做 | Twitter, Telegram |
| 4 | 准备法律数据包 | ⏳ 待做 | 完成 legal-data-package-checklist.md |

### 3.3 本月内

| # | 任务 | 状态 | 说明 |
|---|------|------|------|
| 1 | 获取审计报价 | ⏳ 待做 | 等待审计机构回复 |
| 2 | 签约审计机构 | ⏳ 待做 | 选择报价最优的 |
| 3 | 准备流动性资金 | ⏳ 待做 | $50,000-$100,000 |
| 4 | 确定法律顾问 | ⏳ 待做 | 获取法律意见书 |

### 3.4 主网部署前

| # | 任务 | 状态 | 说明 |
|---|------|------|------|
| 1 | 完成合约审计 | ⏳ 待做 | 获取审计报告 |
| 2 | 获取法律意见书 | ⏳ 待做 | 合规必需 |
| 3 | 部署 Solana 主网 | ⏳ 待做 | 第一优先 |
| 4 | 部署 Ethereum 主网 | ⏳ 待做 | 第二优先 |
| 5 | 添加初始流动性 | ⏳ 待做 | DEX |
| 6 | 申请 CEX 上市 | ⏳ 待做 | Binance, Coinbase |

---

## 4. 常见问题

### Q1: GitHub 推送时要求输入密码怎么办？

**答**: GitHub 已不支持密码登录，需要使用 Personal Access Token。

**获取 Token 步骤:**
1. 打开 https://github.com/settings/tokens
2. 点击 "Generate new token (classic)"
3. 设置名称，选择到期时间
4. 勾选 `repo` 权限
5. 点击 "Generate token"
6. 复制生成的 Token (只会显示一次)

**推送时:**
- Username: 你的 GitHub 用户名
- Password: 粘贴 Token (不是密码)

---

### Q2: 审计费用太高怎么办？

**答**: 可以尝试以下方式:

1. **申请免费审计**: CodeHawks, Sherlock
2. **使用 Bug Bounty**: Immunefi
3. **谈判**: 说明项目预算，争取折扣
4. **分阶段审计**: 先审计核心合约
5. **社区白帽**: 公开代码，邀请社区审计

---

### Q3: 没有回复审计申请怎么办？

**答**: 这是正常的，尝试:

1. 发送跟进邮件 (1 周后)
2. 通过 Telegram 联系商务经理
3. 联系其他审计机构
4. 通过 introducers 推荐

---

### Q4: 可以在不花钱的情况下完成审计吗？

**答**: 可以:

1. 申请 CodeHawks (codehawks.io) - 完全免费
2. 申请 Sherlock (sherlock.xyz) - 免费审计，换取代币
3. 使用 Immunefi Bug Bounty - 社区白帽测试
4. 公开代码，邀请社区审计

---

### Q5: 合约代码已经很安全了，还需要审计吗？

**答**: **必须审计**:

1. **上市必需**: CEX 上市要求审计报告
2. **用户信任**: 审计报告是项目可信度的证明
3. **发现未知漏洞**: 即使最好的工程师也会犯错
4. **合规要求**: 某些司法管辖区要求审计

---

## 附录: 快速命令参考

```bash
# 进入项目目录
cd /Users/yuzhang/dulin/learn/AI/vibe-coding-cn-main-fxb/token-launch

# 查看 Git 状态
git status

# 添加所有更改
git add .

# 提交更改
git commit -m "你的提交信息"

# 推送到 GitHub
git push

# 查看远程仓库地址
git remote -v

# 更新远程仓库地址 (如果需要)
git remote set-url origin https://github.com/zhangdulin/tokencoin.git
```

---

## 附录: 项目文件清单

提交到 GitHub 的文件:

```
tokencoin/
├── README.md                    # 项目主页
├── LICENSE                     # MIT 协议
├── .gitignore                 # Git 忽略文件
├── .env.example               # 环境变量模板
├── CONTRIBUTING.md            # 贡献指南
├── hardhat.config.cjs         # Hardhat 配置
├── .solhint.json             # Solhint 配置
├── .github/
│   └── workflows/
│       └── test.yml           # CI/CD 测试
├── contracts/
│   ├── Lock.sol              # 示例合约
│   └── token/
│       ├── MyToken.sol       # 主代币合约
│       └── TokenVesting.sol  # 锁仓合约
├── docs/
│   ├── README.md
│   ├── audit/
│   │   ├── audit-application-form.md
│   │   ├── email-templates.md
│   │   └── email-to-certik.txt
│   ├── legal/
│   │   ├── KYCDocuments.md
│   │   ├── RiskDisclosure.md
│   │   ├── TokenPurchaseAgreement.md
│   │   ├── legal-data-package-checklist.md
│   │   └── token-economics.md
│   └── marketing/
│       └── whitepaper.md
├── scripts/
│   ├── deploy-token.js
│   ├── add-liquidity.js
│   ├── verify-contract.js
│   └── README.md
├── test/
│   ├── Lock.js
│   └── token/
│       ├── MyToken.test.js
│       └── TokenVesting.test.js
└── package.json
```

---

**最后更新**: 2026-04-24
