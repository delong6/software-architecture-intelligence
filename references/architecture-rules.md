# 架构图规则

架构图回答：**系统由什么组成？**

## 推荐层级

```text
Client（客户端）
↓
Gateway（网关）
↓
Application（应用层）
↓
Business（业务层）
↓
Data（数据层）
↓
External（第三方）
```

## 粒度控制

只展示：主要系统、服务、数据库、缓存、队列、第三方平台、异步 Worker。

不要画进去：每个 Controller、DTO、函数、数据库字段、工具类。

## 分组

使用 subgraph 表达系统边界（客户端/服务端/数据层/第三方），subgraph 标题含空格时用
`subgraph ID[标题]` 形式。示例见 templates/architecture.mmd。

## 命名

使用项目真实名称（真实模块名、服务名、表名），不要用通用占位名。

## 更新时机

- Level 3（模块依赖变化）：必须更新
- Level 4（系统级变化）：必须更新，并检查受影响的流程图/时序图
- Level 1/2：一般不更新架构图，除非新增了对外系统、数据存储或第三方依赖

架构图更新时同步更新 `ARCHITECTURE.md` 的模块职责说明，并在其中记录已知技术债。
