# 上游同步收口交接 — 2026-11-22（水位追平 tip，已推送，待全量批收尾验证）

## 状态

- 本地 HEAD：`cfcdd337a`（develop，已推送：先快进 `ce342d8182..f086d3e82a` 14 笔，后因本地线重建经用户批准 `--force-with-lease` 至 `cfcdd337a`，未做前端构建）
- **origin 远端曾在 kuaigeyun-mes 克隆中丢失，已恢复**：`origin = git@github.com:YZJ2016/kuaigeyun-mes.git`（私有 fork；`git ls-remote` 验证 develop=ce342d8182 与上次推送一致）
- 上游 tip：`13be286f11`（gitee/develop，「转单建单 Tab 重建与价税/采购下推联调」）——**评估水位已追平**，台账首部水位行已更新
- 台账：`kuaigeyun-mes/docs/上游同步台账.md`（提交级）+ `docs/上游同步-文件级台账.tsv`（文件级，~14,300 行）
- 审计工具：`riveredge-backend/scripts/sync_upstream_audit.py`（audit/seed/record，ls-tree 批量取 sha ~1s）
- 新会话续扫：`git fetch gitee develop --filter=blob:none` → `python riveredge-backend/scripts/sync_upstream_audit.py audit --from 13be286f11 --to gitee/develop`

## 本轮收口（挂账簇清零）

| 本地 commit | 上游 | 内容 |
|---|---|---|
| `dbac114cee` | tip 版 | 物料/供应商行级有效判定（material_active+galaxy+org stamping）+库存信息 |
| `3536af4e8e` | finance 簇 | `auto_apply_customer_prepayment_to_receivable` 配置键接线（PARAMETER_KEYS+IMPLEMENTED+warehouse 确认流门控；手动核销 API 不门控） |
| `102cf3059b` | `4ba2d15ae8` | 入站同步仅映射字段更新契约（`sync_record_needs_update`/`after_filter`/cosmic path 工具） |
| `87163cc559` | `f40f54e336` | 同步调度窗（`sync_schedule_window`+迁移 977，23 表 `to_regclass` 守卫）+头表价税对齐（`document_header_amount_contract`） |
| `5fac48340b` | `6abba1dbd5`/`154977d948` 等 | D 依赖簇：FG/PP/SD 三张绑表+revoke/对齐+push 服务+迁移 978+前端 reconcile 面板 |
| `2f94a027d5` | `959f65b743` | 同步对比层本体：`document_push_reconcile_service`+`/document-push/reconcile` 端点 |
| `fd6e1583af` | `905787348a` 等 | GB2828 抽样检验（字码/AcRe+转移规则+迁移 979+测试 4 例） |
| `20c22d89b3` | `91c8157e1e` | 采购入库外推强制重推 force+推送开关+详情状态（含前置 `c0a917fc45` 基座） |
| `46a0a5f288` | `ea1f4da58e` | RefreshButton+采购读加速（去读时回写）+门禁加固（顺带修本地缺 import latent bug） |
| `f086d3e82a` | `13be286f11` | 建单 Tab 重建+价税/采购下推联调（迁移 980/981；采购申请 740 行重写；uni-table tip 版保 antd6） |

## 验证记录（各阶段）

- pytest 相关域多轮全绿：1011/1630/1109/1204/1885（按簇分批）
- `py_compile` + import smoke 全过；`scan_timezone_contract` high=0；`git diff --check` 干净
- tsc 触及文件 0 新增错（全仓 ~2731 存量基线）
- **全量批收尾验证已完成**：pytest 3952 过（1 败 `test_push_run_log_records_source_dimensions` 已修→`cfcdd337a`，上游漏传 `source_type`/`source_id` 违反 spec-142）；tsc 2743 err（基线 ~2731，新文件零错，需 12GB 堆）
- ⚠️ **本地 develop 曾被新会话重写**：上游哈希标签从 gitee 链映射到镜像重写链（`60b2b2b844`/`2e564351bd`/`8fa7cb44fb` 等）；用户确认系其授权的新会话所为，已 `--force-with-lease` 推 `origin develop`（`f086d3e82a...cfcdd337a`）。**注意**：这些新标签不在 gitee/develop 链上，后续审计参照以镜像链为准（与台账"以 gitee 为权威源"惯例有偏差，若有疑义与用户对齐）

## 仍登记缓置（台账有领回条件）

- 4 页 create-pin+送审选人（sales-orders/quotations/sales-contracts/sales-forecasts）：本地提交流架构分叉，需先决策直提交流 vs 上游 commit+submit_review 双段选人 hook
- `avb_precheck`/`billentry_dual_qty`/`im_batch_update_sync`：移植闭包未 import
- `959f65b743` 同提交 `warehouse_service` 出库总量重算修复、前端 1% 税率 hunk
- `ea1f4da58e` `sent_pending` 删改断言：依赖更早未同步的 quotation `review_committed/is_submitted_status` 提交态加固
- `22e0787317`/`6c4351b42c` tip 增量、`is_force_rewrite_sync_mode` 调用点（force-rewrite/schedule 特性簇未到）
- 本地无上游域：material_batch_manage/multi_unit/storage_location/warehouse_location_ref/location_ref_sync 服务（N/A，非负债）
- en-US 等非 zh-CN locale（按 i18n-zh-cn-only 规则不落）

## 迁移号段

本地已用至 **981**（977 调度窗 23 表、978 绑表×3+trigger_kind、979 抽样转移、980 考评 reminder_lead、981 别名唯一）。下一迁移从 **982** 起。

## 流程约定（AGENTS.md 已固化）

- 逐提交为主节奏+主题簇领回为辅；文件级台账 verdict 永久留痕
- 每批：相关域验证（语法+相关 pytest+契约扫描）；**全量 pytest/tsc/build 只在批收尾里程碑跑**
- 文件级超集判定可派只读子代理并行预审，主线程只做落地
- `record` 的 note 必须 `--note` 旗标（位置参会生 `DELETED` 垃圾行）

## 下一步

1. ~~全量批收尾验证~~（已完成，见上）
2. 下次同步：`fetch gitee` → `audit --from 13be286f11` 起扫
3. 4 页 pin 修复若要领回，先与用户确认提交流架构选型
