# DEX 上币指南 / DEX Listing Guide

> 本文档记录在各大 DEX 上添加流动性的完整步骤

---

## 目录

1. [核心概念：什么是流动性池](#核心概念什么是流动性池)
2. [准备工作](#准备工作)
3. [第一步：在 BSC 部署代币](#第一步在-bsc-部署代币)
4. [第二步：PancakeSwap (BSC)](#第二步pancakeswap-bsc)
5. [第三步：Uniswap (Ethereum)](#第三步uniswap-ethereum)
6. [第四步：Raydium (Solana)](#第四步raydium-solana)
7. [安全与后续](#安全与后续)

---

## 核心概念：什么是流动性池

### 为什么需要流动性池？

DEX（去中心化交易所）依靠**流动性池**让用户交易代币。

**简单理解：**

```
流动性池 = 你的代币 + BNB/ETH 等主流资产

举例：你创建 TOKEN/BNB 池
├── 你放入: 1,000,000 TOKEN
├── 你放入: 10 BNB
└── 结果: 任何人都可以用 BNB 换 TOKEN，或用 TOKEN 换 BNB
```

### 交易对是如何形成的？

当你添加流动性时，实际上是创建了一个**交易对（Trading Pair）**：

```
TOKEN/BNB 交易对

用户A: 用 1 BNB 换 TOKEN  → 池子里 BNB 增加，TOKEN 减少
用户B: 用 5000 TOKEN 换 BNB → 池子里 TOKEN 增加，BNB 减少
价格: 由池子里两种资产的比例自动计算（AMM 自动做市商）
```

### LP Token 是什么？

添加流动性后，你会收到 **LP Token**（流动性凭证）：

```
LP Token = 你拥有这个池子的份额证明

持有 LP Token 数量 = 拥有流动性池的比例
示例: 池子总共 100 LP，你持有 10 LP = 10% 份额

好处: 你可以获得该池子的交易手续费分成（通常 0.17%）
```

---

## 准备工作

### 工具清单

| 工具 | 用途 | 链接 |
|------|------|------|
| MetaMask | BSC/ETH 钱包 | chrome.google.com/websearch/metamask |
| Phantom Wallet | Solana 钱包 | phantom.app |
| BNB (BSC) | 支付 Gas + 添加流动性 | 从交易所转账 |
| ETH (ETH) | 支付 Gas + 添加流动性 | 从交易所转账 |
| SOL (Solana) | 支付 Gas | 从交易所转账 |

### 预估费用

| 步骤 | 费用 | 说明 |
|------|------|------|
| 在 BSC 部署代币 | $5-20 | 部署合约的 Gas |
| 在 PancakeSwap 添加流动性 | $20-50 | 创建池子 + 添加流动性 |
| 在 ETH 部署代币 | $50-200 | 部署合约 Gas（较高） |
| 在 Uniswap 添加流动性 | $100-300 |  Gas 较高 |
| 在 Raydium 添加流动性 | $1-10 | Solana 费用极低 |

---

## 第一步：在 BSC 部署代币

> 在 PancakeSwap 上添加流动性之前，必须先在 BSC 网络上部署你的代币合约。

### 1.1 配置 MetaMask 连接 BSC

1. 打开 MetaMask
2. 点击右上角**头像** → **设置** → **网络** → **添加网络**
3. 填写以下信息：

```
网络名称: BSC
新的 RPC URL: https://bsc-dataseed.binance.org/
链 ID: 56
货币符号: BNB
区块浏览器 URL: https://bscscan.com
```

4. 点击**保存**

### 1.2 获取 BNB 支付 Gas

1. 在交易所（币安等）购买 BNB
2. 从交易所提现 BNB 到你的 MetaMask 地址
3. 建议至少准备 **0.1 BNB**（足够部署 + 创建池子）

### 1.3 部署 MyToken.sol 到 BSC

**使用 Hardhat 部署：**

1. 编辑 `token-launch/.env` 文件：

```
PRIVATE_KEY=你的钱包私钥
BSC_RPC_URL=https://bsc-dataseed.binance.org/
```

2. 运行部署命令：

```bash
cd token-launch
npx hardhat run scripts/deploy-token.js --network bscTestnet
```

**注意：** 先在测试网 `bscTestnet` 部署测试，确认无误后再用主网 RPC 部署到真正的 BSC。

3. 测试网部署成功后，将 `BSC_RPC_URL` 改为：

```
BSC_MAINNET_RPC=https://bsc-dataseed.binance.org/
```

4. 部署到主网：

```bash
npx hardhat run scripts/deploy-token.js --network bsc
```

5. 记录返回的合约地址：

```
MyToken 部署地址: 0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
TokenVesting 部署地址: 0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

**这就是你的代币在 BSC 上的地址，后续 PancakeSwap 需要用到。**

---

## 第二步：PancakeSwap (BSC)

### 为什么选 PancakeSwap？

- ✅ 费用低（几十美元 vs Uniswap 几百美元）
- ✅ 用户群体大，BSC 生态活跃
- ✅ 适合新项目起步

---

### 2.1 将 MetaMask 连接到 PancakeSwap

1. 打开浏览器访问：**https://pancakeswap.finance**

2. 点击右上角 **"Connect Wallet"**

3. 选择 **MetaMask**

4. MetaMask 会弹出，点击**签名/连接**

5. 连接成功后，右上角应该显示你的钱包地址

---

### 2.2 将你的代币导入 PancakeSwap

> **关键步骤**：PancakeSwap 默认不显示你自己创建的代币，需要手动导入。

1. 在 PancakeSwap 页面，点击 **"Trade"** → **"Swap"**

2. 在顶部选择交易对，点击 **"From"** 旁边的代币选择器

3. 页面底部找到 **"Import Token"** 或搜索框

4. **粘贴你的代币合约地址**（从第一步部署获得）：

```
0xXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
```

5. PancakeSwap 会显示代币信息：
   - Name: Tokencoin
   - Symbol: TOKEN
   - Decimals: 18

6. 点击 **"Import"** 确认

7. 签名 MetaMask 交易（允许 PancakeSwap 读取你的代币余额）

**现在你的 TOKEN 已经可以在 PancakeSwap 上看到了。**

---

### 2.3 创建 TOKEN/BNB 流动性池

**这是让任何人都能交易 TOKEN 的核心步骤。**

1. 在 PancakeSwap 顶部菜单点击 **"Liquidity"**

2. 点击 **"Add Liquidity"**

3. **选择第一个代币**：
   - 点击代币选择器
   - 选择 **TOKEN**（已导入的）
   - 或搜索你的合约地址

4. **选择第二个代币**：
   - 选择 **BNB**

5. **输入数量**：
   - 假设你有 1,000,000 TOKEN
   - 按你想要的价格比例输入 BNB 数量
   - 例如：1 TOKEN = 0.00001 BNB，则输入 10 BNB

6. **设置滑点容忍度**（新手建议 0.5%-1%）：
   - 点击 ⚙️ 图标
   - 设置 **Slippage Tolerance** 为 **0.5%**

7. 点击 **"Enable TOKEN"**
   - 签名 MetaMask 交易（授权 PancakeSwap 使用你的 TOKEN）

8. 授权通过后，点击 **"Supply"**（供应）

9. 确认界面显示：
   - 你将添加的 TOKEN 数量
   - 你将添加的 BNB 数量
   - 你的 LP Token 份额（预估）

10. 点击 **"Confirm Supply"**

11. MetaMask 弹出，确认**所有 Gas 费用**

12. 点击**确认**

13. 等待区块链确认（约几秒到几十秒）

14. **成功！** 你会看到 "Add Liquidity Successful" 页面

---

### 2.4 验证流动性已添加

1. 在 PancakeSwap 点击 **"Liquidity"**

2. 连接钱包（如果未连接）

3. 应该能看到你的流动性池列表

4. 显示：
   - TOKEN/BNB 池
   - 你的份额
   - 获得的 LP Token 数量

**同时，在 BSCScan 上查看你的交易记录：**

1. 打开 **https://bscscan.com**

2. 粘贴你的钱包地址

3. 查看 **"Internal Txns"** 或 **"ERC-20 Transfer"**

4. 应该能看到：
   - TOKEN 转账到流动性池合约
   - BNB/ETH 转账到流动性池合约
   - LP Token 转入你的地址

---

### 2.5 给池子设置初始价格

> 初始价格由你添加的 TOKEN 和 BNB 比例决定。

```
举例：
添加 1,000,000 TOKEN + 10 BNB
初始价格 = 10 BNB / 1,000,000 TOKEN = 0.00001 BNB/TOKEN
        = 1 TOKEN = 0.00001 BNB
```

这个价格会成为 PancakeSwap 上显示的**当前价格**。

---

### 2.6 让用户能交易你的代币

**添加流动性后，任何人都可以：**

1. 打开 PancakeSwap
2. 选择 TOKEN/BNB 交易对
3. 用 BNB 购买 TOKEN
4. 或卖出 TOKEN 换 BNB

**用户如何找到你的代币：**

1. 在 Swap 页面点击代币选择器
2. 粘贴你的合约地址
3. 即可交易

---

### 2.7 流动性锁定（强烈建议）

> 添加完流动性后，建议锁定 LP Token，防止 Rug Pull 嫌疑，增加用户信任。

**锁定工具：**

- ** Unicrypt**: https://app.unicrypt.network/locks
- ** DXSale**: https://dxsale.app

**锁定步骤（以 Unicrypt 为例）：**

1. 打开 https://app.unicrypt.network
2. 连接钱包
3. 点击 **"Lock"**
4. 粘贴你的 **LP Token 地址**（从 PancakeSwap 获取）
5. 设置锁定时间（建议 6-12 个月）
6. 确认并签名

**锁定后：**
- LP Token 无法被转出
- 流动性池无法被撤走
- 用户更信任你的项目

---

## 第三步：Uniswap (Ethereum)

> 在 PancakeSwap 上有了初始流动性和市场验证后，再考虑 Uniswap。

### 3.1 与 PancakeSwap 的区别

| 对比项 | PancakeSwap | Uniswap |
|--------|-------------|---------|
| 网络 | BSC | Ethereum |
| Gas 费 | 低（$1-5） | 高（$50-300） |
| 用户群体 | BSC 生态 | ETH 生态，更主流 |
| 信任度 | 较低 | 较高 |
| 适合阶段 | 初期起步 | 中期扩展 |

### 3.2 部署到 Ethereum

**注意**：你的 MyToken.sol 是 ERC-20，理论上可以直接部署到 Ethereum。

1. 配置 MetaMask 连接 Ethereum Mainnet（默认已有）

2. 确保钱包里有 ETH（支付 Gas）

3. 部署：

```bash
npx hardhat run scripts/deploy-token.js --network mainnet
```

4. 记录合约地址

### 3.3 在 Uniswap 添加流动性

**步骤与 PancakeSwap 完全相同，只是网站不同。**

1. 打开 **https://app.uniswap.org**

2. 连接 MetaMask

3. 导入代币（粘贴合约地址）

4. 添加流动性（TOKEN/ETH）

5. 确认交易（**注意 Gas 费很高**）

---

## 第四步：Raydium (Solana)

### 重要说明

> Solana 使用 **SPL Token** 标准，和 ERC-20 **完全不同**。
> 你的 MyToken.sol (ERC-20) **不能**直接在 Solana 上使用。

### 选项 A：暂时跳过 Solana

当前项目阶段（ERC-20 + BEP-20）已经覆盖了：
- Ethereum (ERC-20)
- BSC (BEP-20)

**等未来有需要时，再考虑 Solana 方案。**

### 选项 B：使用跨链桥（未来）

如果未来需要在 Solana 展示代币：

1. 使用 **Wormhole** 或 **Allbridge** 跨链桥
2. 将 BSC/ETH 上的 TOKEN 映射到 Solana
3. 在 Solana 上获得 SPL 格式的包装代币
4. 然后可以在 Raydium 添加流动性

**结论**：当前阶段 **不需要** 考虑 Raydium，专注 PancakeSwap + Uniswap 即可。

---

## 安全与后续

### 添加流动性后的检查清单

- [ ] 合约已在 BSCscan 验证（可查看源代码）
- [ ] LP Token 已锁定（增加信任）
- [ ] 流动性池已创建并显示正确价格
- [ ] 测试一次买入和卖出
- [ ] 在社交媒体公布池子信息

### 常见问题

**Q: 为什么价格和预期不一样？**
A: 价格由池子里两种资产的比例决定。如果有人买入 TOKEN，BNB 会增加，TOKEN 会减少，价格自动变化。

**Q: 可以撤销流动性吗？**
A: 可以。在 "Liquidity" 页面点击你的池子，选择 "Remove"，即可撤回 TOKEN + BNB（扣除手续费后）。

**Q: 交易手续费是多少？**
A: PancakeSwap 每笔交易收 0.25%，其中 0.17% 给流动性提供者，0.03% 给 PancakeSwap，0.05% 给 TOKEN 回购。

---

## 附录：私钥完整指南

### A.1 私钥是什么

```
私钥（Private Key）
├── 本质：256位二进制数字（64位十六进制）
├── 示例：0x8f2a...3b7e（64个字符）
├── 用途：对交易进行数字签名，证明"我是Owner"
└── 性质：随机生成，无法推测，只有你知道

助记词（Seed Phrase）
├── 本质：私钥的人类可读版本
├── 示例：12或24个单词（apple, banana, cat...）
└── 关系：知道助记词 ≈ 知道私钥
```

**生成关系：**
```
助记词 (12/24个单词)
     │
     ▼
BIP39 算法
     │
     ▼
私钥 (0x8f2a...3b7e)
     │
     ▼
公钥 (0x7d3a...9f2c)
     │
     ▼
钱包地址 (0x1234...abcd)
```

---

### A.2 私钥如何生成

#### 方式 A：MetaMask 自动生成（最简单，推荐）

```
1. 安装 MetaMask 浏览器插件
2. 点击 "Create a new wallet"
3. 设置钱包密码
4. MetaMask 自动生成助记词（12个单词）
5. 把这12个单词抄写下来，保存到安全的地方
6. 完成！
```

#### 方式 B：命令行生成

```bash
node -e "const { randomBytes } = require('crypto'); console.log('0x' + randomBytes(32).toString('hex'));"
```

#### 方式 C：硬件钱包生成（最安全）

```
购买 Ledger 或 Trezor 设备
  ↓
按照说明创建设备钱包
  ↓
助记词写在设备的纸上（永不触网）
```

---

### A.3 私钥什么时候生成

**在项目中的使用时机：**

```
Day 1: 创建专门用于部署的钱包（MetaMask 新建账户）
Day 2: 配置 .env 文件（存放私钥）
Day 3: 运行部署脚本（用私钥签名）
Day 4+: 用 Owner 权限管理代币
```

**操作步骤：**

**Step 1: 创建专门的钱包**

```
建议：不要用日常操作的钱包
理由：减少暴露风险
操作：
1. MetaMask → 点击账户选择器 → 创建新账户
2. 名字改为 "Tokencoin Deploy"
3. 从交易所转少量 BNB/ETH 到这个钱包（用于支付 Gas）
```

**Step 2: 查看私钥**

```
MetaMask 查看私钥步骤：
1. 点击账户头像
2. 点击 "Account details"
3. 点击 "Export private key"
4. 输入密码
5. 显示私钥（0x开头，64字符）
```

**Step 3: 配置到项目**

```bash
# 在 token-launch 目录创建 .env 文件
cd token-launch
touch .env
```

```bash
# .env 文件内容
PRIVATE_KEY=0x8f2a9b4c7d3e5f1...（你的私钥）
BSC_RPC_URL=https://bsc-dataseed.binance.org/
```

**Step 4: 确保 .gitignore 包含 .env**

```bash
# 检查
cat token-launch/.gitignore | grep env

# 如果没有，添加
echo ".env" >> token-launch/.gitignore
```

---

### A.4 私钥如何使用

#### 在 Hardhat 部署脚本中

```javascript
// scripts/deploy-token.js

// 从 .env 读取私钥
const privateKey = process.env.PRIVATE_KEY;

// 创建钱包实例
const wallet = new ethers.Wallet(privateKey, provider);

// 部署合约
const MyToken = await ethers.getContractFactory("MyToken", wallet);
const token = await MyToken.deploy(wallet.address);
//                                         ↑ 这个钱包地址成为 Owner

console.log("Owner 地址:", wallet.address);
```

#### 完整部署流程

```bash
# 1. 确保 .env 存在且包含私钥
cat token-launch/.env

# 2. 确保 .gitignore 包含 .env
cat token-launch/.gitignore | grep env

# 3. 运行部署（先测试网）
cd token-launch
npx hardhat run scripts/deploy-token.js --network bscTestnet

# 4. 部署成功后会显示：
# MyToken deployed to: 0x...
# Owner: 0x...（就是你的钱包地址）
```

---

### A.5 私钥安全操作规范

#### ✅ 正确做法

```
1. 创建专门的钱包用于部署
   └── 不影响日常使用的主钱包

2. 私钥只写在 .env 文件
   └── 不要写在代码里

3. .env 加入 .gitignore
   └── 确保不上传 GitHub

4. 部署完成后考虑转多签
   └── Owner 权限转给 Gnosis Safe

5. 部署电脑保持安全
   └── 安装杀毒软件，不访问钓鱼网站
```

#### ❌ 错误做法

```
1. 把私钥写在代码里
   const PRIVATE_KEY = "0x123...";  // 永远不要！

2. 把私钥发到群里问问题
   "我的私钥是这个，帮我看看为什么部署失败？"

3. 把私钥截图发出去
   └── 任何截图都会被搜索引擎收录

4. 私钥存在云盘/邮件
   └── Dropbox、Google Drive 等都会被 hack

5. 访问钓鱼网站输入助记词
   └── 官方从来不要求你输入助记词
```

---

### A.6 代码公开 = 不安全？

**这是一个常见误解。**

```
公开的信息（任何人都能看到）：
├── 代码全文（GitHub）     ← 任何人都能看
├── Owner 地址（0x...）   ← 区块链公开透明
└── 合约地址              ← 任何人都能查看

但这些没用！因为：
├── mint()      ← 需要 Owner 私钥签名
├── pause()     ← 需要 Owner 私钥签名
├── blacklist() ← 需要 Owner 私钥签名
└── burn()      ← 需要 Owner 私钥签名

类比：
├── 保险箱制造图纸是公开的（代码）
├── 保险箱位置是公开的（Owner 地址）
└── 但密码只有你知道（私钥）

别人知道一切，却什么都做不了。
```

---

### A.7 私钥泄露后怎么办

```
如果私钥泄露（立刻行动）：

1. 创建新钱包
   └── MetaMask 新建账户或硬件钱包

2. 转移所有资产
   └── 把所有 BNB/ETH/代币转到新钱包

3. 对于已部署的合约
   └── 如果你是 Owner，立刻调用 transferOwnership 转走
   └── 如果来不及，黑客已经转走了
   └── 已部署的合约无法修改，只能靠法律途径

4. 旧钱包废弃不用
```

---

### A.8 多签钱包（强烈建议，大额资产时）

**什么是多签钱包：**

```
Gnosis Safe 多签钱包

优点：
├── 需要 2-3 人签名才能执行交易
├── 即使一人私钥泄露，黑客也无法单独控制
├── 可以设置时间锁（24小时后才能执行）
└── 团队共同管理，更透明

设置方法：
1. 打开 https://gnosis-safe.io
2. 创建 Safe（设置多签：例如 2/3 签名）
3. 把 Owner 从 MetaMask 转到 Safe 地址
4. 以后所有 Owner 操作需要 Safe 多签确认
```

---

## 下一步行动

1. **现在**: 创建专门的部署钱包，获取私钥
2. **配置**: 创建 .env 文件，配置私钥
3. **测试**: 在 BSC 测试网部署代币，练习添加流动性
4. **准备就绪**: 在 BSC 主网部署代币
5. **发布**: 在 PancakeSwap 添加初始流动性
6. **推广**: 在社交媒体公布交易对
7. **积累**: 等待交易量增长，建立社区信任
8. **扩展**: 有审计报告后，在 Uniswap 添加流动性
9. **申请 CEX**: 联系 Binance / Coinbase 上市团队

---

**最后更新**: 2026-05-01
