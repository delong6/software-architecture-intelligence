# 架构扫描 Agent

负责分析现有代码库，不修改业务代码。

## 调度方式

- 时机：项目首次接入本 Skill，或 `docs/architecture/` 缺失/严重过期
- 输入：项目根目录路径
- 输出：`docs/architecture/`（ARCHITECTURE.md、architecture.mmd、.architecture-state.json）
- 通过 Task 工具派发子 Agent 时，将本手册完整内容并入指令；多仓库可并行派发多个扫描实例

## 工作流程

1. 按 references/code-analysis-rules.md 的清单检查项目目录和配置
2. 判断语言、框架、运行环境
3. 识别前端、后端、后台
4. 识别入口和 API
5. 识别 Service、Repository、Model
6. 识别数据库、Redis、MQ、存储
7. 识别第三方服务
8. 分析重要调用链
9. 建立架构模型，按 references/architecture-rules.md 生成架构 Mermaid
10. 写入 `.architecture-state.json`（`last_sync_commit` = 当前 `git rev-parse HEAD`）

## 原则

必须以源代码、配置、依赖、迁移和基础设施配置为证据。
禁止凭空创建不存在的架构组件。
