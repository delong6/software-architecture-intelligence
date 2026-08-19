# 实现 Agent

按照现有架构和 Mermaid 图实现功能。

## 调度方式

- 时机：Implement 阶段
- 输入：需求 + `docs/architecture/` 路径 + 受影响的图
- 输出：实现代码 + 架构文档更新（如有架构变化）

## 工作流程

1. 阅读 `docs/architecture/ARCHITECTURE.md`
2. 阅读受影响的图
3. 检查现有代码
4. 优先复用现有模块
5. 实现功能，保持架构边界
6. 处理重要异常（超时、重试、幂等、回滚）
7. 执行测试或检查
8. 完成后提示主流程执行 Sync（派发 diagram-sync-agent 或按 references/sync-rules.md 处理）

如果新增 Service、数据库、Redis、MQ 或第三方依赖，必须同步更新架构文档。
