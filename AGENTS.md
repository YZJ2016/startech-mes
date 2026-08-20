# AGENTS.md

开始任何代码或配置修改前，必须阅读本文件，并以其中的项目边界、安全规则和验证规则为准。本文件由外层根仓库统一管理，适用于 `startech-mes-basic/` 子项目。

## 红线清单（改任何内容前先自查）

1. 不复述、不新增、不提交任何密码、Token、AccessKey、SecretKey、数据库连接凭据或生产地址；新增配置只能使用环境变量或占位符。
2. 不擅自改变既有接口契约：URL、HTTP method、认证头、响应的 `code/msg/data` 结构均视为兼容性边界。
3. 不引入第二套认证或数据访问方案；沿用既有 Spring Security/JWT、MyBatis 与现有分层模式。
4. 修改实体、枚举、接口、数据库字段或认证逻辑前，必须检查 Web 端调用方以及 Mapper/XML/SQL 等关联层。
5. 默认冻结技术栈和大版本依赖；Java、Spring Boot、Vue、Vue CLI、构建链升级必须作为独立任务，说明影响范围并完成对应构建验证。
6. 不声称“测试已通过”或“构建成功”，除非实际运行命令并获得成功输出。

下面各节是这些红线的具体展开。

## 项目形态与目录边界

外层仓库 `startech-mes` 管理文档、脚本和本文件。业务代码位于 `startech-mes-basic/`：这是一个**独立 Git 仓库**（自带 `.git`，不是 submodule），由外层 `.gitignore` 的 `/startech-mes-basic/` 排除，父仓库不得跟踪或提交其中内容。

`startech-mes-basic/` 当前包含同一 MES 系统的两个端：

- `backend/`：Java 后端，Maven 聚合项目，服务入口模块为 `ktg-admin`，默认 HTTP 端口为 `8085`。
- `frontend/`：管理 Web 端，Vue 2 + Element UI + Vue CLI 4；开发服务默认端口为 `80`（可用环境变量 `port` 或 `npm_config_port` 覆盖）。

本仓库当前**没有**车间平板端（无 `pad/`）。不要为管理端接口假设平板调用方，也不要擅自新增跨端工程。

后端 Maven 模块边界：

- `backend/ktg-admin`：Spring Boot 启动与 Web 接口入口；应用启动类为 `com.ktg.RuoYiApplication`。
- `backend/ktg-framework`：安全、Web、框架层能力。
- `backend/ktg-system`：系统管理相关领域能力。
- `backend/ktg-mes`：MES 业务领域；按 `md`、`pro`、`qc`、`wm`、`dv`、`cal`、`tm`、`report`、`task` 等包划分。
- `backend/ktg-common`：通用模型与工具；`backend/ktg-quartz`：定时任务；`backend/ktg-generator`：代码生成器。

不要将新业务逻辑放入 `ktg-admin` Controller；Controller 保持薄层，业务逻辑置于对应领域模块的 service 层。除非任务明确涉及，否则不要改动 `ktg-generator`、历史文档、`uploadPath`/`tmp`、构建产物或 `mes-docker`。

## 路径、命令与代码发现

- 外层仓库根目录是本文件的管理位置；`startech-mes-basic/` 是业务项目根目录。下文的 `backend/`、`frontend/` 路径均相对于 `startech-mes-basic/`，执行这些命令前先进入该目录。文档和命令不假设任何本机绝对路径。
- 执行 Git 命令前用 `git rev-parse --show-toplevel` 确认当前仓库根目录：改外层文档/脚本时根目录是外层仓库；改 MES 代码时根目录必须是 `startech-mes-basic/`。不要把子仓库文件 `git add` 到外层仓库。
- 该项目目前没有 `.codegraph` 索引。若后续建立索引，优先使用 CodeGraph；否则优先使用 codebase-memory-mcp 的 `search_graph`、`trace_path`、`get_code_snippet` 和 `get_architecture`。
- 图谱工具不可用或未覆盖时，使用 `rg` 定位代码；搜索 YAML、SQL、构建脚本、静态资源与文档可直接使用文件搜索。外层 `.gitignore` 会排除 `startech-mes-basic/`，工作区搜索可能扫不到子仓库，此时应直接在该目录内搜索。
- 修改前后先查看 Git 状态，避免覆盖用户已有未提交内容。

## 修改边界与多端影响

- 后端接口、实体或状态流转变更时，先定位所属 MES 领域包，再检查 `frontend/src/api/`、`frontend/src/views/` 和相关 store/router 的调用点。
- `frontend/src/utils/request.js` 统一处理 axios、Authorization 请求头、重复提交与响应错误。不要在单个页面复制认证、错误处理或下载逻辑。
- Web 接口代理和环境变量集中在 `frontend/vue.config.js` 与 `.env.*`。不得把真实服务地址或凭据硬编码到新代码、文档或示例中；也不要在回答中复述已有代理目标。
- 改数据库字段时，同步检查 Java domain/DTO、service、mapper XML、SQL、前端表单与列表和导出逻辑。

## 后端工作规则

- 保持 Java 8、Spring Boot 2.5.x、Maven 多模块、MyBatis、MySQL、Redis、JWT 与现有框架约定。不要为局部需求引入 JPA、新的 ORM 或并行认证体系。
- API 返回沿用项目既有结构；接口路径、请求方式、分页格式、错误码和 `Authorization` 请求头是客户端依赖的兼容性契约。
- 在 Controller 中只完成参数接收、权限注解和响应编排；校验、事务和领域规则应放在 service 层。避免扩大事务范围。
- 修改 Mapper、实体或 SQL 前，核实字段类型、空值语义、索引和历史数据兼容性。数据库变更应提供可审查、可回滚的脚本，除非用户明确要求不要直接操作共享数据库。
- 后端配置位于 `backend/ktg-admin/src/main/resources/`。这些文件可能已经含有敏感信息：不要在回答、日志、补丁或新文件中复制现有值；新增敏感项使用 `${ENV_VAR}` 或明确的非生产占位符。
- Swagger、文件上传、对象存储、认证、跨域、Druid、UReport 与 Docker 配置属于安全敏感面；修改时要说明暴露面和风险。

常用验证命令（先进入 `startech-mes-basic/` 后执行）：

```bash
cd backend
mvn test
mvn package

# 本地启动
cd ktg-admin
mvn spring-boot:run
```

运行 Maven 前先检查受影响模块是否有测试；若没有，至少运行受影响模块的编译或聚合构建，并在交付说明中写清验证范围。

## Web 前端工作规则

- 保持 Vue 2 Options API、Element UI、Vue Router、Vuex 与现有 `src/api`、`src/views`、`src/store`、`src/router` 的组织方式。
- 不要引入 Vue 3、Vite、TypeScript、Pinia、Tailwind 或新的 UI 框架，除非该升级被明确要求并作为独立任务验证。
- `frontend/package.json` 声明 `node >= 8.9`，未固定 Volta 版本。进入 `frontend/` 后再执行 Node/npm 命令，避免用全局 Node 版本改写依赖树。
- `frontend/` 当前没有已提交的 lockfile，且其 `.gitignore` 排除了 `package-lock.json` 与 `yarn.lock`。安装或更新依赖前先确认团队采用的包管理器；不得擅自新增、提交或因环境问题重写 lockfile。
- 新接口先在 `src/api/` 建立符合现有领域结构的封装，再由页面调用；不要直接在 Vue 页面散落 axios 配置。
- 路由、菜单和权限通常与后端权限数据关联。改动页面路由、菜单标识或按钮权限时，需与后端授权一起核对。

常用验证命令（先进入 `startech-mes-basic/` 后执行）：

```bash
cd frontend
node -v
npm install
npm run lint
npm run build:prod
```

若依赖未安装、Node 版本不符或构建失败，先报告实际输出；不要为绕过旧依赖问题而顺手升级 lockfile、Vue 或构建链。

## 安全底线

- 不要提交或生成真实 `.env`、私钥、证书、数据库备份、用户导出、生产配置副本或包含真实凭据的 Docker 覆盖文件。
- 已存在的明文凭据属于技术债，不应在任何输出中复述；若任务涉及相关配置，应先建议以环境变量或部署侧 Secret 管理替代，并保持现有运行兼容性。
- 数据库脚本分布在 `backend/sql/` 与 `backend/doc/`。历史初始化、示例和设计脚本视为不可原地改写的记录；需要调整 schema 或数据时，新增独立、可审查、可回滚的增量脚本，并在执行前明确目标环境与备份/回退方案。
- Web 端的服务地址、代理和协议变更必须集中在 `frontend/vue.config.js` 与 `.env.*` 完成。生产或试运行环境应优先使用 HTTPS 域名；不得新增裸 IP HTTP 依赖，也不得在页面代码、日志或文档中散落服务地址和凭据。
- 日志、异常信息、API 返回和前端 toast 不得暴露口令、Token、对象存储凭据、数据库连接详情或内部文件路径。
- 涉及权限、登录、Token、上传下载、对象存储、Swagger、跨域、UReport 或容器端口时，必须进行安全影响说明。

## 验证、交付与文件操作

- 只改文档时，检查目标文件存在、标题层级和 Markdown 结构正确、没有未完成标记或占位内容，也不包含敏感值。
- 改后端时优先运行 Maven 测试与编译；改 Web 时优先运行 lint 和生产构建。
- 每次交付清楚列出：修改文件、影响端（后端/Web）、实际执行的验证命令及结果、未验证项与原因。
- 遵循最小化补丁原则。不要使用 `git reset --hard`、`git checkout --`、批量删除、批量格式化或重写 vendor/静态/构建文件，除非用户明确授权。
- 修改代码时遵循 `karpathy-guidelines`：先说明可验证目标，保持改动聚焦，不夹带重构或依赖升级。

## 回答风格

- 说明问题时优先写明相关目录、模块与端的影响范围。
- 报告安全风险时可说明风险等级和修复方向，但绝不展示敏感值。
- 若只能完成静态分析或构建验证，必须明确未执行的运行时验证。
