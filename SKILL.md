---
name: software-architecture-intelligence
description: >
  当需要扫描代码库并在 docs/architecture/ 生成 Mermaid 架构图、流程图、时序图等架构文档，
  或在复杂功能开发前设计流程图/时序图，或在代码修改后（含其他 AI 窗口、手动修改、Git 切换分支）
  基于 Git 基线同步图表、检测架构漂移、执行架构一致性审查时使用。
  不适用于无架构影响的 CSS/文案/UI 简单调整。
---

# 软件架构智能 Skill

建立完整闭环：**需求 → 扫描 → 分析 → 设计图 → 实现 → 同步 → 审查**。

本 Skill 是项目级架构管理工作流，不只是 Mermaid 画图工具。架构图是开发过程中的活文档，不是代码写完后的装饰。

## 四种工作模式

| 模式 | 时机 | 核心动作 |
|---|---|---|
| Scan | 首次接入项目 | 扫描代码库，建立架构模型，生成 `docs/architecture/` |
| Design | 复杂功能开发前 | 分析受影响模块与异常流程，生成流程图/时序图，给出方案与风险 |
| Implement | 实现阶段 | 按架构边界实现，优先复用现有模块，处理重要异常 |
| Sync | 代码修改后 | 基于 Git 基线确定变更范围，只更新受影响的图，执行审查 |

### Scan

1. 读取根目录与配置文件，判断语言、框架、运行环境
2. 识别前端、后端、后台，识别入口、路由、API、分层结构
3. 识别数据库、Redis、MQ、OSS/CDN、第三方 API
4. 分析重要调用链和依赖，建立架构模型
5. 生成 `docs/architecture/`，写入 `.architecture-state.json` 基线

详细扫描清单与证据规则：references/code-analysis-rules.md
架构图层级与粒度规则：references/architecture-rules.md

### Design

1. 阅读当前架构，找出受影响模块
2. 分析成功、失败和异常流程
3. 选择图类型，生成流程图和/或时序图，必要时更新架构图
4. 分析 API、数据、依赖变化，给出实现方案和风险

### Implement

1. 阅读 `ARCHITECTURE.md` 和相关图
2. 阅读现有代码，优先复用现有模块，保持架构边界
3. 处理重要异常（超时、重试、幂等、回滚）
4. 架构发生变化时进入 Sync

### Sync

1. 通过 Git 基线汇总自上次同步以来的全部变更（不局限本次会话的未提交改动）
2. 判断影响等级，只更新受影响的图
3. 自检 Mermaid 语法
4. 执行架构审查，更新 `.architecture-state.json`

可运行本 Skill 安装目录下的 scripts/check-architecture-state.sh（在目标项目根目录执行），
一次获取基线、HEAD 与全部变更文件。完整流程与基线机制：references/sync-rules.md

## 图类型选择

| 问题 | 图类型 |
|---|---|
| 业务怎么走？ | 流程图 |
| 谁在什么时间调用谁？ | 时序图 |
| 系统由什么组成？ | 架构图 |
| 状态怎么变化？ | 状态图 |
| 数据实体怎么关联？ | ER 图 |
| 模块之间怎么依赖？ | 组件图 |

默认重点：架构图、流程图、时序图。中等功能 = 流程图 + 时序图；系统级变化 = 架构图 + 受影响的流程图/时序图。

详细规则：references/architecture-rules.md · references/flowchart-rules.md · references/sequence-rules.md · references/mermaid-rules.md

## 影响等级（决定同步范围）

| 等级 | 变化类型 | 动作 |
|---|---|---|
| Level 0 | 无架构影响 | 不更新图 |
| Level 1 | 业务逻辑变化 | 更新流程图 |
| Level 2 | API/系统交互变化 | 更新时序图 |
| Level 3 | 模块依赖变化 | 更新架构图 |
| Level 4 | 系统级架构变化 | 架构图 + 流程图 + 时序图 |

## Agent 调度

大规模任务通过 Task 工具派发子 Agent 并行执行，派发时将对应手册完整内容并入指令：

| 手册 | 职责 | 派发时机 |
|---|---|---|
| agents/architecture-scanner.md | 扫描代码库建立架构模型 | 首次接入项目 |
| agents/diagram-designer.md | 需求转 Mermaid 图 | Design 阶段 |
| agents/implementation-agent.md | 按架构实现功能 | Implement 阶段 |
| agents/diagram-sync-agent.md | 保持图与代码同步 | 代码修改后 |
| agents/architecture-review-agent.md | 一致性与风险审查 | 同步完成后 |

单会话内的小任务直接按本文件规则执行，不必派发子 Agent。

## 标准输出目录

```text
docs/architecture/
├── ARCHITECTURE.md             # 架构说明（模块职责、技术栈、关键决策、技术债）
├── architecture.mmd            # 架构图源文件
├── flows/                      # 业务流程图（.mmd）
├── sequences/                  # 时序图（.mmd）
└── .architecture-state.json    # 同步基线：上次同步完成时的 commit hash
```

## 架构漂移检测

双向检测，判断真实状态时以代码为主要依据：

- Code → Diagram：代码中存在但图中没有的 Service、API、依赖、MQ、数据库、第三方 API → 报告"架构漂移：xxx 已存在于代码中，但未记录在架构图中"
- Diagram → Code：图中存在但代码已没有的组件 → 报告"架构漂移：架构图显示 xxx，但当前代码未检测到该依赖"

## 最终原则

1. 以代码为唯一事实来源，禁止凭空编造不存在的组件
2. 一张图只解决一个主要问题，只展示主要系统、服务和依赖
3. 不要因为一个小修改重写全部图
4. 每次同步后必须执行一致性检查
