# 交接文档 — 上游同步（批C 进行中，停在 4d124a088e 之前）（2026-11-16）

> 本文档是给下个会话的精确接续点。每笔落地详情看 `kuaigeyun-mes/docs/上游同步台账.md`（权威记录），本文只负责「做到哪、下一步做什么、怎么继续」。

## 总目标与红线

- 目标：选择性同步上游（gitee `kuaigeyun` 开源仓），**不整体替换**、不删/不坏现有本地功能。
- 私有架构必须保住：`apps.kuaicaiwu` 是财务唯一权威（上游已改为 `apps.kuaizhizao.finance`/`optional_pro`，**一律不引入**）、星数采、kuaiiot、kuaicaiwu、租户/组织隔离、权限/审核门控、spec-142 确认流语义、跟踪中的治理文件。
- 多选项必须交用户决策（AGENTS.md 条款）：红区/黄区、删功能、双实现、架构分叉时停下给「场景+选项+推荐」。

## 批次划分总览（第七批次，水位 29b785f655 → 评估 tip dbfcfe37a9）

上游该段共 ~336 个非 merge 提交，按域分批：

| 批次 | 域 | 规模 | 状态 |
| --- | --- | --- | --- |
| 批A | 地基散修（自定义字段、导入导出、UniTable 等） | ~多笔 | ✅ 完成（台账「批A 地基散修」节，含复查修复） |
| 批B | 宿主财务 ORM 收口 | 1 笔主线 | ✅ 完成（`52bce20beb`→`6a5df8d50d`，kuaicaiwu 语义适配） |
| 批C | 价税+采购（含 C3 财务适配） | ~35 笔 | **进行中，见下节** |
| 批D1/D2 | 数据互通（金蝶外推/入站同步/库位/同步对比） | ~45 笔 | 未开始 |
| 批E | 仓储/MES 核心（序列号 UI、库位、工单、委外） | ~35 笔 | 未开始 |
| 批F | 审批/企微/haoligo/杂项 | ~40 笔 | 未开始 |
| 批G | fast-deploy 摘选 + merge 净增量大对账 + 台账收尾 | — | 未开始 |

快照分支：`backup/batch-b-pre-20261116-1111`、`backup/batch-c-pre-20261116-1242`（本地分支，回滚锚点）。

## 批C 进度（进行中）

### 已落地（上游 → 本地，按处理顺序）

| 上游 | 本地 | 备注 |
| --- | --- | --- |
| `0513e907f5` | `e9bb8f0c3e` | 采购申请审批选边整页空白修复 |
| `d892f36d03` | `b0da889868` | 需求方+询价工作流 |
| `5f085a19c9` | `22b20bfdf8` | 采购退货红字应付+工装模具（kuaicaiwu 适配） |
| `029aa6f542` | `03e693934a` | 采购下推保留物料/报价导出/销售改号 |
| `57a37e2749` | `18d7c6daaa` | **前置子集提取**：draft/handoff 架构 54 文件 |
| `60c6a5893b` | `94cae17e75` | 直接建单（handoff 后随 18d7c6daaa/e23dac094e 回补） |
| `b12cc66e71` | 随 `f2baa424ac` | **子集提取**：双单位基建 mixin |
| `a60f3e9039` | `f2baa424ac` | 行附件+阶梯价+调拨序列号（大混合子集） |
| `4a9d6d3e63` | `7a5ea23884` | 含税列表金额/付款计划/金蝶绑定（剔除 D 域面板） |
| `4ab6cf5ca3` | `c55585ce90` | 申请草稿审核态对齐 |
| `1d968cd27b` | `5c53534472` | 付款 pull_lines+入库行财务占用（kuaicaiwu 落位，80 文件） |
| `e520cafd37` | `201c69972d` | PO 含税价/price_type/行税率+结算拉单联动 |
| `db319377bb`（含 `729950ff9e` 字段子集） | `24862efbfd`+`b5e87e6248` | **display_unit_price 录入真源**（C1 前置链，刚落地） |

### ⚠️ 本次会话新发现：上游又 rebase 出一段平行链

`db319377bb` 所在窗口的旧哈希**不在当前 gitee/develop 链上**，patch 等价新哈希如下（已用 `git patch-id` 验证 `db319377bb`≡`b485a0a0e5`）：

| 旧链哈希（台账/本笔记引用用） | 新链哈希（gitee/develop 上） | 标题 |
| --- | --- | --- |
| `729950ff9e` | `53203ff84b` | 采购入库金额快照、红框打印与 Playwright（已取字段子集，红框打印等剩余未摘） |
| `a15174f8ca` | `31b1179a8e` | 单据明细金额失焦仅在实际改值时反算单价（`documentLineInclMatchesDerived` 调用点所在） |
| `075b086d3a` | `ebdc66ac4d` | 采购订单金额与 documentLineAmounts 契约对齐（**未摘**） |
| `0d38cc5a57` | `ad91f99f5e` | 采购订单头表汇总与前端行价税算法对齐（**未摘**） |
| `db319377bb` | `b485a0a0e5` | 单据价税按录入单价统一拆分（**已落地 `24862efbfd`，新链上应记 patch 等价跳过**） |

`4d124a088e` 哈希在新旧链上**相同**（在 gitee/develop 祖先链上，可直接用）。

处理手法（台账「远端与水位」节有完整命令）：

```bash
git fetch gitee develop --filter=blob:none
git cherry -v <旧链基> gitee/develop   # '-'=patch 等价跳过，'+'=新提交需评估
git show <old> | git patch-id ; git show <new> | git patch-id   # 逐对验证
```

### 下一笔：`4d124a088e`「单据行价税统一与采购入库含税算价」（~78 文件）

摘取要点（会话中已踩点）：

- `git cherry-pick -n 4d124a088e`，宿主 `apps.kuaizhizao.finance.*` → `apps.kuaicaiwu.*`，宿主测试移 `tests/apps/kuaicaiwu/`。
- 已确认本地自含基建就位：`document_line_amounts.py`（后端）、`documentLineAmounts.ts`/`purchaseOrderAmounts.ts`/`purchaseReceiptWarehouseAmounts.ts`/`materialDualQuantity.ts`（前端超集）、`price_precision.py`、`document_recognition.py`。
- kuaicaiwu `purchase_settlement` 已是上游超集，**别再整文件替换**——只合净增量（`compute_purchase_receipt_line_settlement_amounts`/`sync_*` 已在）。
- `PurchaseReceiptCreateModal` 继续保本地 props 形态（`open/onClose/onSuccess/receiptId/poCompose`），不取上游 `Record<string,never>` 独立页形态。
- 双单位录入组件 `DocumentLineDualQuantityFormCell`/`documentLineDualQuantityColumn` 应在本笔自带——全取（60c6a5893b 缓置项由此回补）。
- 待提取文件候选：`tests/apps/kuaizhizao/utils/test_document_amount_write.py`、`services/document_amount_write.py`（上次摘到一半时已确认属本笔域）。
- zh-CN/updateLog 只取本笔新增条目（HEAD 空 theirs 新增→取 theirs；HEAD 有→键去重合并）。
- 摘后：pytest（kuaicaiwu+价税焦点）、ast、leak scan、esbuild 改动文件、台账补记。

### 批C 剩余候选（边界清单未落盘，按新链日志+域标题圈定，摘前逐笔复核归属）

`b485a0a0e5`（已落地）与 `4d124a088e` 之间及之后的 C 域候选（上游序，旧→新）：

- `31b1179a8e` 失焦反算（接通 dormant `documentLineInclMatchesDerived`）
- `ebdc66ac4d`/`ad91f99f5e` PO 金额契约对齐两笔（display_unit_price 同簇前置，未摘）
- `c346cff13b` 采购入库价税与订单统一及采购链多项修复
- `0c014426a7` 入库撤回前回退应付审核状态（C3）
- `2e57ae600e` 采购发票取单预览（C3）
- `2a5b2caf14`/`6ba9b54cdc`/`c583dd0b25` 允许账户负余额三连（C3）
- `9de82e8d57` 解散群+采购结算价格+图纸（混合）
- `d32d1e031d` 税率1%归一化+入库金蝶脏辅助单位（C/D）
- `ec29267f5b` 打印表头+付款申请打印+出库批号（混合）
- `777aa1a468` 采购取单/企微审批卡/仓储推送/打印（混合大提交）
- `e16f2f2939` 会签返工部门链+采购变更收口（F/C）
- `6abba1dbd5` 服务采购全流程+申请转单占用修复
- `9ec209fab8` 采购订单同步预加载价税+详情未税单价
- `c588744e04` 生产入库外推改绑成品入库+统一税率%录入（C/D）
- `4a7f11604c` 采购入库金额写路径+物料快建开关+同步对比组件级
- `13ac1e63d9` 采购发票登记 DocumentRelation 软删误用（C3）
- `dbfcfe37a9` 销售订单列表+采购入库价税+供应商联系人（评估 tip）
- `37409d3b29` 客商地址与取价、列表与物料选择体验
- `870e5476bf` 销售订单列表作用域遮蔽
- `93b3cb5998` 工单页签表单+财务取单+委外发料（大混合；批A 台账记为遗留依赖）
- `1eb300325a` 审核中心预览/软删复活/手工建单自动提交/租户自愈/金蝶收敛（混合；批A 遗留依赖）

其余候选多属 D（金蝶/sync/kingdee/库位）、E（序列号/仓储）、F（审批/企微/kuaioa）、G（deploy/ops）域，按批次划分走。

### C3 财务簇（批C 尾段）

kuaicaiwu 适配 + 模型补建。台账缓置清单中的 C3 项：上游多出的 ORM 模块（`fund_transfer`/`payment_advance_record`/`payment_offset_prepayment_line`/`payment_pull_line`✅已建/`purchase_receipt_line_finance_occupancy`✅已建/`receipt_pull_line`）、`finance_settlement_source_query.py`（对账单立账特性，依赖 `outsource_order_receipt` 模型未落地→挂 93b3cb5998 域）、`finance_management_router`、`report_service` 财务占用富化、kuaicaiwu finance 页 3 处、payments 页 pull_lines 编辑 UI 挂载（后端已支持）、partner-statements 审核批处理器。

## 工作区与仓库状态

- 主仓：`C:\workspaces-all\llm-workspaces\startech-mes\kuaigeyun-mes`，分支 `develop`，**工作区干净**，不 push。
- HEAD：`9cff49ca1e`（台账）。业务最新 `24862efbfd`+`b5e87e6248`。
- stash@{0}（test 分支上）：「未测试的采购/销售/BOM/主数据修改（勿带入）」——**不要 pop**。

## 消解与落地约定（下个会话沿用）

- **kuaicaiwu 权威**：上游 `apps.kuaizhizao.finance.*` 导入一律改 `apps.kuaicaiwu.*`；宿主 `src/apps/kuaizhizao/finance/` 文件 `git rm` 不并存；门禁用 `apps.common.app_orm`（`finance_orm_ready`/`require_finance_orm`），不引 `optional_pro`。
- **超集整文件替换前先 `diff upstream local | grep '^>'` 查本地独有行**（先例：DetailDrawer 的 `prepaymentBackfillLabel` 回补）。
- **迁移命名**：`YYYYMMDDHHMMSS_name.py` 首段 14 位时间戳且大于目录已有最大值；上游 `NNN_` 序号一律重编号（本批已用：971-976、20261110163000/20261110170000、974_20261105140000）。
- **保本地**：spec-142 确认流（可见失败不自动撤回）、`line_snapshots`、BusinessConfigService 三值立账枚举（`on_receipt`/`on_purchase_invoice`/`manual`，`on_partner_statement` 不入本地）、payments 页不整页替换。
- **测试归位**：宿主测试→`tests/apps/kuaicaiwu/`；无 DB 环境的用例补 monkeypatch（先例：PurchaseOrder.get、lines_from_purchase_order_items、assert_pull_create_allowed）。
- **用户可见变更**：`platformUpdateLog.ts` 加条目 + 文案只进 `zh-CN.ts`；台账每笔记取/缓置/剔除与验证。

## 已知 dormant/未接线项

- `document_recognition.py`/`finance_recognition.py` 已提取但仅服务级使用；`on_partner_statement` 码 dormant（本地三值枚举 fallback，不会误存）。
- `_kuaizhizao_document_gate.py`（D 批库位域接线）。
- `documentLineInclMatchesDerived`（sales-orders 已导入未调用，调用点=`31b1179a8e`）。
- `resolveReceiptLineTaxPercent`（PurchaseReceiptCreateModal 已定义未调用，消费端属 4d124a088e）。
- `PurchaseReceiptDetail`/`SalesDeliveryCreateModal` 新页（dormant）、序列号 UI（E 批）、双单位 mixin 尚未挂模型。
- fast-deploy 三文件、payments 页 pull_lines 编辑 UI（C3）。

## 验证基线（上一笔 `24862efbfd` 通过值）

- kuaicaiwu 全量 pytest **174 过**；pull 焦点组 15 过；`purchaseOrderAmounts.test.ts` 3 过；ast 全过；`scan_host_finance_path_leaks` ok；esbuild 改动文件 0 错误。
- 前端全量 tsc 有 ~2867 处**存量**类型错误（非门禁；构建走 vite/esbuild）。判断新增错误时对照该基线或 HEAD~1。
- zh-CN 既有重复键告警存在（非本次引入，不处理）。
