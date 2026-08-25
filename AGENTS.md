# AGENTS.md

改代码或配置前先读本文件。外层仓库管文档与本文件；业务代码在独立 Git 仓库 `startech-mes-basic/`（父仓 `.gitignore` 排除，禁止把子仓文件提交进父仓）。下文 `backend/`、`startech-mes-front/`、`frontend/` 均相对该子仓。细则以对应设计/缺口为准，不要在本文件展开决策表。

## 红线

1. 不复述、不新增、不提交密码、Token、密钥、JDBC 凭据或生产地址；新配置只用环境变量或占位符。敏感变量只写名：`TENANT_JDBC_CIPHER_KEY`、`AI_MODEL_CIPHER_KEY`、`PLATFORM_ADMIN_PASSWORD`。
2. 不改既有接口契约（URL、method、认证头、`code/msg/data`）。`POST /login` 必填 `tenantCode`，不为 Vue2 做成可省略。
3. 不引入第二套认证或 ORM：禁止 MyBatis-Plus、JPA、Sa-Token、Jugg、第二套 `SecurityFilterChain`。沿用 Spring Security/JWT、原生 MyBatis。
4. 改实体/枚举/接口/库字段/认证前，核对 Vue3 调用方与 Mapper/XML/SQL；租户表还须核对拦截器 include 与 `tenant_id`。
5. 栈冻结：JDK 17、Spring Boot 4.1.x、Jakarta EE、Vue 3（`startech-mes-front/`）、遗留 Vue 2（`frontend/`）。升级或回退必须单独立项。不要写回 Java 8 / `javax` / Boot 2.5。
6. 未实际跑通命令，不得声称测试/构建成功。
7. 外层 `docs/` 按编号分层；开发单元从 `docs/01.temlplates/01.development_unit_template.md` 复制到 `docs/04.specs/`。不要新建并列顶层目录，不要纠正 `01.temlplates` 拼写。
8. 租户失败关闭：无 `TenantContext` 不得访问租户表；SQL 永不跳过 `tenant_id`（含现网 `admin` / `user_id=1`）；`isAdmin()` 不得关拦截器。登录后只信 JWT/`LoginUser`，禁止客户端租户头。
9. `/ai/**` 不进 `MesPermitAllProvider`；不合并 `ruoyi-ai`；AI 禁止直连 MES 业务库或任意 SQL。

## 仓库

| 路径                    | 角色                                                                                                                   |
| --------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `backend/`            | Maven 聚合；入口 `ktg-admin`（`com.ktg.RuoYiApplication`，8085）。GAV `com.ktg`/`ktg`/`3.9.2` 不是栈版本。包名保持 `ktg-*` / `com.ktg`。 |
| `startech-mes-front/` | **唯一上线**管理端（Vue 3）。新功能默认改这里。                                                                                         |
| `frontend/`           | 遗留 Vue 2，冻结。多租户/AI/`/platform/**` 不改这里。无 `tenantCode` 的 Vue2 登录失败已接受。                                                |
| 无 `pad/`              | 不要假设平板调用方；平板入仓后不得注册 `/platform/**`。                                                                                  |

`ktg-admin` 薄 Controller；业务在 `ktg-system` / `ktg-mes` / `ktg-ai`。除非任务点名，不改 `ktg-generator`、UReport、构建产物、`mes-docker`。外层 `RuoYi-Vue*` 只读。改 MES 时 Git 根必须是 `startech-mes-basic/`。

MES 五项接线：配置前缀 `ruoyi:`；`MesPermitAllProvider` 在 `ktg-common`/`ktg-mes` 注入放行（路径不写进 framework）；公告 `GET /system/notice/list` 只在 mes，不要补 `listTop`/`markRead`；默认上传 `POST /common/uploadMinio`（键 `tenant/{id}/`，空上下文拒绝）；手机号登录走既有 `UserDetailsServiceImpl`。租户解析域名优先，否则必填 `tenantCode`，禁止默认租户 1。

## 文档

外层 `docs/` 只按现有编号目录写，不新建并列顶层目录，不纠正 `01.temlplates` 拼写。各层不得串写：

| 目录                      | 用途                               | 不能写什么                             |
| ----------------------- | -------------------------------- | --------------------------------- |
| `docs/01.temlplates/`   | 模板                               | 不在模板里填某个需求的正文                     |
| `docs/02.requirements/` | 需求与缺口清单                          | 不写实现步骤、验证记录                       |
| `docs/03.design/`       | 调研与设计                            | 不写可执行 task 清单                     |
| `docs/04.specs/`        | 实现单元（spec / plan / task）**唯一**落点 | 不写到 `docs/superpowers/` 或其他技能默认路径 |
| `docs/05.manuals/`      | 运维与验证手册                          | 不写实现计划                            |

新 spec 从模板复制五章，文件名 `NN.kebab-case-topic.md`，序号接该目录最大号。spec 开放缺口须能追溯到 `02.requirements/`，不要只散落在各 spec。`docs/superpowers/` 视为历史，不再当契约、也不再往里写。

## 后端 / Web

- 排除数据源自动配置用 Boot 4 包名 `org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration`。不要把 Boot Jackson 3 `ObjectMapper` 注入 LangChain4j 或 Jackson 2 路径。文档用 SpringDoc，不是 springfox。
- `GET /login/resolveTenant` 匿名、至多一个编码、永不返回租户列表；`GET /getInfo` 含 `pwdChrtype`（前端 session 键 `pwrChrtype`）、`isDefaultModifyPwd`、`isPasswordExpired`，**不**回隔离级别/许可/JDBC；`POST /unlockscreen` ≠ 管理员解锁用户。登录失败文案统一。
- 增量 SQL：`backend/sql/YYYYMMDD_NN_topic.sql`；历史 `ry_*` / `mes-*` / `quartz.sql` 不原地改。未单独立项前不要加 `flyway-core`。模型 Key / JDBC 口令不进 yml。不得扩大匿名面。
- 平台账号是 `user_name=platform`（`tenant_id=0`），不是 `user_id=1`；现网 `admin` 只操作租户 1。`DATABASE` 专库不可用禁止回落主库；v1 禁止创建后改隔离级别或 JDBC 目标。平台页只在 Vue3 `/platform/**`。新租户表：`tenant_id` + 拦截器 include + 唯一键 `(tenant_id, 业务键)`。Redis 租户键用 `TenantCacheKeys`；异步用 `TaskDecorator` 拷贝 `TenantContext`。
- 模型 Key 只在 `ai_provider`/`ai_model`，禁止全局 `ChatModel` Bean。`ktg-ai` 只加 LangChain4j 坐标、不写 version（父 POM 已 import `1.19.0` / `1.19.0-beta29`）；禁止 `langchain4j-spring-bom`。不要擅自加写 Tools、SQL MCP 或匿名端点。
- Vue3：axios 走 `src/utils/request.js`（不加客户端租户头）；代理与 env 只在 `vite.config.js` / `.env.*`；新接口先写 `src/api/`；不要提交 lockfile 或升级 Vue/Vite/Element Plus。登录先 resolveTenant（Host 命中则写死该厂）。铃铛走 mes 的 `notice/detail`；SSO `GET /loginOuth`。AI 页在 `src/views/ai/`，不要引入 element-plus-x / Vben / TypeScript。

验证（先进入 `startech-mes-basic/`，Java 17）：

```bash
cd backend && mvn test
# 仅编译：mvn -pl ktg-admin -am compiler:compile -DskipTests
cd startech-mes-front && npm run build:prod
```

## 交付

改动聚焦，遵循 `.cursor/rules/karpathy-guidelines.mdc`。不夹带重构或依赖升级。未经授权不用 `git reset --hard` / `git checkout --` / 批量删除。交付列出修改文件、影响端、实际跑过的命令与结果、未验证项。日志、API、SSE、toast 不得暴露凭据、cipher 或内部路径。
