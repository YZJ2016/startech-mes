# 交接文档 — 上游同步（批C 已收口：12 笔尾段落地 `30df681854`+台账 `27d250f5b4`；HEAD `27d250f5b4`）（2026-11-20 更新）

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

## 批C 进度 — ✅ 已收口（评估 tip `dbfcfe37a9` 段全部摘毕；上游 tip 已推进至 `f5f317e2f6`，超出段域归属待批D 开启时评估）

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
| `4d124a088e` | `28049fbd99` | 单据行价税统一与采购入库含税算价（全量含依赖移植） |
| `31b1179a8e`/`ebdc66ac4d`/`ad91f99f5e` | `32d5cb0b5b` | display_unit_price 失焦反算簇（净增量甄别） |
| `c346cff13b`（含 `d5f1a83261` 后端子集） | `d8b15c8e78` | 入库价税统一+多源开票全链移植 kuaicaiwu |
| `6abba1dbd5`（C 域子集） | `74aef8fb30` | **服务采购全流程+申请转单占用**：115 文件混合提交按域切分。已取 order_type 三类采购与存货类别校验、申请 order_type 字段与转 PO 传播/display 录入价、`待审核`/`待我审核`（`pending_my_approval` helper 移植）、转单 source/占用回填自愈、入库表头/行仓库可空+confirm/withdraw 服务采购跳过库存、push_mode draft/confirm 透传、前端 order_type 列+ORDER_TYPE 字典+Service 源过滤+草稿数字 heal（`documentFormDraftCache`）。剔除：金蝶 5 service/inbound_sync/alignment、打印模板、出库域 10+ 文件、审批设计器、uni-* 零散、quotation/demand 杂项。迁移 `2026111810{0,1,2,3}0000`。台账第 49 行有完整清单 |
| `e16f2f2939`（C 域子集） | `8d5db2825d` | 采购变更 `withdraw_apply` 反应用+endpoint+明细回滚安全门+补偿日志+到货延迟状态复位；申请转单占用改按行 source 聚合（草稿计入/删除排除）；`pullOpenLine.ts` 共享可选行判定；非赠品单价>0 双端校验 |
| `777aa1a468`/`9de82e8d57`（C 域子集） | `185c50587d` | 申请 pullable_only 查询级过滤+`can_push`/剩余量/状态三门禁+前端 `isPullRequisitionOpenLineSelectable`；采购结算价格展示含 `pay_on_invoice`；顺手修 e16 埋的 `@staticmethod` 吞装饰器 bug（`_apply_purchase_item_price_settlement` 改实例方法） |
| `d32d1e031d`（C 域子集） | `97ec0acf20` | 税率归一化 `(0,1)`×100、`>=1` 已是百分数——1% 不再抬成 100%；后端 kuaicaiwu `normalize_po_tax_rate_to_percent`+前端 `purchaseOrderTaxRateToPercent` 同契约+双端回归测试 |
| `ec29267f5b`（C 域子集） | `555b237519` | 付款申请来源订单只读聚合 `purchase_order_sources`+发票情况三值校验（有发票/无发票/发票后补）+PO 审批中间节点不写 reviewer_*+`settlement_terms_label_zh` 码表 |
| `1eb300325a`（C 域子集·选项C） | `c9edcdc2cd` | 手工建单自动提交**引擎+采购域 hooks**：`manual_create_auto_lifecycle`（全局/单证开关、只调既有 submit、skip 供下推）+business_config 23 单据扁平键注册+6 个采购 hooks（PO/申请/询价/收货通知/入库/付款申请）；入库下推与导入传 `skip_manual_create_auto_submit=True`；引擎 logger `{}`→`%s` 修正。**缓置 F/D**：配置 UI、非采购域 hooks（registry 惰性解析，未接线仅 warning）、审核中心预览/软删复活、租户自愈、金蝶收敛 |
| `899307f4d6`（财务子集） | `bb7c42215c` | 财务页确认/撤销确认能力键+payments 功能键区+复制建单；审核链 hunk → F 批 |
| `93b3cb5998`（财务子集） | `bb7c42215c` | **对账立账链全链**：`ReceiptPullLine`/`OutsourceOrderReceipt` 模型+迁移 `2026111811{2,3,4}0000`；7 单据立账识别列+create 路径 populate；`document_recognition` +5 helper；partner_statement `ledger_posting_mode` immediate/by_invoice+`post_ledger`+推单候选端点；receipts pull_lines 全链；sales_invoices 自动应收移至 approve+partner-statements 取单；前端 receipts/sales-invoices/purchase-invoices 页重构+5 共享件。工单页签/委外发料/审核链 → E/F 批 |
| `5b1b9828e4`（财务子集） | `bb7c42215c` | 预收取单专用候选接口+对账单行 doc_key；**回滚 PO 比例分摊法**：入库行金额唯一走 `calc_document_line_amounts`（含税 qty×display_unit_price）+`sync_purchase_receipt_header_amounts` 五站点接线。出库序列号 UI → E 批 |
| —（C3 缓置回补） | `9a4e496130` | payables 入库行勾选立账（`pull_receipt_lines`）、payments 多源取单数组化、`report_service` `finance_occ` 占用列；`finance_management_router` 核实已完整 |
| —（复审补摘 4 代理） | `34a28405b8` | 修 bb7c 漏项：delivery/return `revenue_recognition` 落库断链、`_normalize_source_ids` 漏摘（多应收预览 500）、收款 `source_ids` 多源建链、入库行 `display_unit_price`/`tax_amount`/`net_amount` 回写、`_order_prepayment_linked_by_ids` 按 5b1b 改写、schemas 3 识别字段 |

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

### 批C 剩余候选（边界清单未落盘，按新链日志+域标题圈定，摘前逐笔复核归属）

`b485a0a0e5`（已落地）与 `4d124a088e` 之间及之后的 C 域候选（上游序，旧→新）：

- ~~`31b1179a8e` 失焦反算~~ ✅ `32d5cb0b5b`
- ~~`ebdc66ac4d`/`ad91f99f5e` PO 金额契约对齐两笔~~ ✅ `32d5cb0b5b`
- ~~`c346cff13b` 采购入库价税与订单统一及采购链多项修复~~ ✅ `d8b15c8e78`
- ~~`0c014426a7` 入库撤回前回退应付审核状态（C3）~~ ✅ `f417498947`
- ~~`2e57ae600e` 采购发票取单预览（C3）~~ ✅ `f417498947`
- ~~`2a5b2caf14`/`6ba9b54cdc`/`c583dd0b25` 允许账户负余额三连（C3）~~ ✅ `f417498947`
- ~~`9de82e8d57` 解散群+采购结算价格+图纸（混合）~~ ✅ C 域子集 `185c50587d`（其余剔除留域批次）
- ~~`d32d1e031d` 税率1%归一化+入库金蝶脏辅助单位（C/D）~~ ✅ `97ec0acf20`
- ~~`ec29267f5b` 打印表头+付款申请打印+出库批号（混合）~~ ✅ C 域子集 `555b237519`
- ~~`777aa1a468` 采购取单/企微审批卡/仓储推送/打印（混合大提交）~~ ✅ C 域子集随 `185c50587d`
- ~~`e16f2f2939` 会签返工部门链+采购变更收口（F/C）~~ ✅ C 域子集 `8d5db2825d`
- ~~`1eb300325a` 手工建单自动提交等混合~~ ✅ 引擎+采购 hooks `c9edcdc2cd`（其余缓置 F/D）
- ~~`6abba1dbd5` 服务采购全流程+申请转单占用修复~~ ✅ 已落地 `74aef8fb30`（C 域子集，见台账）
- ~~`9ec209fab8` 采购订单同步预加载价税+详情未税单价~~ ✅ `30df681854`
- ~~`c588744e04` 生产入库外推改绑成品入库+统一税率%录入（C/D）~~ ✅ C 子集 `30df681854`（kingdee 两件 → D）
- ~~`4a7f11604c` 采购入库金额写路径+物料快建开关+同步对比组件级~~ ✅ C 子集 `30df681854`（核对账 sync-push-hub 三页缓置）
- ~~`13ac1e63d9` 采购发票登记 DocumentRelation 软删误用（C3）~~ ✅ `f417498947`
- ~~`dbfcfe37a9` 销售订单列表+采购入库价税+供应商联系人（评估 tip）~~ ✅ C 子集 `30df681854`
- ~~`37409d3b29` 客商地址与取价、列表与物料选择体验~~ ✅ `30df681854`（equipment/审核视图字段式/打印预设/other_expense_application 缓置域批）
- ~~`870e5476bf` 销售订单列表作用域遮蔽~~ ✅ `8cfac15f4e`
- ~~`93b3cb5998` 工单页签表单+财务取单+委外发料（大混合；批A 台账记为遗留依赖）~~ ✅ 财务子集 `bb7c42215c`+`34a28405b8`；工单页签/委外发料/审核链 → E/F 批
其余候选多属 D（金蝶/sync/kingdee/库位）、E（序列号/仓储）、F（审批/企微/kuaioa）、G（deploy/ops）域，按批次划分走。

### C3 财务簇（批C 尾段）— ✅ 已收口（`bb7c42215c`+`9a4e496130`+`34a28405b8`，台账 `84a978dad1`/`1ba7314faf`/`10c7a01ec5`）

全部落地：`receipt_pull_line`/`payment_pull_line`/`purchase_receipt_line_finance_occupancy`/`outsource_order_receipt` ORM 模块；`finance_settlement_source_query.py`（对账单立账）；`finance_management_router`（核实本地 `kuaicaiwu/api/router.py` 已含上游 19 路由超集）；`report_service` `finance_occ` 占用富化；kuaicaiwu finance 页 3 处（payables 行勾选立账 `pull_receipt_lines`、purchase-invoices 对账单取单、dashboard 上游 N/A）；payments 页 pull_lines 数组化+编辑 UI（`PaymentVoucherFormBody` 已挂载）；4 代理复审补摘 bb7c 漏项（识别链落库、多源收款拉取、display 单价回写等）。
**遗留缓置（不属批C 关闭条件）**：partner-statements 审核批处理器+detail 销售发票推单（F 批审核链 + `b12cc66e71` 余量前置）；93b3 Outsource 立账调用方接线（E 批）；`purchaseOrderAmounts` 显示价语义/`purchase_requisition_service` 推 PO 定价 hunk（邻提交 `a35304ad40` 等域，台账已记）；批C 收尾新增缓置——52b1 浮动辅单位台账、37409 打印价税富化预设体系/审核视图字段式重构/other_expense_application（D）、4a7f 核对账 sync-push-hub 三页（D）、equipment_ops+spot-checks（E）、`report_service._finalize_inventory_api_rows` 前置链、9ec 关联的 api_service/kingdee 预置（D）。注：`scan_purchase_amount_contract.py` 已随 dbfcfe37a9 落地（`30df681854`）。

## 工作区与仓库状态

- 主仓：`C:\workspaces-all\llm-workspaces\startech-mes\kuaigeyun-mes`，分支 `develop`，**工作区干净**，不 push。
- HEAD：`27d250f5b4`（批C 收尾台账）。批C 尾段：`30df681854`（12 笔 C 域候选全摘：7e553638e1/ce86f28932/c09c7d188b/05fb1f835e/c83c6d5589/52b1abf2e3/88b0c140f1/37409d3b29/9ec209fab8/c588744e04/4a7f11604c/dbfcfe37a9）。批C3 已收口：`bb7c42215c`+`9a4e496130`+`34a28405b8`。上游 tip `f5f317e2f6`（以 `git log gitee/develop` 实测为准）。
- `3958bb1524` 复核补摘（`2e80763b9c`）：入库行未税 `resolve_purchase_receipt_line_excl_amount`（建单/更新两路径）、入库确认立应付金额切 `purchase_receipt_settlement_gross_async`、入库列表批量 `settlement_gross`、`write_path_policy` 加 `repair-settlement` 关键路径。
- stash@{0}（test 分支上）：「未测试的采购/销售/BOM/主数据修改（勿带入）」——**不要 pop**。

## 消解与落地约定（下个会话沿用）

- **kuaicaiwu 权威**：上游 `apps.kuaizhizao.finance.*` 导入一律改 `apps.kuaicaiwu.*`；宿主 `src/apps/kuaizhizao/finance/` 文件 `git rm` 不并存；门禁用 `apps.common.app_orm`（`finance_orm_ready`/`require_finance_orm`），不引 `optional_pro`。
- **超集整文件替换前先 `diff upstream local | grep '^>'` 查本地独有行**（先例：DetailDrawer 的 `prepaymentBackfillLabel` 回补）。
- **迁移命名**：`YYYYMMDDHHMMSS_name.py` 首段 14 位时间戳且大于目录已有最大值；上游 `NNN_` 序号一律重编号（本批已用：971-976、20261110163000/20261110170000、974_20261105140000）。
- **保本地**：spec-142 确认流（可见失败不自动撤回）、`line_snapshots`、BusinessConfigService 三值立账枚举（`on_receipt`/`on_purchase_invoice`/`manual`，`on_partner_statement` 不入本地）、payments 页不整页替换。
- **测试归位**：宿主测试→`tests/apps/kuaicaiwu/`；无 DB 环境的用例补 monkeypatch（先例：PurchaseOrder.get、lines_from_purchase_order_items、assert_pull_create_allowed）。
- **用户可见变更**：`platformUpdateLog.ts` 加条目 + 文案只进 `zh-CN.ts`；台账每笔记取/缓置/剔除与验证。

## 本轮全量业务复核结论（`27210d5dc5` 落地，台账 `374512a9be` 补记）

批 C 全部已摘提交做完业务级复核（非仅语法）：架构边界/tenant/门禁/价税数量/回滚安全/软删/前后端契约/台账一致性。发现并修复两处确定缺陷：

1. `purchase_order_change_service.py` 4 处 `apps.kuaizhizao.finance.*` import（e16 摘取带入）——宿主 finance 目录本地不存在，运行至变更单价写回/头表金额同步/行税率归一化即 `ImportError`；已改导 `apps.kuaicaiwu.services.{finance_tax,purchase_settlement}`。
2. `SalesOrderChangeCapabilities` 误加 `withdraw_apply` 必填字段（上游仅加 `PurchaseOrderChangeCapabilities`）——销售变更能力推导 pydantic ValidationError→500；按上游边界移除。

**残留注意项**（非缺陷，新会话知悉即可）：

- unapply 重建取消行不回写 `source_type`/`source_id`——若原行是申请来源行，重建后不再挂申请链（上游逐字同款的限制；补链属刻意偏离，未做）。
- 非采购域 manual_create hooks 惰性解析：缺 submit 方法的节点开启只记 warning，F 批接线自然激活。
- tracked dist 产物曾大面积被构建删除遗留，已 `git checkout` 恢复；构建注意 `--max-old-space-size` 需传子进程。

## 批C 整体终审（`d78dffeaed..origin/develop`，4 路并行审查，本轮修复见下）

C3 开启前对批C 累计范围做终审：两路摘取完整性 + 功能回归 + 逻辑漏洞。

**完整性**：全部声明「已取」项在库可调用，无静默遗漏。台账 `c346cff13b` 行 4 端点名曾误记（非真实上游符号），已更正为真实端点 `get_purchase_receipt_return_preview`/`list_purchase_return_purchase_receipt_pull_lines`/`pull_purchase_return_from_purchase_receipt`/`pull_purchase_returns_from_purchase_receipt_items`。

**修复**：

1. **收货通知单审核半接线（必 400）**：前端批提交/审核菜单、保存后 `commit`、`showCommitSubmit` 按 shipment_notice 模式接线，但本地 `receipt_notice` 未注册为审核实体（manifest.audit 无条目、`_DISPATCH` 无键、capabilities 不含 submit/approve）→ 保存即报「实体未声明」。按既有缓置决策撤线前端审核路径，恢复基线 notify/withdraw 生命周期；uni-audit 服务方法与 manifest 权限码 dormant 待 F 批 `d81b4b70bf` 送审链。
2. **`manual_create_auto_lifecycle` 幻影节点**：`receipt_notice`/`purchase_receipt`/`other_expense_application` 指向不存在的提交器（异常被吞成死开关）已从 DOCS+registry 移除；`other_income`/`other_expense` 解析路径改指 `apps.kuaicaiwu.*`（拆分后未同步）。注册测试补「全 DOCS↔registry 覆盖」断言。
3. **付款申请**：`application_date` 默认改 `to_site_date(resolve_business_datetime())`（原 `date.today()` 服务器本地日，跨时区零点错一天）；两处 `Payable.get` 补租户+软删纵深过滤。
4. **清理**：`_agent_debug_ndjson` 调试残留、`resolveReceiptLineTaxPercent` 死函数、`test_unknown_node_key_not_enabled` 的 `get_event_loop()` 隔离缺陷（→`@pytest.mark.asyncio`）均已修。

**确认无问题**：uni-pull/batch/audit-hub 休眠件不误触；`pay_mode` 去必填系上游刻意对齐（台账已记）；`/unapply` 用 module_access 与文件内其余端点一致（低优先跟进项）。

## 已知 dormant/未接线项

- `document_recognition.py`/`finance_recognition.py` 已提取并全链接线（93b3 批次：delivery/return 识别落库+create 路径 populate+gate 调用已接）；`on_partner_statement` 码已激活（business_config_service 枚举+对账单立账链落地）。
- `_kuaizhizao_document_gate.py`（D 批库位域接线）。
- `documentLineInclMatchesDerived`/`documentLineExclMatchesDerived` 已接线（`32d5cb0b5b` 失焦反算守卫）。
- `PurchaseReceiptDetail`/`SalesDeliveryCreateModal` 新页（dormant）、序列号 UI（E 批）、双单位 mixin 尚未挂模型。
- fast-deploy 三文件（G 批复核域）。payments 页 pull_lines 编辑 UI ✅ 已接（`9a4e496130`）。
- `manual_create_auto_lifecycle` 引擎已落地（`c9edcdc2cd`+复核修正 `87454681ce`+本轮注册表清理）：已接线 PO/申请/询价/付款申请 4 个采购 hooks，下推建单 7 处调用点全部传 `skip_manual_create_auto_submit=True`；幻影节点 `receipt_notice`/`purchase_receipt`/`other_expense_application` 已移除（属 `d81b4b70bf` 送审链 F 域，移植 `submit_*`/`commit_*`/`_enter_*_review`/`approve_*` 链时重新接线）；`other_income`/`other_expense` 解析指 `apps.kuaicaiwu.*`；其余非采购域 hooks 与配置中心 UI 同属 F 批。
- 收货通知单 uni-audit 前端服务方法（commit/submitForReview/withdrawSubmit/approve/revokeApproval）与 manifest 审核权限码 dormant：本地 `receipt_notice` 非注册审核实体，F 批补齐 manifest.audit+_DISPATCH+capabilities 后再接线。

## 验证基线（批C 收尾簇 `30df681854` 后）

- 后端全量 pytest **3843 passed / 0 failed / 18 skipped**（批C 终审基线）；批C 收尾新增：PO 同步/业务配置 8 过、仓储/采购 60 过；`scan_timezone_contract`/`scan_document_action_bypass`/`scan_route_manifest_alignment` 均 0 发现；esbuild 改动文件通过。
- kuaicaiwu 全量 pytest **185 过**；kuaizhizao `document_recognition_gates`/purchase_settlement/pull_line_gross/statement_doc_key 焦点组 26 过；`purchaseOrderAmounts.test.ts` **10 过**；`scan_host_finance_path_leaks`/`scan_purchase_amount_contract`/`scan_unitable_row_cache` ok；antd6 全量扫描 2805 文件 0 命中；timezone 契约 0 违规。
- 前端全量 tsc 有 ~2722-2867 处**存量**类型错误（非门禁；构建走 vite/esbuild）。本批触碰文件新增错误 0（已用 stash 基线对照验证；SupplierLike unknown 3 处已窄化修复）。
- `platformUpdateLog.ts` 重复块 37 条已清除、zh-CN 3 重复键已去重；`common.hint` 键本地与上游同缺（`showPullFlowNotice` fallback，上游既有缺口）。

## 附录：全量批次清单（334 笔未评上游提交，按域圈定）

> 生成方式：`git log --oneline --no-merges 29b785f655..gitee/develop`（334 笔）→ 按域关键词自动圈定 + 人工复核修正。**边界是工作底稿不是裁决**：混合提交（一个 commit 跨域）归到了主域，摘取时每笔仍要重新评域、看是否有跨批依赖需提前摘子集。已落地/已评跳过/patch 等价的 52 笔列在末尾不占额度。
> 另有 **70 个 merge 提交**不在下表（`git log --merges` 查），批G 收尾时按净增量 diff 复核。
> `git cherry -v develop gitee/develop`：23 笔 `-`（patch 等价已落地）；`+` 笔中除本清单已标 ✅ 的摘取/适配外即为待办。
> 注：上游 tip 已越过评估边界 `dbfcfe37a9` 前进至 `f5f317e2f6`（+~17 笔，域归属待评估）。

### 批C 剩余（价税/采购/销售） — ✅ 全部落地（`30df681854` 收尾簇）
- ~~`7e553638e1` fix: 发货通知明细误用 deleted_at 过滤；侧栏图标恢复同尺寸形变~~ ✅ `30df681854`（补 MenuMorphIcon.less 漏件+2 条 updateLog；后端本地历史已修）
- ~~`ce86f28932` feat(sales): 销售订单与集成适配~~ ✅ C 子集 `30df681854`（`_tenant_base_currency` 租户本币；api/kingdee 预置 → D）
- ~~`c09c7d188b` fix: 采购订单类型只留两项，审核记录按连线排序~~ ✅ `30df681854`（随带 c0a917fc45 ORDER_TYPE 预置项改写）
- ~~`05fb1f835e` fix(db,migration): 核心API主键唯一与master_partners主键/序列修正~~ ✅ `30df681854`（迁移 `20261119000000`/`010000` 本地时间戳）
- ~~`c83c6d5589` fix(kuaizhizao): 采购入库取单支持采购订单仅回显权限~~ ✅ `30df681854`
- ~~`52b1abf2e3` fix(kuaizhizao): 采购详情含税单价与浮动辅单位台账~~ ✅ C 子集 `30df681854`（前端已超前；浮动辅单位台账整体缓置）
- ~~`31b1179a8e` fix(kuaizhizao): 单据明细金额失焦仅在实际改值时反算单价~~ ✅ `32d5cb0b5b`
- ~~`ebdc66ac4d` fix(kuaizhizao): 采购订单金额与 documentLineAmounts 契约对齐~~ ✅ `32d5cb0b5b`
- ~~`ad91f99f5e` fix(kuaizhizao): 采购订单头表汇总与前端行价税算法对齐~~ ✅ `32d5cb0b5b`
- ~~`6abba1dbd5` feat(kuaizhizao): 服务采购全流程与申请转单占用修复~~ ✅ `74aef8fb30`（C 域子集，金蝶/打印/出库域剔除）
- ~~`88b0c140f1` feat(config,ui): 下推默认模式改草稿、客户选择快照回显与kuaiplm联动日志~~ ✅ C 子集 `30df681854`（kuaiplm 日志测试 → PLM 域）
- ~~`c346cff13b` fix(kuaizhizao): 采购入库价税与订单统一及采购链多项修复~~ ✅ `d8b15c8e78`（含 `d5f1a83261` 后端子集）
- ~~`4d124a088e` feat(kuaizhizao): 单据行价税统一与采购入库含税算价~~ ✅ `28049fbd99`
- ~~`37409d3b29` feat: 客商地址与取价、列表与物料选择体验~~ ✅ `30df681854`（105 文件主体；equipment/审核视图字段式/打印价税预设/other_expense_application → 域批缓置）
- ~~`9ec209fab8` fix(kuaiconnect,purchase): 采购订单同步预加载价税与详情未税单价~~ ✅ `30df681854`（同步服务整件移植适配本地排程助手+`kuaicaiwu` 结算导入）
- ~~`dbfcfe37a9` fix(kuaizhizao): 销售订单列表、采购入库价税与供应商联系人~~ ✅ C 子集 `30df681854`（供应商联系人全链+amount 契约扫描门禁；sales-orders deleted_at 块随 DocumentRelation 特性缓置）

### 批C3 财务适配簇（kuaicaiwu 落位） — 31 笔（✅ 全部已决：`899307f4d6`/`93b3cb5998`/`5b1b9828e4` 财务子集随 `bb7c42215c` 落地）

已落地映射（详见台账）：`f417498947`（小修簇：13ac1e63d9+a2473e9b42子集+d11f9ce75f子集+2e57ae600e+0c014426a7+负余额三连 2a5b2caf14/6ba9b54cdc/c583dd0b25+e75380e080 垫付）、`94e6e07f42`（63395aa98e infra：嵌套事务/schedule_after_commit/序号独立连接）、`b1fa1fc305`（1efec0da1d+748c+a8b0 资金调拨）、`00356fdff0`（fa5ce815bc patch等价+updateLog）、`8192e92072`（beef6118ba+189ec25e22 其他费用/付款链路）、`96174f05dd`（95c4869063+63395 pull offset hunks 预付抵扣）、`d3fd8abb44`（154977d948+6fb3e77b05 回写/徽章/合并取单）、`2b2403ef5d`（3958bb1524 核销门控/补核销/价税取数/入库取单跳转）。跳过/已决：432bd5f7fd（app_orm 适配）、2c76a942c2（宿主包不取，仅摘申请撤销+字段修复）、015d84a9eb（本地天然正确）、31efc2b64c（scan_host_finance_path_leaks.py）、406a8f8797（patch 等价）、d5f1a83261（多源开票后端随 d8b15c8e78）。

- ~~`899307f4d6` feat(audit,warehouse,finance): 直接提交审核、批号分摊与入库付款修复~~ ✅ 财务子集 `bb7c42215c`（审核链 → F 批）
- ~~`93b3cb5998` feat(kuaizhizao): 工单页签表单、财务取单与委外发料等业务合入~~ ✅ 财务子集 `bb7c42215c`（工单页签/委外发料 → E 批，审核链 → F 批）
- ~~`5b1b9828e4` fix(kuaizhizao): 出库序列号、预收取单、对账单立账与工单审核等~~ ✅ 财务子集 `bb7c42215c`（序列号 → E 批）
- `9de82e8d57` —— 采购结算价格 C 子集已摘 `185c50587d`，im/drawings 余量待批
- `ec29267f5b` —— 付款申请聚合/发票校验 C 子集已摘 `555b237519`，打印/出库余量待批

### 批D1/D2 数据互通（金蝶/同步/库位） — 76 笔
- `2c945a39fb` feat: 苍穹采购入库出站、仓库 getList 同步与设备/字段权限等联调改动
- `2e8ecad990` feat: 苍穹销售出库/其他出库/盘盈盘亏出站与企微同步推送
- `4bd853a94f` feat(inbound): 采购入库金蝶外推字段、空白建单与采购中心超时修复
- `d7966d33c6` fix: 采购入库外推门禁与苍穹仓库列表预览
- `d7da8e14f8` fix: 苍穹组织取连接器、物料单位禁全表扫、加速 dist 发布
- `905787348a` feat: 质检国标抽检、仓库同步记录与数据互通运行历史
- `a0b353ce7e` feat(warehouse): 其他入出库金蝶外推与同步运行历史对齐采购入库
- `994bc9a312` fix(sync): 修复苍穹物料同步 request_body 为 None 时合并崩溃
- `5d65aa9fa4` feat(master-data): 客户伙伴类型/业务职能与供需同步字段
- `37e5213a50` fix: 苍穹 getcustomer 测试漏导入；客户同步按组织过滤
- `a0ccb13d08` feat: 仓储金蝶成品/领料外推、其他费用申请与采购部门字段
- `ef05d62736` fix(master-data): 有仓库读权限即可拉库位/库区下拉
- `48b0341563` fix: 仓位 getList 保留空 data，并登记工程图纸菜单图标
- `520cde9e49` feat: 库位金蝶同步、批次库存状态列与仓位外推对齐
- `9f50375a01` fix(master-data): 补全物料多单位同步入口到物料管理页
- `0550761f59` improve(warehouse): 采购入库 uni-wh 明细与库位批号 UX
- `7d1f000361` fix(kuaizhizao): 发货通知仓库下推出库单时 defer 库位校验
- `2e90d9a7ae` fix(kuaizhizao): 工序委外流程、仓储库位与 IQC 自动下推
- `fc12d17278` fix(sync): 苍穹增量把 modifytime 水位打进源端，避免全量翻页拖死
- `3021870683` fix(sync): 仓储推送金蝶从接口样例正确读取 data 单据头
- `282f15a0fd` fix(kuaizhizao): 采购入库外推仓位、批号同步与编辑表单
- `3f8d606f7c` fix(sync): 加载采购入库预设时保留已填编码
- `43f1fef415` fix: 收付款草稿随核销下调，并修正审核撤回与菜单同步提醒
- `7a4f8e4230` improve(qms): 体系文件导航与内审能力，放宽菜单同步提示
- `6c83770a65` feat(sync): 销售订单 push-binding 与销售出库确认外推
- `633a054eee` fix(kingdee): 仓储外推从采购入库继承库存状态与领用人字段
- `15c4dc1de5` fix: 金蝶外推审核、费用申请引用加载与协作分类扩展
- `75046d4f03` improve(kingdee): 其他入库外推组包对齐开放平台与其他出库
- `bdcd5fa735` fix(kingdee): 其他入库无库管组不写库管员，outinv 仅显式配置
- `3ba3d049c0` fix(kingdee): 其他出库/生产领料外推补全领用人写键
- `607939c9a7` fix: 其他入库出站绑定路由顺序导致外推校验失败
- `58e6ab9e4d` fix: 金蝶其他入库明细补齐 outinv 库存类型状态
- `093512788c` feat(kuaiconnect): 金蝶云星空物料同步支持组织范围与分组适配
- `11632b238b` feat: 金蝶仓储外推链路增强与物料组织范围展示
- `7fa73e053a` feat(integration): 金蝶星空/银河物料同步与集成适配
- `e817c50d24` feat(integration): 金蝶银河物料同步适配与部署脚本调整
- `fdcfdd500b` feat(integration): 金蝶银河物料分组与集成配置优化
- `22e0787317` feat: 仓储出入库 Hub、金蝶成品入库外推与接口库契约
- `91c8157e1e` feat: 采购入库外推支持强制重推、是否推送开关与详情状态
- `05d001dd6d` feat: 仓储双计量与金蝶外推补审、部门批量启停与组织同步
- `b164bfd1db` feat(kuaiconnect): 销售订单同步与界面优化
- `431de9ea9c` feat(kuaiconnect): 组织范围与界面优化
- `2485a66bcb` feat(kuaiconnect): 入站同步与界面优化
- `32cf90c8a2` feat(integration): 金蝶物料同步与出库逻辑优化
- `86e3d8187c` feat(kuaiconnect): 出库同步与界面优化
- `e9726667b1` feat(kuaiconnect): 出库同步优化
- `050638b809` feat(kuaiconnect): 销售出库同步与界面优化
- `7ebfacd75e` feat: kuaiconnect 金蝶单据推送与集成适配
- `69fbb7cb35` fix(sync,ui): 物料同步空源提示与物料管理/超时中间件修正
- `df7d635797` feat(sync,ui): 同步绑定引用整合与前端同步/物料/BOM等页面优化
- `7dad32983e` fix(kuaiconnect): 苍穹出入库接口库补齐提交审核与盘点操作套
- `42fb8fe9f4` fix(warehouse,gl,kuaiconnect): 出库权限与出库人、退料行仓、科目余额期初轧差
- `d8afe91cad` fix(web): 出库 Hub、BOM 弹窗与销售直推工单等多项修复
- `fd18de759f` fix(document-push): 出库外推绑定行为显示确认出库
- `ff71edee8d` fix(warehouse,kingdee): 去掉无软删除明细的 deleted_at 过滤，出库推单走目录单位双数量
- `361337a31a` fix(approval,warehouse,document-push): 组织审批锚定制单人，同步记录与库位库存体验
- `f40f54e336` fix(kuaizhizao): 头表价税与明细对齐，同步绑定调度窗
- `e1340cf6a8` fix(kuaizhizao): 即时库存单计量按行留空副单位列
- `6b233ed3f6` fix(kuaizhizao): 红框采购入库 HTML 模板补库位列
- `44490cf018` fix(kuaizhizao): 红框入库单列序为金额在库位前且数量两位
- `1e00eb3ad7` fix(kuaiconnect,web): 金蝶仓存补提交审核与取单勾选收口
- `e896023052` fix(kuaiconnect): 金蝶出库预检与即时库存按仓位对齐
- `7091b700be` fix(kuaizhizao): 其他出库编辑用完整表单并补强金蝶一致能力
- `2b1ffa48ae` fix(kuaizhizao): 仓储编辑金蝶 batchUpdate 全接入并修其他出库列表 TDZ
- `76b62bf6ec` fix(warehouse): 即时库存同步累加、仓位关系仓库分批与出库编辑
- `e34110de2d` fix(kuaiconnect): 出库金蝶可用预检按库位名称匹配
- `f9465b63cb` fix: 金蝶外推单号组织前缀、同步暂停与采购入库打印换行
- `d32d1e031d` fix: 税率1%归一化与采购入库金蝶脏辅助单位 —— **税率归一化 C 子集已摘 `97ec0acf20`，金蝶脏辅助单位 D 域余量待批**
- `41c3a02f72` feat(inbound): 入库确认库位自动带入、收货人默认与明细库位编辑
- `fa9fa79b42` fix(sync): 物料全量同步不再对未命中行停用/软删
- `73b89087b0` fix(sync): 补齐同步服务对 schedule window 解析函数的 import
- `c588744e04` fix(kuaizhizao): 生产入库外推改绑成品入库并统一税率%录入
- `959f65b743` feat(sync): 数据互通同步对比，并修其他出库数量与物料1%税率
- `4a7f11604c` fix(kuaizhizao): 采购入库金额写路径与物料快建开关、同步对比组件级
- `80da6a45f8` fix(sync): 金蝶外推单据号统一走 resolve_kingdee_local_bill_no
- `4ba2d15ae8` feat(sync): 入站同步仅映射字段更新契约、金蝶供应商启用过滤与查询修正

### 批E 仓储/MES 核心 — 42 笔
- `a98e70dee3` feat(kuaizhizao): BOM外领料、调拨批号入库日与 MRP 下推修复
- `d15b47984a` feat: 过程检验方案快速新建与执行回填，修需求计算预校验失败态
- `1f239033e9` feat: 需求草稿级联撤回与重算、委外检验/巡检编码规则、销售订单列表导入拆分
- `759be91800` feat: 需求草稿级联撤回与重算、委外检验/巡检编码规则、销售订单列表导入拆分
- `f7c52a4dc0` fix: 收货通知自动通知仓库、计算完成下推工单与委外结束时间
- `9d94441ae0` fix: 质量检验拆分服务、单据 API 门禁与质检中心联调硬化
- `5db37fe829` feat: 登录默认组织、下推转到与确认出库换仓刷新库存
- `a7e644b2ba` feat: 发货通知库存提示明细与侧栏菜单 Morphicons 悬停形变
- `84bccf2711` fix(master-data): 补齐物料多单位同步弹窗与更新日志文案
- `46fd028b5e` fix(master-data): 补齐物料服务多单位相关类型导入
- `1e33dd2861` feat: improve material and process management
- `895ace488c` fix(kuaizhizao): OQC 取单补全 quality_inspection_helpers 引用
- `1531ccc53e` feat(kuaizhizao): 呆滞物料统计支持库龄天数分段筛选
- `a54feb82c1` feat(kuaizhizao): 序列号投产/拆单与工单列表 SN 展示
- `f2e06e453e` fix(kuaizhizao): 质检方案编码字段与检验计划列表联动
- `eda3c9f86a` feat(warehouse): 销售出库列表支持规格型号与日期筛选
- `f129439b56` feat(mes): 返工指派执行、倒冲幂等与 MRP 精度对齐
- `0da09e1bc4` feat(equipment): 设备故障/维修协作参与者与返修报工
- `2c67aabdda` feat(work-order): 过报规则、分批中心与报工数量增强
- `30955e5e57` feat(work-order): 工单创建与报工数量调整
- `8fbbedc569` fix: 销售出库确认批号与客商取价顺序保存
- `01ef0734c2` fix: 其他入库确认预览补录批号与序列号
- `8af3ae4f6e` fix: 其他入库确认预览不再反复请求导致卡死
- `ab3a537da9` fix: 其他入库确认预览始终展示批号录入
- `e34fdf1f5e` feat: 其他入库原因类型增加生产完工入库
- `8071010916` feat(inventory): 库存台账支持库存单位与基本单位双计量
- `c0a917fc45` feat: 采购入库出站映射与单位目录推送
- `6c4351b42c` feat: 仓储出库、API文档与集成配置优化
- `11e8cb33be` feat(warehouse): 出库确认与工序跳转优化
- `63c2a77fc1` fix(warehouse): 成品/半成品入库单补齐 PUT 编辑
- `511df029e4` feat(ui): 树表格与仓储界面优化
- `56a77a0ff9` fix(outbound,audit): 出库复合行键可提交；未走分支标未触发
- `6900eeea94` feat(material): 物料批量启用/停用与isActive字段适配
- `9622a5a304` fix(production,cf): 工单成品入库默认值与自定义字段数值健壮性，装箱明细审计列补全
- `59a0186016` fix: 发货通知免审通知仓库与出库明细 Popover
- `b62c61c485` fix(process): 工艺路线更新接口支持snake_case字段，修复允许工序跳转不保存
- `469d220121` feat(quality): 工单成品检验支持按剩余量分批加载
- `8c6303355a` fix(kuaizhizao): 单计量库存三量对齐并隐藏副单位列
- `9eb17b1d9e` feat(kuaizhizao): 其他出库单增加领用日期
- `0a13af1635` fix(master-data,quality): 物料质检分场景保存与方案步骤弹窗层级
- `9c9f0d99bf` fix(kuaizhizao): 其他入库序列号、销售出库与取单开口行
- `a7bd984609` fix(frontend): documentDetailSerialNumberColumn 物料服务导入路径

### 批F 审批/企微/haoligo/OA/杂项 — 48 笔
- `543735cb03` fix(approval): 条件分支后撤回本级不再断开流程
- `aea17a2124` feat: 审批企微推送、采购申请表单与保养计划等多项交付
- `309b5d697c` fix: 审批上一节点选分支与工单 BOM 快照
- `45a1c83df3` fix(kuaiai): 对话补客户端渠道头；研发交付物字典与物料快速新建
- `a87490d93d` feat: 单据行客商物料快照、产出单生产部门与考勤产线拉人
- `d17e5f9d8e` feat: 快连接拆包门禁与应用中心缓存治理，修报价系列 latest 自愈
- `447d3ab6fd` chore(backend): 移除入库的 haoligo OpenAPI 快照
- `6e218021b8` feat: sync local changes after pulling develop
- `96703099f3` feat(kuaioa): 月度考勤日格登记人与联动文案
- `64f169b12e` fix: 样机制作书补齐编码规则页面与实体登记
- `1fa6e303be` feat: 卧式产出单迁移编码规则与财务预支；前端更新日志
- `9ca16bd0f4` fix(haoligo): 卧式产出单审计列迁移与定制更新日志、zh-CN
- `8f36dcf8f0` fix(haoligo): 产出单部门筛选与分批回填的更新日志与文案
- `f9b11ec9fc` fix(haoligo): 回填生产部门限流说明与更新日志
- `2878991ed4` feat(wecom): 连接器可配公网地址，密钥编辑留空保持
- `9ebb4e8834` feat: enhance API management import and deduplication
- `b824636af8` feat: 工作小组绩效权重自动均分；跨租户恢复软 FK 前缀偏移
- `0d563bf924` fix(approval): 单据详情 loader 缺项不再拖垮全部审批明细
- `30aa384739` fix(approval): 撤回后收敛待审脏数据，待我审列表与单据一致
- `46b49fd66c` fix(auth): 企微 H5 OAuth 回跳固定 /mobile/ 并补部署说明
- `d2876621a7` fix(mobile): 企微多应用按 URL tenant 切换组织
- `141a3e16ee` fix(wecom): 应用主页部署说明改为路径型 /mobile/wecom/CorpId/AgentId
- `93e1378873` fix(wecom): 同 Corp 多应用按企微绑定反查组织并发现授权
- `6a270c2824` fix(approval): 或签待办通知当前节点全部审批人
- `bb5906b219` feat(users): 账户列表显示企微钉钉飞书绑定图标
- `dd68693d39` feat(haoligo): 好力 GO 薪酬结算迁移与更新日志文案
- `118e065603` feat(frontend): 好力 GO 产出单导入宽表映射与更新日志
- `b22b3ac326` fix(mobile): 记录企微 H5 退出再进不再转圈
- `19c2eff526` fix(mobile): 记录企微同一应用关掉再开不再转圈
- `44520a667f` fix(mobile): 记录企微关掉再开在任意页整页重开
- `4613d982e6` fix: 角色职能域保存与 PDF 打印压图重试增强
- `9a9a6d93c4` fix(print): Chromium PDF 崩溃真因路径与诊断
- `c53c7695d1` feat(audit,list): 审批通过可改白名单字段；报工/返工审核态与列表布局收敛
- `96a3b0a9fb` fix(audit,approval): 工具栏审核强制走弹窗；审批节点默认可改单
- `20b205a582` fix(audit): 弹窗可填字段可选；审核 hub 底栏可滚动
- `493c679725` fix(audit,approval): 一次发布生效；审核详情与跨轮执行履历
- `b5d48662b1` fix(funide-oa): 定制应用前端隔离契约与更新日志
- `934eab86ba` fix(kuaizhizao): 其他费用立账与设备看板；企微审批深链更新日志
- `e42577ef2a` fix: 企微采购选料权限、付款收款户与工单齐套等多项修复
- `9fc03de3ed` fix(approval): 审批推进下一节点时通知待办与企微
- `d096f24cbb` feat(kuaioa): 年度工资统计与离职考勤收口的更新日志
- `e16f2f2939` feat(kuaizhizao): 会签返工部门链与领导通过后填报，兼采购变更收口 —— **采购变更收口 C 子集已摘 `8d5db2825d`（复核 `27210d5dc5`），会签/填报 F 域余量待批**
- `777aa1a468` feat: 采购取单、企微审批卡、仓储推送与打印等多项交付 —— **采购取单门禁 C 子集已摘 `185c50587d`，企微/仓储推送/打印余量待批**
- `21e6b8fffe` fix(migrate): 任职回填迁移对齐表结构无 deleted_at
- `ede53f7a31` fix: 企微审批卡片软失效与图纸默认上传 200MB
- `1eb300325a` feat(approval,tenant,kuaiconnect): 审核中心预览与软删复活、手工创建自动提交、租户恢复自愈与金蝶下推收敛 —— **引擎+采购 hooks C 子集已摘 `c9edcdc2cd`（复核 `87454681ce`），审核中心/软删复活/租户自愈/金蝶收敛 F 域余量待批**
- `3ff4985443` feat(approval): 同人连任两级自动跳过，并修正已提交误显审核中
- `599db61d5e` feat: 工资结算分单迁移与好力更新日志，并修物料新建权限门控

### 批G deploy/ops/仓库治理/造数收尾 — 59 笔
- `c7fa35d334` chore: 依赖口径清理与看板图表懒加载韧性
- `2c2c2c6848` chore(aoci): 修复合并冲突残留并补齐合入侧索引
- `54fec48d47` chore: workspace compose 同步与 PLM/福尼特更新日志
- `2182a09f88` chore(aoci): 合入后补齐 missing/stale 索引
- `41fcf29a17` fix: 修复 platformUpdateLog 合并残留多余大括号
- `77448fd970` chore: 流程造数与设备运维造数移出仓库（本机保留）
- `3ab10aefc2` docs: 推送 SOP 按分流重写，死代码自检降为可选
- `992f191c27` chore(fast-deploy): legacy 主仓 dist 提交使用 git add -f
- `f978467013` improve(fast-deploy): 生产向导可选 dist 拉取或本机构建
- `577b7cad81` improve(fast-deploy): 向导一步三选一并通用化文案
- `8c4db8cdad` fix(fast-deploy): dist 仓 commit 继承主仓作者并支持跳过 npm
- `76fcb4cfea` chore(aoci): 主仓停止跟踪 .aoci 治理 JSON
- `90f3593703` chore(repo): 收窄 Git 跟踪范围并加索引漂移扫描
- `5c313c150c` chore(aoci): 主仓完全停止跟踪 .aoci 目录
- `1bca62aecf` chore(repo): 主仓停止跟踪 .cursor、AGENTS.md、.gitattributes
- `310daba2bf` chore(fast-deploy): AOCI 仓同步 AGENTS/.cursor 与 clean-workspace
- `c91b13c20c` docs: 更新微信群截图素材
- `09300569ac` feat(fast-deploy): 适配 CTyunOS/openEuler 系安装与 EL 映射
- `521f06b72f` fix(fast-deploy): CTyunOS 上 Caddy 改走官方静态包
- `e1650484c4` fix(fast-deploy): Caddy 静态包优先国内镜像下载
- `995b74b491` fix(deploy): Windows 按用户安装 Node 后环境检测可识别
- `f0f05414c6` fix(deploy): Windows uv sync 预装 Python 3.11 并走国内解释器镜像
- `47cb9831a8` docs: 对齐分仓推送 SOP 与 push.sh 默认行为
- `bf97d3a44a` chore(docs): 更新微信群截图并停止跟踪内部文档
- `ffa55326df` docs: 记录移动端登录鉴权回退到 10-31
- `9093398b50` fix(deploy): 一般模式恢复蓝绿，低配关闭蓝绿
- `0368c115f6` fix(deploy): 一般模式 update 默认蓝绿（含运维台非交互）
- `99c960026c` fix(fast-deploy): repair Windows dependency install scripts
- `34b1a1d3ed` fix(fast-deploy): Windows uv detection and Caddy install path
- `5f9690fc5f` fix(fast-deploy): avoid PowerShell $args shadow in curl download
- `27552972c4` fix(deploy): Ubuntu 无 pip 时装 uv 与 LOCALAPPDATA 未绑定
- `d827731540` fix(deploy): 迁移与 uvicorn 改 python -m 避开 uv trampoline
- `a1c2a8d424` fix(deploy): aerich 迁移改用 python -m aerich.cli
- `4f572a2431` fix(deploy): Windows 跳过 PATH 中 Linux 版 Caddy
- `d003ff3404` fix(deploy): 蓝绿 backend 健康等待随 worker 加长
- `18cd0581d9` fix(deploy): Taskiq 启动改 python -m taskiq 避开 uv trampoline
- `8700bd8a16` revert(deploy): 恢复 fast-deploy 至 11-05 末版 (5f9690fc5)
- `351fe4815e` revert(deploy): 恢复 fast-deploy 至 11-04 日快照 (0368c115f)
- `0d021ef663` revert(deploy): 移除 11-05 新增的 promote-prod-branch.sh
- `489fb03d8a` fix(deploy): Windows 识别可用 uv，不用 11-05 install-component
- `1821d9dfb7` fix(deploy): Windows 识别 Roaming Python312 Scripts 中的 uv
- `c05a1f0f33` fix(deploy): 迁移改用 python -m aerich.cli 避开 uv trampoline
- `34177331ca` fix(deploy): 迁移直调 .venv python，不再 uv run
- `fd25330958` fix(deploy): Windows 全站绕过 uv run，直调 .venv Python
- `1cd3a1dfeb` fix(deploy): Windows 直调 venv 时去掉多余 python 参数
- `f26a029719` fix(deploy): Windows 跳过 PATH 上 Linux 版 caddy
- `08ed0e510f` fix(deploy): Windows Caddy 下载修复 curl 调用与 IWR 回退
- `83a29492cf` fix(deploy): update 时保留 fast-deploy/.tools 便携组件
- `8a0f731a42` fix(deploy): Windows Caddy 改存主仓外 riveredge-runtime
- `ab912e4c14` fix(deploy): Windows Caddy 国内优先山大 Release 镜像
- `aa7d181320` fix(deploy): install-component.ps1 Caddy 错误文案改英文
- `c16cf35d1c` fix(deploy): 锁定 Windows Caddy 唯一落点 riveredge-runtime
- `95efae8f6d` fix(deploy): 撤回 riveredge-runtime，Caddy 固定 fast-deploy/.tools
- `454e306f9a` fix(deploy): Windows 不 git clean；禁止 install 覆盖已有 caddy.exe
- `0ea3994534` fix(deploy): 移除未核实的 SDU Caddy 镜像，优先 ghproxy.net
- `8908591c5f` chore(docs): 更新微信交流群截图
- `12550024bb` fix(migrate,deploy): 报工/返工 review_status 列幂等与组装清空校验
- `707700c8d0` fix(deploy): install-web-dist 同步刷新 dist-live，避免 Caddy 仍读旧前端包
- `220d2ce271` fix(deploy): 低配机后端健康检查超时改为 360s

### 默认跳过候选（e2e/造数，摘前复核） — 10 笔
- `d24e273eae` feat(flow-generate): 完整 MES 造数仿真与备份还原主键对齐
- `30dc635120` feat: 流程造数仿真、计划采购自动化与备份恢复去重
- `5ef36c8ca9` feat: 流程造数页改为本机按需挂载
- `3322ba7046` test(e2e): 补充预测探针脚本
- `89d5038750` test(e2e): sync in-progress e2e snapshot
- `68f9b9b084` test(e2e): 保存进行中的销售 e2e 用例改动
- `6c1aade1c0` chore: 同步 e2e 用例与更新日志，清理 test-report
- `381be2b6ed` chore: 同步 e2e 用例与更新日志，清理 test-report
- `824df0cf3d` chore(aoci): unify source and formal asset push
- `757ba69711` docs(aoci): establish formal asset push SOP

### 已落地/已评跳过/patch等价 — 52 笔（不占剩余额度）
- `0513e907f5` [C✓] fix(purchase): 采购申请列表不再因审批选边校验整页空白
- `3f0cebac31` [patch≡] fix(approval): 总经理特批按提交选边自动分流且撤回不丢边
- `d892f36d03` [C✓] feat(purchase): add demand parties and vendor inquiry workfl
- `b12cc66e71` [C✓子集] fix(kuaizhizao): 修复 API 路由挂载与采购仓储财务设备联调批次
- `71d733f78b` [跳过] fix(finance): 修复往来对账详情页 if 语法导致前端构建失败
- `2dd7241cfd` [B域✓] fix(kuaizhizao): purchase order finance queries use host ORM
- `70795dbdc6` [B域✓] fix(kuaizhizao): payment application uses host Payable and P
- `147c5cabf8` [B域✓] fix(kuaizhizao): sweep warehouse and host paths to finance O
- `899881ade2` [B域✓] docs(i18n): update log copy for warehouse finance ORM sweep
- `52bce20beb` [B✓] fix(finance): 宿主财务管理 ORM 清单与就绪门禁一次性收口
- `02f730b1c2` [A✓] fix: 去掉更新日志重复条目 kuaioa-employee-batch-import-r01
- `5f085a19c9` [C✓] feat: 采购退货红字应付、工装模具完修明细与采购申请名称
- `57a37e2749` [C✓前置] feat: 库位同步、审核草稿回填、导入幽灵行与多项联调
- `cf2ee5941f` [A✓] fix(kuaizhizao): 修复采购申请页 useCallback 依赖 TDZ 白屏
- `029aa6f542` [C✓] fix: 采购下推保留物料；报价导出列表/明细；销售改号与打印料号
- `60c6a5893b` [C✓] feat(kuaizhizao): 需求计算/采购申请下推改为直接建单
- `c3953509e9` [A✓] fix(api): 对齐 DB/请求超时并支持可配 uvicorn workers
- `a60f3e9039` [C✓] feat(kuaizhizao): 行物料附件、阶梯价与调拨序列号
- `05707b94ff` [A✓] fix(api): 接口超时与配置调整
- `6781d4687b` [A✓] fix(print): 保存为 PDF 避免公章致 Chromium Target crashed
- `f50bbb47c7` [A✓] fix(print): 回退 emulate_media 与外链拦截导致的 PDF 回归
- `176c2d2aeb` [A✓] fix(print): 线上 PDF 不再等待 load 挂起
- `ce1d67ae07` [跳过] chore: 移除合并临时目录 .merge-tmp
- `4f6d7929af` [A✓] fix: 修复 sync_binding_contract 缩进导致仓储 API 整包 404
- `4a9d6d3e63` [C✓] fix: 采购含税列表金额、付款计划互算与金蝶出入库更新绑定
- `4ab6cf5ca3` [C✓] fix(kuaizhizao): 采购申请草稿保存与审核态对齐
- `1d968cd27b` [C✓] feat(kuaizhizao): 付款申请多选取单、入库确认与财务取单优化
- `5688431985` [跳过] chore: 移除临时自定义字段扫描脚本
- `e520cafd37` [C✓] feat(purchase): 采购订单含税价/价税类型与结算拉单联动
- `d81b4b70bf` [A✓子集] feat(equipment): 今日待完成与维修时间展示；采购财务审核与设备保养联动
- `8776129c1d` [跳过] fix(web): 修复 platformUpdateLog 合并后条目结构损坏
- `3491e7bd73` [A✓] chore: gitignore 本地 .tmp 草稿脚本
- `ddd31709d6` [A✓] fix(dashboard): 设备看板中心贴图改为打包资源并增加加载失败兜底
- `ebe45fdf0d` [跳过] fix(dashboard): 记录手机采购申请主副数量选料修复
- `826acd7181` [A✓] fix(ui): 页签关闭身份、侧栏与财务中心双开
- `53203ff84b` [C✓子集] feat(kuaizhizao): 采购入库金额快照、红框打印与 Playwright 稳定性
- `b485a0a0e5` [C✓] fix(kuaizhizao): 单据价税按录入单价统一拆分，含税单价不再回推
- `8c111dd65f` [A✓] feat(core,import): 关联自定义字段校验与单据导入导出文本保全
- `e49db6af77` [A✓] fix(core,custom-fields): 关联对象字符串 id 落数值列并暴露 lookup/导入失败
- `f1c2d18cfb` [A✓子集] feat(web): UniTable 刷新反馈、采购单读路径加速与动作门禁加固
- `5e56460684` [A✓] fix(custom-fields): 关联对象只读展示改用同高同宽输入框
- `cde27ccd7e` [A✓] fix(custom-fields): 关联字段改用 useWatch 恢复半宽栅格与 lookup
- `66af904bd3` [A✓] fix(web): polyfill Array.toSorted for older Chromium
- `5b75d78120` [A✓] fix(web): Win7 Chrome 内联补齐 toSorted，蓝绿 install-web-dist 同步槽位
- `2ba9fe60cf` [A✓] chore(ops): 租户金蝶强一致审计脚本与实施 SOP
- `1d4531b7f6` [A✓] fix(ops): 强一致脚本 TORTOISE_ORM 导入路径
- `3a49808eb6` [跳过-依赖] fix(kuaizhizao): 手工建单自动提交日志改用 %s 占位符
- `870e5476bf` [A✓] fix(kuaizhizao): 修复销售订单列表 SalesOrderItem 作用域遮蔽
- `e2c25bb9ea` [跳过] chore: 移除临时死代码检查脚本
- `390ddecff0` [跳过-依赖] fix(inbound): 采购入库页补 JSX fragment 以通过前端构建
- `c6e5a46161` [跳过-依赖] fix(purchase): 修正采购申请库存组件 DocumentLineTotalStock 引用路径
- `0f841b6a1b` [跳过-依赖] fix(kuaizhizao): 修复工单 BOM 预览权限依赖导致整包路由 404
- `4d124a088e` [C✓全量] feat(kuaizhizao): 单据行价税统一与采购入库含税算价 → `28049fbd99`（连依赖移植：退货下推/其他出库行编辑/XLSX 导出/uni-pull·batch·push 基建/audit hub；`:push` 权限未声明故 push 面板休眠；pytest 3819p/6f 全为基线预存量）
- `bbb1f86ae9` [基线清理] 修复批C全量验证暴露的基线遗留问题（非上游提交）：追溯闭集补 purchase_inquiry；manifest 测试 UTF-8；document_action_policy None 语义；kingdee_cosmic_paths 补 apply_connector_org_to_payload；新增 scan_route_manifest_alignment.py（AST 解析）并修 kuaiplm:change:create / drawing 权限码 / material-lifecycle-trace 声明 / module_references 漂移；sales_order_change_service 复用 is_pending 消门禁告警；antd6 全量修复（size 枚举/Space orientation/Alert title/Dropdown.Button/destroyOnHidden/addon*/Drawer size）；common.remarks→common.remark 7 处；时区契约 32 项清零（resolve_business_datetime/now_utc/to_api_isoformat + 前端 toApiDateTimeString/formatDateTimeBySiteSetting）。验证：pytest 3825 passed / 0 failed；全部扫描 0 发现。
- `512bdcfa7c` [回归修复] 非上游提交：销售订单非 update 动作 UnboundLocalError 死行（`f2baa424ac` 残留）删除+service 级回归测试；`s148_share._parse_expires` naive 按站点墙钟 `coerce_business_datetime_to_utc`；销售预测 `review_submitted` 全链路接线（已送审可删后门/待审不可审阻断修复）；uni-table `'middle'`→`'medium'`。验证：pytest 3826 passed / 0 failed。
- `f33331eca3` [AOCI] 孤儿 `PurchaseReceiptEditModal.tsx` Entry 移除+73 条创作落盘（余约 635 候选待后续批次）。
- `31b1179a8e`/`ebdc66ac4d`/`ad91f99f5e` [C✓] 失焦反算簇三笔 → `32d5cb0b5b`
- `c346cff13b` [C✓] 采购入库价税与订单统一及采购链修复（含 `d5f1a83261` 后端子集）→ `d8b15c8e78`
- `6abba1dbd5` [C✓子集] 服务采购全流程与申请转单占用 → `74aef8fb30`
- `e16f2f2939` [C✓子集] 采购变更收口/占用聚合/非赠品校验 → `8d5db2825d`（复核 `27210d5dc5`）
- `777aa1a468`/`9de82e8d57` [C✓子集] 申请取单门禁与采购结算价格 → `185c50587d`
- `d32d1e031d` [C✓子集] 税率 1% 归一化 → `97ec0acf20`
- `ec29267f5b` [C✓子集] 付款申请来源订单聚合与发票校验 → `555b237519`
- `1eb300325a` [C✓子集] 手工建单自动提交引擎+采购 hooks → `c9edcdc2cd`（复核 `87454681ce`）
