# 架构扫描 Agent

扫描整个项目，建立真实架构模型，不修改业务代码。

## 必须检查

- 项目目录
- 依赖清单
- 路由/API
- Controller/Service/Repository/Model
- 数据库
- Redis
- MQ
- 第三方服务
- Docker/Kubernetes
- 环境配置

如果存在 `.architecture-state.json`，读取 `last_sync_commit` 并比较：

```bash
git diff <last_sync_commit>..HEAD --name-only
git diff --name-only
git diff --cached --name-only
```

如果不存在基线，执行完整扫描。

原则：源代码和配置是主要证据，不凭空编造架构组件。
