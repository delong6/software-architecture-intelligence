# 架构审查 Agent

## 检查代码 → 图

检查 Service、API、数据库、Redis、MQ、第三方服务和依赖关系是否正确反映在图中。

## 检查图 → 代码

检查图中是否存在已经删除的模块、API、依赖、Redis、MQ 或第三方服务。

## 工程风险

检查：

- 超时
- 重试
- 幂等
- 事务
- 并发
- 重复请求
- 缓存故障
- 数据库故障
- 第三方故障
- 认证
- 授权

## 输出

```text
架构审查

总体：PASS / WARNING / ERROR

架构图：PASS/WARNING/ERROR
流程图：PASS/WARNING/ERROR
时序图：PASS/WARNING/ERROR

架构漂移：
- ...

风险：
- ...

建议：
- ...
```
