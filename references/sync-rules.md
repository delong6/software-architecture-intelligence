# 同步规则（Git 基线机制）

代码修改后，通过 Git 基线确定"自上次同步以来的全部变更"，不局限于本次会话的未提交改动。
这样才能覆盖：已提交的历史变更、手动修改、其他 AI 窗口的修改、切换分支后的差异。

## 同步基线

`docs/architecture/.architecture-state.json` 记录上次同步完成时的 commit hash：

```json
{
  "last_sync_commit": "a1b2c3d4..."
}
```

`.architecture-state.json` 随图表一起提交，团队和多 AI 窗口共享同一基线。

## 快速获取变更

在目标项目根目录执行本 Skill 安装目录下的 scripts/check-architecture-state.sh，
一次输出基线 commit、HEAD、已提交变更、未提交与暂存文件：

```bash
sh <skill 安装目录>/scripts/check-architecture-state.sh
```

脚本不可用时，按下列等价命令手动汇总。

## 同步流程

1. 读取 `.architecture-state.json` 的 `last_sync_commit` 得到 base
   - 无此文件：视为首次同步，执行全量一致性审查后重建基线
   - base 不在当前分支历史内（切分支后 `git cat-file -e` 失败）：退化为全量一致性审查并重建基线
2. 汇总变更文件集：
   - 未提交改动：`git diff --name-only` + `git diff --cached --name-only`
   - 未跟踪文件：`git ls-files --others --exclude-standard`
   - 已提交改动：`git diff --name-only <base>..HEAD`
   - 非 git 仓库：全量扫描关键入口文件
3. 按影响等级（见 SKILL.md）判断更新范围，Level 0 直接结束
4. 阅读受影响的图，对比代码与图，只更新受影响的图
5. 按 references/mermaid-rules.md 自检语法
6. 执行架构审查（输出格式见 agents/architecture-review-agent.md）
7. 更新 `.architecture-state.json` 的 `last_sync_commit` 为当前 `git rev-parse HEAD`

## 触发同步的变更类型

模块、Service、API、数据库、Redis、MQ、第三方服务、登录、支付、预约、订单、核心业务流程相关的文件变更。

纯文案、CSS、构建脚本变更 → Level 0，跳过。

## 注意

- 不要因为一个小修改重写全部图
- 同步只修改图和架构文档，不修改业务代码
