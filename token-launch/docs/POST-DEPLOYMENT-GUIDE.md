# Post-Deployment Guide

## Step 1: BSCScan Verification (Manual)

### MyToken Verification
1. 打开浏览器访问: https://bscscan.com/address/0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B#code
2. 点击 "Verify Contract" 绿色按钮
3. 填写:
   - Contract Name: `MyToken`
   - Compiler Version: `0.8.24`
   - License: `MIT License`
   - Optimization: `Yes` (200 runs)
4. 复制 `contracts/token/MyToken.sol` 内容粘贴
5. 点击 "Verify"

### TokenVesting Verification
1. 打开浏览器访问: https://bscscan.com/address/0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934#code
2. 点击 "Verify Contract"
3. 填写:
   - Contract Name: `TokenVesting`
   - Compiler Version: `0.8.24`
   - License: `MIT License`
   - Optimization: `Yes` (200 runs)
4. 复制 `contracts/token/TokenVesting.sol` 内容粘贴
5. 点击 "Verify"

---

## Step 2: PancakeSwap Liquidity Setup (Manual)

### 2.1 Add Liquidity
1. 访问: https://pancakeswap.finance/liquidity
2. 连接钱包 (MetaMask/Trust Wallet)
3. 点击 "Add Liquidity"
4. 选择 TOKEN 合约地址: `0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B`
5. 建议交易对: TOKEN/BNB 或 TOKEN/USDT
6. 添加流动性并获得 LP Token

### 2.2 Configure Contract After Adding LP
运行配置脚本:
```bash
npx hardhat run scripts/configure-dex.js --network bsc
```

---

## Step 3: Sherlock Audit Application (Manual)

### 3.1 Prepare Information
您已准备好以下文件:
- `docs/audit/SHERLOCK-AUDIT-APPLICATION.md` - 申请表格
- `docs/audit/COMPREHENSIVE-SECURITY-AUDIT.md` - 完整审计报告

### 3.2 Submit Application
1. 访问: https://sherlock.xyz/audits/new
2. 填写项目信息:
   - Project Name: `Tokencoin`
   - Website: (您的网站)
   - Twitter: (您的Twitter)
   - Discord: (您的Discord)
3. 上传合约源码或链接到GitHub
4. 选择 bounty 池建议: 15,000 USDC
5. 提交申请

---

## Contract Addresses Summary

| Contract | Address |
|----------|---------|
| MyToken (Mainnet) | 0xDB8Fe1162FEA7C5f1b4d7aB48B9F9930F887537B |
| TokenVesting (Mainnet) | 0x3DB6c1CC422ac1B9B033c176A07A2D38BC118934 |
| Gnosis Safe | 0x886A0ffE290c476F66dc05AACd854e5FD93fDA12 |
| PancakeSwap Router | 0x10ED43C718714eb63d5aA57B78B54788E80F2 |
