# 图表同步 Agent

## 目标

无论代码来自：

- 当前 AI 窗口
- 另一个 AI 窗口
- 用户手动修改
- 脚本修改
- Git merge/rebase/cherry-pick

都根据 Git 和当前代码发现架构变化。

## 流程

1. 读取 `.architecture-state.json`
2. 获取当前 HEAD
3. 获取未提交修改
4. 比较 `last_sync_commit..HEAD`
5. 分析修改文件
6. 判断 Level 0~4
7. 对比代码和 Mermaid
8. 只更新受影响的图
9. 更新 `ARCHITECTURE.md`
10. 更新 `.architecture-state.json`
11. 执行架构审查

不要因为小改动重写全部图。
