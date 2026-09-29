# AGENTS.md

改代码或配置前先读本文件。外层仓库（本文所在 Git）管文档与本文件。后续开发的主仓库是独立 Git 仓库 `kuaigeyun-mes/`（父仓 `.gitignore` 排除，禁止把子仓文件提交进父仓）。`startech-mes-basic/` 不再作为主仓库：未点名该目录时不改写、不在此开新功能。细则以对应设计/缺口为准，不要在本文件展开决策表。

## 红线

1. 不改既有接口契约（URL、method、认证头、响应外层结构）。
2. 实现与提交只落 `kuaigeyun-mes/`。沿用该仓现栈：Python 3.11、FastAPI、Pydantic、Tortoise ORM、aerich、PostgreSQL、Taskiq；PC 端 `riveredge-frontend/`（React 18、TypeScript、Vite、Ant Design）。不引入第二套 ORM、认证或前端框架。不要把 `startech-mes-basic` 的 JDK / Spring Boot / MyBatis / Vue 迁入，也不要把快格源码拷回 `startech-mes-basic`。两仓互不合并栈、包名或接口。换栈或大版本升级必须单独立项。
3. 改模型、枚举、接口或库字段前，核对 `riveredge-frontend` 调用方与 aerich 迁移。租户 / 组织隔离沿用快格现有实现。
4. 未实际跑通命令，不得声称测试/构建成功。
5. 外层 `docs/` 按编号分层；开发单元从 `docs/01.temlplates/01.development_unit_template.md` 复制到 `docs/04.specs/`。不要新建并列顶层目录，不要纠正 `01.temlplates` 拼写。
6. 可调业务配置沿用快格现有配置方式。密钥仍禁止进仓库，也禁止明文进可被运营编辑的配置。

## 仓库

| 路径 | 角色 |
| --- | --- |
| `kuaigeyun-mes/riveredge-backend/` | **后续开发**的后端（FastAPI）。新后端改这里。 |
| `kuaigeyun-mes/riveredge-frontend/` | **后续开发**的 PC Web。新界面默认改这里。 |
| `kuaigeyun-mes/fast-deploy/` | 部署脚本。除非任务点名，不改。 |
| `startech-mes-basic/` | **不再作为主仓库**。历史 Java / Vue MES。未点名不改；点名时才适用下文「遗留仓」。 |
| 外层 `RuoYi-Vue*` | 只读对照，不改。 |

改 MES 时 Git 根必须是 `kuaigeyun-mes/`。该仓的提交只在该子仓内进行。

外层仓库**只保留 `main`**。文档与本文件只在 `main` 上改，不要在外层开长期功能分支。`feature/mes-flyway-i10` 合入 `main` 后删除本地与 `origin` 上的该分支。业务主仓 `kuaigeyun-mes/` 不受此约束。`startech-mes-basic/` 同样不受此外层分支约束，但不再承接后续开发。

改 `kuaigeyun-mes/riveredge-backend` 的 aerich 迁移时：文件仍放 `migrations/models/`；排序键是文件名第一个 `_` 之前的整数，不是中间时间戳。**禁止**接开源仓现有最大序号（如 793、794）续编——用户私有仓可能占用同一段连续序号。新迁移第一段须为 14 位时间戳，且大于本目录已有迁移文件名里出现过的最大时间戳（例：`20260924130000_kuaiai_chat_tables.py`）。不要另起 `001_` 重编；本仓只有一个 Tortoise app `models`，不能靠新目录得到第二套序号。已在库 `aerich` 表记录过的文件名不要改；未执行过的才可以改名。

## 文档

外层 `docs/` 只按现有编号目录写，不新建并列顶层目录，不纠正 `01.temlplates` 拼写。各层不得串写：

| 目录 | 用途 | 不能写什么 |
| --- | --- | --- |
| `docs/01.temlplates/` | 模板 | 不在模板里填某个需求的正文 |
| `docs/02.requirements/` | 需求与缺口清单 | 不写实现步骤、验证记录 |
| `docs/03.design/` | 调研与设计 | 不写可执行 task 清单 |
| `docs/04.specs/` | 实现单元（spec / plan / task）**唯一**落点 | 不写到 `docs/superpowers/` 或其他技能默认路径 |
| `docs/05.manuals/` | 运维与验证手册 | 不写实现计划 |

新 spec 从模板复制五章，文件名 `NN.kebab-case-topic.md`。开写前看 `docs/04.specs/` 目录，序号接该目录已有最大 `NN`（两位）。**同一序号只许一个文件**（禁止 `74.foo.md` 与 `74.bar.md` 并存）。`docs/05.manuals/` 同样按目录最大号顺延，禁止同号。spec 开放缺口须能追溯到 `02.requirements/`，不要只散落在各 spec。`docs/superpowers/` 视为历史，不再当契约、也不再往里写。

## 后端 / Web

领域身份、隔离策略、模型目录与 Key、登录字段等细则写在对应需求/设计里，不在本文件展开。

- 路由只编排；规则在对应领域服务。新表结构走上文 aerich 迁移，不另起一套迁移目录。
- 前端新接口沿用 `riveredge-frontend` 现有请求方式。不要为局部需求升级 React / Vite / Ant Design。
- 排除数据源、Flyway、`sys_config`、Vue axios 等规则只属于遗留仓，不要套到快格。

验证（先进入 `kuaigeyun-mes/`）：

```bash
cd riveredge-backend && uv run pytest
cd riveredge-frontend && npm run build
```

## 遗留仓 `startech-mes-basic`

**默认跳过本节。** 仅当任务点名 `startech-mes-basic/` 时适用。下文 `backend/`、`startech-mes-front/`、`frontend/` 均相对该仓。

1. `POST /login` 必填 `tenantCode`，不为 Vue2 做成可省略。
2. 不引入第二套认证或 ORM：禁止 MyBatis-Plus、JPA、Sa-Token、Jugg、第二套 `SecurityFilterChain`。沿用 Spring Security/JWT、原生 MyBatis。
3. 改实体/枚举/接口/库字段/认证前，核对 Vue3 调用方与 Mapper/XML/SQL；租户表还须核对拦截器 include 与 `tenant_id`。
4. 栈冻结：JDK 17、Spring Boot 4.1.x、Jakarta EE、Vue 3（`startech-mes-front/`）、遗留 Vue 2（`frontend/`）。不要写回 Java 8 / `javax` / Boot 2.5。
5. 租户失败关闭：无 `TenantContext` 不得访问租户表；SQL 永不跳过 `tenant_id`（含现网 `admin` / `user_id=1`）；`isAdmin()` 不得关拦截器。登录后只信 JWT/`LoginUser`，禁止客户端租户头。
6. `/ai/**` 不进 `MesPermitAllProvider`；不合并 `ruoyi-ai`；AI 禁止直连 MES 业务库或任意 SQL。
7. 运营可改的配置走系统管理「参数设置」（`sys_config`），不写 yml。yml / 环境变量只留给启动必需、基础设施（端口、数据源、Redis）与密钥。

| 路径 | 角色 |
| --- | --- |
| `backend/` | Maven 聚合；入口 `ktg-admin`（`com.ktg.RuoYiApplication`，8085）。GAV `com.ktg`/`ktg`/`3.9.2` 不是栈版本。包名保持 `ktg-*` / `com.ktg`。 |
| `startech-mes-front/` | 该仓内的 Vue 3 管理端。 |
| `frontend/` | 遗留 Vue 2，**工程不再维护**（冻结，不是延期项）。多租户/AI/`/platform/**` 不改这里。不为 Vue2 补 `tenantCode`；无码登录失败已接受。 |
| 无 `pad/` | 不要假设平板调用方；平板入仓后不得注册 `/platform/**`。 |

`ktg-admin` 薄 Controller；业务在 `ktg-system` / `ktg-mes` / `ktg-ai`。除非任务点名，不改 `ktg-generator`、UReport、构建产物、`mes-docker`。

MES 五项接线：配置前缀 `ruoyi:`；`MesPermitAllProvider` 在 `ktg-common`/`ktg-mes` 注入放行（路径不写进 framework）；公告 `GET /system/notice/list` 只在 mes，不要补 `listTop`/`markRead`；默认上传 `POST /common/uploadMinio`（键 `tenant/{id}/`，空上下文拒绝）；手机号登录走既有 `UserDetailsServiceImpl`。租户解析域名优先，否则必填 `tenantCode`，禁止默认租户 1。

- 排除数据源自动配置用 Boot 4 包名 `org.springframework.boot.jdbc.autoconfigure.DataSourceAutoConfiguration`。不要把 Boot Jackson 3 `ObjectMapper` 注入 LangChain4j 或既有 Jackson 2 路径。文档用 SpringDoc，不是 springfox。
- Controller 只编排；规则在对应领域模块的 service。切线（76）之后新 DDL 只进 `ktg-system/src/main/resources/db/migration/{master,tenant}/`；`backend/sql/` 只作历史，不原地改、不追加发布脚本。`spring-boot-starter-flyway` 已在 `ktg-system`。不要把密钥写入 yml。不得扩大匿名面。基线号与目录见 `docs/03.design/05.mes-flyway-integration.md`、`docs/04.specs/75.mes-flyway-program.md`。
- 可运行时调整的项（业务开关、阈值、文案、限流、功能启停）走「参数设置」：增量种子 `sys_config`（切线后新键走 Flyway 脚本或既有 overlay 写入），代码读 `ISysConfigService.selectConfigByKey`，不新增 `@Value` / `@ConfigurationProperties` / yml 键。已有领域表（如模型目录）仍用领域表，不要再抄一份 yml。
- Vue3：axios 走 `src/utils/request.js`；代理与 env 只在 `vite.config.js` / `.env.*`；新接口先写 `src/api/`。不要提交 lockfile，不要为局部需求升级 Vue / Vite / Element Plus。

验证（Java 17，仅在改该仓时）：

```bash
cd backend && mvn test
# 仅编译：mvn -pl ktg-admin -am compiler:compile -DskipTests
cd startech-mes-front && npm run build:prod
```

## 交付

改动聚焦，遵循 `.cursor/rules/karpathy-guidelines.mdc`。不夹带重构或依赖升级。未经授权不用 `git reset --hard` / `git checkout --` / 批量删除。交付列出修改文件、影响端、实际跑过的命令与结果、未验证项。日志、API、SSE、toast 不得暴露凭据、cipher 或内部路径。
