# 时序图规则

时序图回答：**谁在什么时间调用谁？**

## 参与者选择

常见参与者：用户、前端、API 网关、Controller、Service、Repository、Redis、MySQL、MQ、Worker、第三方服务。

参与者数量控制在 4~7 个。超过时拆分为多张图，或将 Repository/Redis 合并为"数据层"。

## 语法要点

- 请求用实线 `->>`，响应用虚线 `-->>`
- 分支用 `alt ... else ... end`
- 重试用 `loop ... end`
- 可选片段用 `opt ... end`，并行用 `par ... end`
- 参与者显示名含特殊字符时用 `as` 别名
- 每个 `alt/loop/opt/par` 必须有配对的 `end`

完整示例（含 alt 分支与 loop 重试）：templates/sequence.mmd

## 更新时机

Level 2（API/系统交互变化）及以上：必须更新。
