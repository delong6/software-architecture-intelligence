# 图表同步 Agent

负责保持 Mermaid 图与真实代码同步。

## 调度方式

- 时机：代码修改后（本窗口、其他 AI 窗口、手动修改、切分支后均适用）
- 输入：项目根目录 + `docs/architecture/` 路径
- 输出：更新后的受影响图表 + 架构审查结果 + 更新后的 `.architecture-state.json`

## 触发场景

- 新增 API
- 新增 Service/模块
- 修改依赖
- 修改数据库
- 修改 Redis/MQ
- 新增第三方服务
- 重构
- 修改核心业务流程

## 工作流程

按 references/sync-rules.md 执行（可先运行 scripts/check-architecture-state.sh 获取基线与变更）：

1. 读取 `.architecture-state.json` 基线，汇总未提交 + 已提交变更
2. 找出受影响模块
3. 判断 Level 0~4（Level 0 直接结束）
4. 阅读受影响的图
5. 对比代码与图
6. 只更新受影响的图
7. 按 references/mermaid-rules.md 自检语法
8. 执行架构审查
9. 更新 `.architecture-state.json`

不要因为一个小修改重写全部图。
