---
name: software-architecture-intelligence
description: >
  面向个人开发者的项目级软件架构智能 Skill。以 Git 和当前代码库为事实来源，
  扫描项目、生成 Mermaid 架构图/流程图/时序图，并在不同 AI 窗口、手动修改代码、
  Git 切换分支或其他方式修改代码后，通过 Git 基线和代码扫描自动发现架构变化，
  同步更新图表并进行架构一致性审查。
---

# 软件架构智能 Skill

## 核心目标

解决一个人开发时最常见的问题：

> 代码不断变化，但架构图和文档逐渐过期。

本 Skill **不依赖当前 AI 对话窗口记住发生过什么**。

事实来源只有：

```text
当前代码库 + Git 历史
```

AI 对话只是执行分析、设计、同步和审查的入口。

核心闭环：

```text
代码库
  ↓
Git 架构基线
  ↓
扫描变化
  ↓
判断架构影响
  ↓
更新 Mermaid
  ↓
架构审查
  ↓
新的架构基线
```

## 一、核心原则

### 1. 代码优先

当代码与架构图冲突时：

```text
当前真实代码
    >
架构图
    >
旧文档
```

架构图是代码当前状态的可视化结果，不是事实来源。

### 2. 不依赖当前 AI 窗口

以下修改都必须能够被发现：

- 另一个 AI 窗口修改
- 手动修改
- 脚本修改
- 其他工具生成代码
- Git switch/checkout
- merge
- rebase
- cherry-pick
- reset

判断依据：

```bash
git status
git diff
git diff --name-only
git log
```

以及当前代码扫描。

### 3. Git 是架构同步基线

使用：

```text
docs/architecture/.architecture-state.json
```

记录最近一次架构同步对应的 Git commit。

例如：

```json
{
  "version": 1,
  "last_sync_commit": "a82f91c",
  "last_sync_time": "2026-08-19T10:00:00+08:00",
  "status": "clean"
}
```

因此可以比较：

```text
上一次架构同步
        ↓
commit A
        ↓
当前代码
        ↓
commit B
```

然后分析：

```bash
git diff A..B
```

---

# 二、工作模式

## 1. Scan：初始化/扫描

第一次使用：

```text
扫描整个项目
↓
识别技术栈
↓
识别应用
↓
识别模块
↓
识别依赖
↓
识别数据库/Redis/MQ/第三方
↓
生成架构图
↓
建立架构基线
```

生成：

```text
docs/architecture/
├── ARCHITECTURE.md
├── architecture.md
├── architecture.mmd
├── .architecture-state.json
├── flows/
└── sequences/
```

## 2. Design：设计

复杂功能开发前：

1. 阅读当前架构
2. 找出受影响模块
3. 分析成功、失败和异常流程
4. 选择需要的图
5. 生成流程图和/或时序图
6. 必要时更新架构图
7. 分析 API、数据和依赖变化
8. 给出实现方案和风险

## 3. Implement：实现

1. 阅读 `ARCHITECTURE.md`
2. 阅读相关架构图、流程图、时序图
3. 检查现有代码
4. 按既有架构实现
5. 架构发生变化时同步图
6. 执行架构审查

## 4. Sync：同步

1. 读取架构基线
2. 获取当前 HEAD
3. 检查未提交修改
4. 比较 `last_sync_commit..HEAD`
5. 分析变化文件
6. 判断影响等级
7. 对比代码与 Mermaid
8. 只更新受影响的图
9. 更新架构文档和同步状态
10. 执行架构审查

---

# 三、架构基线

文件：

```text
docs/architecture/.architecture-state.json
```

示例：

```json
{
  "version": 1,
  "last_sync_commit": "a82f91c",
  "last_sync_time": "2026-08-19T10:00:00+08:00",
  "status": "clean"
}
```

状态：

```text
clean
dirty
unknown
```

### clean

代码与架构图已经确认一致。

### dirty

代码发生变化，但尚未确认架构图是否需要更新。

### unknown

无法可靠判断基线，例如：

- commit 不存在
- Git 历史被重写
- 状态文件损坏
- 分支发生复杂变更

`unknown` 时执行完整架构扫描。

---

# 四、进入项目时的检查

每次 AI 开始项目级任务时，如果存在架构基线：

```bash
git status --short
git rev-parse HEAD
git diff --name-only
git diff --cached --name-only
```

读取：

```text
last_sync_commit
```

然后：

```bash
git diff <last_sync_commit>..HEAD --name-only
```

### 为什么必须同时检查 Git 和工作区？

情况 A：

```text
修改代码
↓
还没 commit
↓
AI 打开
```

此时 HEAD 没变化，但：

```bash
git diff
```

有变化。

情况 B：

```text
另一个 AI 窗口修改
↓
commit
↓
当前 AI 窗口打开
```

此时工作区可能干净，但：

```text
last_sync_commit → HEAD
```

发生变化。

所以两者必须同时检查。

---

# 五、架构影响等级

## Level 0：无架构影响

例如：

- CSS
- 文案
- 图片
- 简单 UI
- 局部样式

不更新图。

## Level 1：业务流程变化

例如：

- 增加库存判断
- 增加登录判断
- 增加失败重试
- 增加审核步骤

更新：

```text
flows/
```

## Level 2：交互/调用链变化

例如：

- 新增 API
- 新增 Service 调用
- 新增第三方 API
- 新增 Redis 调用
- 新增 MQ

更新相关时序图。

## Level 3：模块架构变化

例如：

- 新增 Service
- 新增业务模块
- 拆分 Service
- 修改核心依赖

更新：

```text
architecture.mmd
ARCHITECTURE.md
```

## Level 4：系统级变化

例如：

- 新增独立服务
- 前后端拆分
- 新增 MQ
- 数据库拆分
- 增加 Redis
- 新增第三方平台
- 修改部署拓扑

更新所有受影响的架构图、流程图和时序图。

---

# 六、架构漂移检测

## Code → Diagram

代码存在，但图中不存在：

```text
⚠️ 架构漂移

新增：
PaymentService

新增依赖：
PaymentService → 支付平台

受影响：
architecture.mmd
sequences/payment.md
```

## Diagram → Code

图中存在，但当前代码已经没有：

```text
⚠️ 架构漂移

架构图记录：
OrderService → Redis

当前代码未检测到：
Redis 依赖
```

以当前代码为准。

---

# 七、同步策略

不要每次保存代码都重新生成全部图。

使用：

```text
git diff
↓
找到变化文件
↓
判断架构影响
↓
只更新相关图
```

例如：

```text
src/components/Button.vue
```

通常：

```text
Level 0
不更新架构图
```

如果修改：

```text
src/services/order.ts
```

可能：

```text
Level 1/2
更新订单流程图和时序图
```

如果新增：

```text
PaymentService
↓
支付宝 API
```

则：

```text
Level 2/3
更新：
architecture.mmd
payment sequence
ARCHITECTURE.md
```

---

# 八、个人开发推荐方式

不要求后台持续运行 AI。

推荐：

```text
平时正常开发
↓
正常修改代码
↓
正常 Git commit
↓
需要 AI 工作时
↓
AI 自动检查架构基线
↓
发现代码变化
↓
判断是否影响架构
↓
需要则同步 Mermaid
```

这样避免每次保存都调用 AI，减少 Token 消耗和开发干扰。

---

# 九、推荐触发点

### 1. 打开项目

自动检查架构基线。

### 2. 开始复杂任务

例如：

```text
帮我开发支付功能
```

先：

```text
架构检查
↓
流程/时序设计
↓
开发
```

### 3. 完成功能

执行架构同步。

### 4. 主动触发

支持：

```text
扫描当前架构
同步架构图
检查架构漂移
更新 Mermaid
重新生成架构图
```

---

# 十、Git 分支处理

如果发生：

```bash
git checkout
git switch
git merge
git rebase
git cherry-pick
```

重新检查：

```text
last_sync_commit
↓
当前 HEAD
```

如果无法可靠比较：

```text
执行完整架构扫描
```

---

# 十一、架构图规则

架构图回答：

> 系统由什么组成？

推荐：

```text
Client
 ↓
Gateway
 ↓
Application
 ↓
Business
 ↓
Data
 ↓
External
```

只展示：

- 客户端
- 网关
- 应用
- 核心业务服务
- 数据库
- Redis
- MQ
- 存储
- 第三方服务

不要展示每个 Controller、DTO、函数或数据库字段。

---

# 十二、流程图规则

流程图回答：

> 业务怎么走？

必要时表达：

```text
成功
失败
条件
重试
超时
回滚
权限失败
重复请求
```

判断：

```text
{用户是否登录？}
{库存是否充足？}
```

分支：

```text
是 / 否
成功 / 失败
```

---

# 十三、时序图规则

时序图回答：

> 谁调用谁？

典型：

```text
用户
↓
前端
↓
API
↓
Controller
↓
Service
↓
Repository
↓
MySQL
```

外部服务：

```text
Service
↓
第三方 API
```

异步：

```text
Service
↓
MQ
↓
Worker
```

使用：

```text
alt
loop
par
```

表达分支、重试和并行。

---

# 十四、代码分析证据

优先级：

```text
1. 源代码
2. 配置
3. 依赖清单
4. 数据库迁移/Schema
5. Docker/Kubernetes
6. Git 历史
7. 文档
8. 命名推断
```

不能仅根据文件名判断架构。

例如：

```text
PaymentService.ts
```

不能单凭文件名认定存在完整支付系统，必须找到实际调用证据。

---

# 十五、标准目录

```text
docs/architecture/
├── ARCHITECTURE.md
├── architecture.md
├── architecture.mmd
├── .architecture-state.json
├── flows/
│   └── xxx.md
└── sequences/
    └── xxx.md
```

---

# 十六、输出格式

```text
架构检查

状态：CLEAN / DIRTY / UNKNOWN

检测范围：
- 基线 Commit：
- 当前 HEAD：
- 未提交修改：

架构影响：
- Level 0/1/2/3/4

检测到的变化：
- ...

需要更新：
- ...

无需更新：
- ...

架构漂移：
- ...

建议：
- ...
```

---

# 十七、最终原则

```text
Git + 当前代码
       ↓
   真实架构状态
       ↓
     AI 分析
       ↓
  Mermaid 可视化
```

而不是：

```text
当前 AI 对话记忆
       ↓
     猜测
       ↓
   Mermaid
```

**AI 可以忘记之前的对话，但不能忽略 Git 和当前代码。**

架构图必须成为代码库中的“活文档”。
