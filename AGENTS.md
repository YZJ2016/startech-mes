# AGENTS.md

改代码或配置前先读本文件。外层仓库（本文所在 Git）管文档与本文件。长期开发的业务主仓库是独立 Git 仓库 `kuaigeyun-mes/`（父仓 `.gitignore` 排除，禁止把子仓文件提交进父仓）。细则以对应设计/缺口为准，不要在本文件展开决策表。

## 红线

1. 不改既有接口契约（URL、method、认证头、响应外层结构）。
2. 业务实现与提交只落 `kuaigeyun-mes/`。沿用该仓现栈：Python 3.11、FastAPI、Pydantic、Tortoise ORM、aerich、PostgreSQL、Taskiq；PC 端 `riveredge-frontend/`（React 18、TypeScript、Vite、Ant Design）。不引入第二套 ORM、认证或前端框架。换栈或大版本升级必须单独立项。
3. 改模型、枚举、接口或库字段前，核对 `riveredge-frontend` 调用方与 aerich 迁移。租户 / 组织隔离沿用快格现有实现。
4. 未实际跑通命令，不得声称测试/构建成功。
5. 外层 `docs/` 按编号分层；开发单元从 `docs/01.temlplates/01.development_unit_template.md` 复制到 `docs/04.specs/`。不要新建并列顶层目录，不要纠正 `01.temlplates` 拼写。
6. 可调业务配置沿用快格现有配置方式。密钥仍禁止进仓库，也禁止明文进可被运营编辑的配置。

## 多选项必须交用户决策

写需求、设计、拆分 spec，以及落地或修复代码时，只要存在多个可行的落地选项或修复选项，停下来由用户选定后再继续。不得用行业惯例、框架常见写法或「一般如此」自行拍板。

向用户说明时一次给齐：

1. **场景**：要解决的问题，以及它在当前仓库里的实际落点（文件、符号、调用关系）。
2. **选项**：每个做法改什么、影响哪一端。
3. **推荐**：只推一项，并写理由。取舍按本项目长期演进（现栈能否延续、契约与隔离是否保持、以后改动的成本），不按这次少改几行。

系统实际怎么工作，只以已经读到的代码为准。没在代码里出现的行为、字段、接口或调用方，不得写成既成事实，也不得用来制造或排除选项。代码与文档不一致时，指出冲突处，以代码为准。由代码唯一确定、不存在第二种做法时，直接做，不必再请示。

## 仓库

| 路径 | 角色 |
| --- | --- |
| `kuaigeyun-mes/riveredge-backend/` | 长期开发的后端（FastAPI）。新后端改这里。 |
| `kuaigeyun-mes/riveredge-frontend/` | 长期开发的 PC Web。新界面默认改这里。 |
| `kuaigeyun-mes/kuaigeyun-client/riveredge-app-mobile/` | 移动端 uni-app x 工程（H5、小程序、Android、iOS）；业务调用现有后端。 |
| `kuaigeyun-mes/kuaigeyun-client/riveredge-app-station/` | 工位端 Electron 壳；业务页面仍在 `riveredge-frontend/`。 |
| `kuaigeyun-mes/fast-deploy/` | 部署脚本。除非任务点名，不改。 |

改 MES 时 Git 根必须是 `kuaigeyun-mes/`。`kuaigeyun-client/` 由该仓跟踪，不另建 Git；该仓的提交只在该子仓内进行。

外层仓库**只保留 `main`**。文档与本文件只在 `main` 上改，不要在外层开长期功能分支。业务主仓 `kuaigeyun-mes/` 不受此约束。

改 `kuaigeyun-mes/riveredge-backend` 的 aerich 迁移时：文件仍放 `migrations/models/`；排序键是文件名第一个 `_` 之前的整数，不是中间时间戳。**禁止**接开源仓现有最大序号（如 793、794）续编——用户私有仓可能占用同一段连续序号。新迁移第一段须为 14 位时间戳，且大于本目录已有迁移文件名里出现过的最大时间戳（例：`20260924130000_kuaiai_chat_tables.py`）。不要另起 `001_` 重编；本仓只有一个 Tortoise app `models`，不能靠新目录得到第二套序号。已在库 `aerich` 表记录过的文件名不要改；未执行过的才可以改名。

## 上游同步（kuaigeyun-mes 私有 fork）

`kuaigeyun-mes/` 跟踪开源上游（Gitee/GitHub）。同步上游变更时适用本节约束；已评水位与取/跳过台账见 `kuaigeyun-mes/docs/上游同步台账.md`。

1. **先评估，后动手**。逐个上游提交评估对本地功能的影响；**任何导致现有功能不可用、被删除或行为劣化的变更不得直接落地**。评估结果按分区直观呈现：

   | 分区 | 含义 | 处置 |
   | --- | --- | --- |
   | 绿区 | 可直接 cherry-pick 或仅常规冲突（updateLog/locale 类）；不影响现有功能 | 评估后可摘，验证后落地 |
   | 黄区 | 有实质冲突、依赖本地偏离、上游代码在 pro 仓缺失、或含行为变更（如停发某提醒） | 逐案列影响面交用户决策，确认后适配或重建 |
   | 红区 | 会删除/破坏现有功能、与本地架构冲突、或造成同功能双实现并立 | 默认不取；用户明确要求才进入方案讨论 |

2. **落地顺序**：优先 `git cherry-pick`；冲突按「保留本地功能 + 并入上游增量」解决。不能直接 cherry-pick（架构偏离、pro 侧缺口）时，分析上游实现思路后在本地复刻——参照其契约（迁移 DDL、前端调用、测试）实现，并保留本地硬化（租户隔离、事务语义、权限门控）。
3. **迁移号避让**：上游占用段重映射到本地连续段，不改已入库 aerich 记录的文件名。
4. **复杂情况与多路径交用户决策**（同「多选项必须交用户决策」）：一次给齐场景、选项、推荐与理由，由用户选定后继续。
5. **验证与台账**：每批摘取后跑 `uv run pytest` + `npm run build`，dist 单独 `chore: build-web sync` 提交；台账（水位提交、取/适配/跳过映射）随每批同步更新 `kuaigeyun-mes/docs/上游同步台账.md`。

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

验证（先进入 `kuaigeyun-mes/`）：

```bash
cd riveredge-backend && uv run pytest
cd riveredge-frontend && npm run build
```

## 交付

改动聚焦，遵循 `.cursor/rules/karpathy-guidelines.mdc`。不夹带重构或依赖升级。未经授权不用 `git reset --hard` / `git checkout --` / 批量删除。交付列出修改文件、影响端、实际跑过的命令与结果、未验证项。日志、API、SSE、toast 不得暴露凭据、cipher 或内部路径。
