# 项目上下文 / Project Context

## 项目概述

本项目为**发币项目**，目标是在主流交易所发行一个符合法规、安全可靠的加密货币代币。

## 核心目标

1. 在 Ethereum 和 BSC 双链部署代币
2. 在 >= 3 家主流 CEX 上市
3. 确保合约安全 (>= 2 次审计)
4. 建立活跃社区

## 技术栈

- **智能合约**: Solidity ^0.8.24
- **框架**: Hardhat
- **标准库**: OpenZeppelin ^5.0
- **测试**: Mocha + Chai
- **语言**: TypeScript

## 重要文件

| 文件 | 用途 |
|------|------|
| `memory-bank/game-design-document.md` | 设计文档 |
| `memory-bank/technical-stack.md` | 技术栈规范 |
| `memory-bank/implementation-plan.md` | 实施计划 |
| `memory-bank/progress.md` | 进度记录 |
| `memory-bank/architecture.md` | 架构记录 |

## 工作流程

1. **开始前**: 完整阅读 `memory-bank/@architecture.md`
2. **开始前**: 完整阅读 `memory-bank/@game-design-document.md`
3. **完成后**: 更新 `memory-bank/@architecture.md`

---

## /init 命令

执行 `/init` 将生成以下规则文件:
- `.claude/CLAUDE.md` - 本文件
- `.claude/RULES.md` - Agent 行为规则
- `.claude/CONVENTIONS.md` - 代码规范
