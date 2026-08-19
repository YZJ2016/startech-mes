# AGENTS.MD

开始任何代码修改前必须先阅读本文件，并以这里的项目边界、安全规则和验证规则为准。

## 红线清单（改任何东西前先自查）

1. 不复述、不新增任何密钥/密码/token/凭据；配置用占位符或环境变量（详见"安全底线"）。
2. 不改接口契约：路径、HTTP method、`code/msg/data` 结构视为破坏性变更（详见"数据库和接口契约"）。
3. 不引入第二套认证机制；沿用现有 Shiro/JWT（详见"后端工作规则"）。
4. 改后端字段/枚举/返回结构/认证头，必须回查所有调用端，且优先用图谱工具查全（详见"修改边界"）。
5. 冻结技术栈：不擅自升级 Vue/webpack/ORM/构建链；升级须走独立任务（详见"修改边界"）。
6. 不声称"已通过测试"，除非实际执行命令并看到成功输出（详见"验证和交付"）。

下面各节是这些红线的展开与具体验证方式。

## 项目形态

这是一个多端业务系统集合，不是单一应用。业务前端入口多数共用 `startech-web-management/back` 这个 Spring Boot 单体后端；另有独立的统一登录门户与 UI 原型工程，不默认走该 Java 后端。

- `startech-web-management/back`: 核心 Java 后端，默认端口 `9009`，技术栈为 Spring Boot 2.6.6、Java 8、MyBatis-Plus、Shiro、JWT、Druid、Quartz。
- `startech-web-management/admin`: 后台管理 Web 端，Vue 2、Element UI、webpack 3、axios。
- `startech-web-management/enterprise`: 企业 Web 端，技术栈与 `admin` 基本一致。
- `startech-web-management/institution`: 机构 Web 端，技术栈与 `admin` 基本一致，默认开发端口 `8002`。
- `startech-weapp-person`: 个人端微信小程序，原生小程序 + Vant Weapp。
- `startech-weapp-enterprise`: 企业端微信小程序，原生小程序 + Vant Weapp。
- `startech-web-pc`: 静态官网/展示站，主要是 HTML/CSS/JavaScript，不应默认当作业务后端客户端处理。
- `startech-login-portal`: 统一登录门户（独立 git 仓库，与 `startech-web-pc` 同级，由根目录 `.gitignore` 排除，不作为 submodule）。Vue 3 + Vite 前端，Node.js + Express 后端，SQLite；独立维护门户账号与应用目录，不复用 Java 单体后端与 Shiro/JWT。定位是应用入口管理，不是全量 OAuth2/OIDC 认证中心。目录为空时需单独 `git clone`。
- `startech-prototype`: 多端 UI 可交互原型（本地 mock，不接真实后端）。含 `apps/admin`、`apps/enterprise`、`apps/institution`（Vue 2 + Element UI，与业务 Web 同栈）、`apps/weapp-person` / `apps/weapp-enterprise`（Vue 3 手机框原型）、`apps/web-pc`（静态官网原型）。用于页面还原与交互演示，不要当作生产业务客户端或真实后端调用端处理。
- `startech-web-management/renren-generator`: Renren 风格代码生成器。除非明确要求生成或调整生成器，否则不要动。

## 路径和命令约定

- 不要在规则或脚本中假设固定绝对路径。Windows、macOS、Linux 上的 checkout 位置都可能不同。
- 后续命令默认从项目根目录执行。项目根目录指包含 `AGENTS.MD`、`startech-web-management`、`startech-weapp-person`、`startech-weapp-enterprise`、`startech-web-pc`、`startech-login-portal`、`startech-prototype` 的目录。
- 文档中的路径优先写相对路径，例如 `startech-web-management/back`。只有在说明本机当前环境时才写绝对路径。
- 命令需要同时照顾 Windows PowerShell 和 macOS/Linux shell；如果命令有差异，分别给出 `Windows PowerShell` 和 `macOS/Linux` 版本。
- `cd 子目录`、`mvn ...`、`npm ...` 这类简单命令通常跨平台一致，可以在两个平台共用。涉及环境变量、路径分隔符、删除/移动文件、后台进程时必须分平台写。

进入项目根目录示例：

```powershell
# Windows PowerShell 示例；实际路径按本机 checkout 位置调整
cd C:\path\to\startech
```

```bash
# macOS/Linux shell 示例；实际路径按本机 checkout 位置调整
cd /path/to/startech
```

后端主要包边界：

- `io.renren.modules.sys`: 后台管理、系统能力、基础资料、企业/用户/合同/字典等管理接口。
- `io.renren.modules.app`: 个人端小程序接口，常见路径前缀 `/app/...`。
- `io.renren.modules.enterprise`: 企业端接口，常见路径前缀 `/enterprise/...` 和 `/app/enterprise/...`。
- `io.renren.modules.job`: 定时任务。
- `io.renren.modules.oss`: 文件上传和对象存储。

## 代码发现优先级

本项目根目录存在 `.codegraph`，且项目也使用 codebase-memory-mcp。理解或定位代码时，优先顺序如下：

1. 使用 CodeGraph 的 `codegraph_explore`，`projectPath` 指向当前项目根目录或具体子项目目录。不要硬编码某台机器上的绝对路径。
2. 使用 codebase-memory-mcp：`search_graph` / `search_code`、`trace_path`、`get_code_snippet`、`get_architecture`。
3. 只有在图谱工具无法覆盖时，才使用 `rg`、`Get-ChildItem`、直接读文件等方式。
4. 搜索配置、脚本、静态资源、SQL、README、环境变量时，可以直接使用文件搜索。

不要在没有先查询图谱的情况下大面积 grep Java/Vue 代码。

## 修改边界

- 拆分 spec 时，必须使用 `docs/01.temlplates/01.development_unit_template.md` 作为每个开发单元的模板，并将拆分后的 spec 文件存放在 `docs/04.specs/`,开发完成后必须回填spec。
- 修改业务接口时，先确认影响的是 `sys`、`app` 还是 `enterprise` 模块。不要把个人端逻辑混入企业端控制器，也不要把管理端专用逻辑暴露给小程序端。
- 多端共用同一个后端数据模型和服务层。改后端字段、枚举、返回结构、错误码、认证头时，必须同步检查 `admin`、`enterprise`、两个小程序的调用点。查全调用点优先用图谱工具（如 `trace_path(cross_service)` / `codegraph_explore`）而非人肉记忆，再逐端核对（见"代码发现优先级"）。
- 冻结技术栈是默认护栏，但不是永久禁令：确需升级/迁移（Vue、webpack、ORM、构建链、依赖大版本等）时，作为独立任务处理，附影响范围说明并跑通对应端构建后再交付，不要夹带在其它改动里顺手升级。
- Web 管理端和企业 Web 端结构高度相似，但不要盲目同步复制。先确认两个端是否确实需要一致。
- 小程序端 `utils/request.js` 是请求封装热点。修改 token、跳登录、错误 toast、base URL 时，要同时检查个人端和企业端。
- 静态官网和 `startech-web-management/www` / `startech-web-pc` 中的 jQuery、WOW、UEditor、WebUploader 等第三方静态文件通常视为 vendor 代码；除非明确要求，不要格式化或重写。
- `renren-generator`、数据库初始化 SQL、历史文档不要顺手清理。只在任务明确涉及时修改。
- Must: 修改代码时，要严格遵循karpathy-guidelines Skills的约束。

## 安全底线

- 仓库中已有环境配置包含数据库连接、JWT secret、部署账号等敏感信息。不要在回答、日志或新文件中复述具体密钥、密码、token、内网/公网凭据。
- 不要新增任何明文密码、AccessKey、SecretKey、JWT secret、SSH 账号或生产数据库地址。新增配置应使用环境变量、占位符或部署侧配置。
- 如果必须改配置文件，优先保留示例结构并替换为占位符，例如 `${DB_PASSWORD}`、`${JWT_SECRET}`。
- 不要提交或生成真实 `.env`、证书、私钥、数据库备份、导出的用户数据。
- 涉及登录、token、权限、文件上传、短信、对象存储、Druid 控制台、Swagger 暴露面时，必须做安全影响说明。
- 企业小程序和个人小程序的接口域名不一致时要特别小心。生产小程序应优先使用 HTTPS 域名，不要新增裸 IP HTTP 依赖。
- 注意现状：企业小程序 `config/env.config.js` 的 `develop`/`trial`/`release` 当前均为裸 IP HTTP（`http://129.28.201.46:9009`），个人小程序三套均为 HTTPS 域名（`https://api.gst-tsr.com`）。改动请求域名时应向 HTTPS 收敛，不要扩大裸 IP HTTP 面。

## 后端工作规则

- 后端入口在 `startech-web-management/back`。
- 使用 Maven 项目配置，Java 版本按现状保持 Java 8，除非用户明确要求升级。
- Controller 返回风格以现有 `R` / `RestResult` 和项目约定为准，不要引入新的响应包装格式。
- 数据访问沿用 MyBatis-Plus、Mapper XML、ServiceImpl 模式。不要为局部改动引入 JPA、QueryDSL 或新的 ORM。
- 现有项目使用 Shiro/JWT 认证体系。不要为单个接口引入另一套认证机制。
- 修改实体字段时，检查对应 Form、DTO、Mapper XML、数据库 SQL、前端表单和小程序展示。
- 避免扩大事务范围或在 Controller 中堆业务逻辑；优先放在 service 层。
- 后端配置默认 profile、数据源、上传地址、Redis 开关等会影响所有端，修改前必须说明影响范围。

常用验证命令需要在对应目录执行：

```powershell
# Windows PowerShell，从项目根目录执行
cd startech-web-management\back
mvn test
mvn package
```

```bash
# macOS/Linux shell，从项目根目录执行
cd startech-web-management/back
mvn test
mvn package
```

注意：当前 `pom.xml` 配置跳过单元测试。声称测试通过前，必须说明实际执行的命令和 Maven 输出含义。

## Web 前端工作规则

- `admin`、`enterprise` 及同栈 Vue Web 端都是 Vue 2 + Element UI + webpack 3 老项目。保持 Vue 2 Options API 和既有目录结构。
- 不要引入 Vue 3、Vite、Pinia、TypeScript、Tailwind 或新的 UI 框架，除非任务明确要求升级。
- API 封装集中在 `src/api/**` 和 `src/utils/httpRequest.js`。新增接口优先按现有业务目录组织。
- 路由和菜单通常与后端权限/菜单数据相关。改页面路由前，确认后端菜单、权限标识和接口是否匹配。
- 这些前端依赖较老，尤其 node-sass、webpack、axios、lodash 等。不要随意升级依赖；升级必须作为单独任务处理并验证构建。

### Node 版本管理（Volta，已落地方案）

老前端（webpack 3 + 旧 sass/node-sass 链）与 Node 17+（含 Node 22）不兼容：常见失败包括 `node-sass` 原生编译失败，以及 OpenSSL 3 导致的 `digital envelope routines::unsupported`。不要借机升级 Vue/webpack，也不要再靠「高版本 Node + openssl-legacy-provider / sass 别名」那套向下兼容配方作为主方案。

统一用 [Volta](https://volta.sh/) 在对应前端目录钉死 **Node 14.21.3**。进入该目录后 Volta 会自动切换，无需手动 `nvm use`。

已 pin 目录（各目录 `package.json` 含 `"volta": { "node": "14.21.3" }`）：

- `startech-web-management/admin`
- `startech-web-management/enterprise`
- `startech-web-management/institution`
- `startech-prototype` 及其同栈子应用（`apps/admin`、`apps/enterprise`、`apps/institution`）

本机需先安装 Volta；新同栈 Vue Web 目录也应同样 `volta pin node@14.21.3`，不要另起一套 Node 方案。

验证（把目录换成目标前端即可）：

```powershell
# Windows PowerShell，从项目根目录执行
cd startech-web-management\admin
node -v
# 期望：v14.21.3
npm install
npm run build
```

```bash
# macOS/Linux shell，从项目根目录执行
cd startech-web-management/admin
node -v
# 期望：v14.21.3
npm install
npm run build
```

注意：

- 必须先 `cd` 到已 pin 的前端目录再执行 `npm`；在仓库根目录或未 pin 目录跑命令会落到全局默认 Node（可能是 22），构建易失败。
- 这是运行时版本锁定，不是技术栈升级；不要顺便升 Vue、webpack、Element UI 或大改构建链。
- 若依赖未安装或 Node 未切到 14.21.3，先汇报现象与 `node -v` / `volta --version`，不要擅自大版本升级 lockfile 或依赖树，也不要回退到 openssl-legacy 高版本兼容方案。

常用命令：

```powershell
# Windows PowerShell，从项目根目录执行
cd startech-web-management\admin
npm run dev
npm run build
```

```powershell
# Windows PowerShell，从项目根目录执行
cd startech-web-management\enterprise
npm run dev
npm run build
```

```bash
# macOS/Linux shell，从项目根目录执行
cd startech-web-management/admin
npm run dev
npm run build
```

```bash
# macOS/Linux shell，从项目根目录执行
cd startech-web-management/enterprise
npm run dev
npm run build
```

## 微信小程序工作规则

- 个人端和企业端是两个独立小程序目录，但请求封装、页面模式和依赖非常相似。
- 依赖为 `@vant/weapp` 和 `@vant/area-data`。不要引入跨端框架或构建链，除非用户明确要求迁移。
- 新增页面必须同步检查 `app.json` 页面注册、分包/主包体积、tabBar、导航栏配置。
- 修改请求域名时检查 `config/env.config.js` 的 `develop`、`trial`、`release` 三套配置。
- 小程序登录例外接口、token header、401 跳转逻辑要和后端认证保持一致。
- 不要把管理端接口直接暴露给小程序，除非后端已有明确的 app/enterprise 端授权控制。

常用检查：

```powershell
# Windows PowerShell，从项目根目录执行
cd startech-weapp-person
npm install
```

```powershell
# Windows PowerShell，从项目根目录执行
cd startech-weapp-enterprise
npm install
```

```bash
# macOS/Linux shell，从项目根目录执行
cd startech-weapp-person
npm install
```

```bash
# macOS/Linux shell，从项目根目录执行
cd startech-weapp-enterprise
npm install
```

小程序通常需要微信开发者工具进行完整运行验证。无法运行微信开发者工具时，必须在最终说明中明确验证缺口。

## 数据库和接口契约

- 数据库脚本位于 `startech-web-management/back/db`、`startech-web-management/document` 等目录。
- 改数据库字段时，必须同步检查 Java entity/form、Mapper XML、前端表单、列表字段、小程序字段展示。
- 接口路径已经被多端硬编码调用。重命名路径、改 HTTP method、改返回 `code/msg/data` 结构都视为破坏性变更。
- 列表分页、字典项、审核状态、报名状态、消息已读状态等枚举要复用现有约定，不要发明新含义。

## 验证和交付

- 只改文档时，至少检查目标文件存在、内容完整、无明显占位符。
- 改后端时，优先运行 Maven 编译/测试；如果无法运行，说明原因和未验证风险。
- 改 Web 前端时，优先运行对应端 `npm run build`；界面改动还应浏览器检查关键页面。
- 改小程序时，至少静态检查 `app.json`、请求封装、相关页面 JS/WXML/WXSS；能使用微信开发者工具时再做运行验证。
- 不要声称“已通过测试”除非实际执行过对应命令并看到了成功输出。

## Git 和文件操作

- 根目录本身只是多项目集合，不是有效 git 仓库（根目录 `.git` 为空目录，部分工具会误报根目录为 git 仓库、branch 显示 `HEAD`）。执行 git 前先用 `git rev-parse --show-toplevel` 确认所在仓库。
- 独立业务仓库各有自己的仓库历史：`startech-web-management`、`startech-weapp-person`、`startech-weapp-enterprise`、`startech-web-pc`、`startech-login-portal`、`startech-prototype`；其中 `admin`、`enterprise`、`institution`、`back` 同属 `startech-web-management` 一个仓库，并非各自独立。根目录仓库主要承载文档与规范，上述子工程通过 `.gitignore` 排除，**不使用 git submodule**。
- 不要使用 `git reset --hard`、`git checkout --`、批量删除、批量格式化 vendor/static/build 文件，除非用户明确要求，或者你需要执行的时候 要跟客户进行确认才能执行。
- 可能存在用户未提交改动。修改前后都要避免覆盖不相关文件。
- 手工编辑文件时使用最小化补丁（各 agent 用各自的编辑工具即可），保持改动小而可审，避免整文件重写。

## 回答风格

- 说明问题时优先给出具体路径和模块影响范围。
- 涉及安全风险时可以明确指出风险等级，但不要泄露具体密钥值。
- 涉及多端影响时，用“后端 / admin / enterprise / 个人小程序 / 企业小程序 / 静态官网”逐项说明。
- 如果只能做静态分析，必须明确说没有完成运行时验证。
