# 代码分析规则

## 证据优先级

源代码 > 配置文件 > 依赖清单 > 数据库迁移/Schema > Docker/Kubernetes > 文档 > 命名推断。

- 不能只根据文件名判断依赖，必须有调用、配置或清单证据
- 文档可能过期，禁止把文档描述当作现状
- 发现架构漂移时，以当前真实代码为主要依据并报告不确定性

## 扫描入口清单

按存在性检查（有才读）：

| 类别 | 文件 |
|---|---|
| 依赖清单 | package.json、composer.json、go.mod、requirements.txt、pom.xml、build.gradle |
| 运行环境 | Dockerfile、docker-compose、.env*、Nginx 配置、Kubernetes 清单 |
| CI/CD | .gitlab-ci.yml、.github/workflows、Jenkinsfile |
| 说明 | README、docs/ |

## 技术栈识别

- 前端：Vue、React、Nuxt、Next.js、uni-app、微信小程序
- 后端：Laravel、ThinkPHP、Node.js、NestJS、Express、Go、Java、Python
- 基础设施：Nginx、Docker、Kubernetes、Redis、MySQL、PostgreSQL、MongoDB、MQ、CDN、OSS

识别到新旧双体系并存时（如两套 API 请求层、双 JWT 认证），如实记录并标注迁移状态，不要只记录其中一套。

## 依赖链模式

重点识别以下调用链：

```text
页面 → API Client → 后端 API → Controller → Service → Repository → MySQL
Service → Redis
Service → MQ → Worker
Service → 第三方 API
```

## 依赖证据来源

- import / require / use
- 方法调用与 Route 定义
- 依赖注入容器配置
- ORM Model 与 Repository
- Redis Client 的 get/set/publish/subscribe
- MQ Producer/Consumer
- HTTP Client 与 SDK
- 环境变量引用（DATABASE_URL、REDIS_HOST 等）
- Docker/Kubernetes 服务声明

## 禁止事项

- 禁止凭空编造不存在的组件
- 禁止把文档描述当作现状
- 禁止只凭目录名推断职责，需有代码证据
