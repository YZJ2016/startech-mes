# 批D1/D2 进度交接 — 2026-11-20（结构前置簇已落地 `60259301a4`）

## 状态

- 本地 HEAD：`3268f93cd2`（develop）
- 快照：`backup/batch-d-pre-20261120`（基于 `af397c67c7`）；上游 tip：`33e054b5d8`
- 台账：`docs/上游同步台账.md` 已登记本簇 8 笔（含越界段 `e451b48dc2` D 子集）

## 已落地（上游 → 本批）

| 上游 | 内容 |
|---|---|
| `994bc9a312` | cosmic request_body None 合并+createorg 双侧剥除+source_errors 门控（binding-sources hunk N/A） |
| `a0b353ce7e` | **仅依赖子集**：createorg filter 检查+strip 调用点；主体（其他入出库外推/运行历史）未摘 |
| `093512788c` | batchQuery 出站三层剥除+源 path 零拉诊断+测试 |
| `7fa73e053a` | infer_parent_by_code 全链+Kingdee 响应解包+预置升级助手+硬删+前端开关/解析 |
| `e817c50d24` | QueryGroupInfo 单参 JSON+blue_green 非交互门禁 |
| `fdcfdd500b` | FormId=BD_MATERIAL/FMaterialGroup+遗留 FormId 登记+接口唯一键友好化+FormId 保留升级 |
| `e451b48dc2` | D 子集：分组空拉软完成 empty_reason+前端 stepSourceEmptyContinue |
| `df7d635797` | D 子集：api_sync_binding_refs（本地 13 表）+uuid 更新+三层优选弹窗+4 syncConfig+迁移 `20261120090000` |

## 关键决策

- `959f65b743`（同步对比）**缓置**：依赖整条外推链 —— `kingdee_cosmic_push_adapter`(`2c945a39fb`)、`kingdee_im_warehouse_revoke_service`/`kingdee_purchase_receipt_revoke_service`(`05d001dd6d`+`899307f4d6`)、5 张未建绑表（finished_goods/other_inbound/other_outbound/production_picking/sales_delivery sync_binding）——随主扫按上游时序领回
- `api_sync_binding_refs` 为绑表引用登记**唯一真源**；后续每落地一张上游绑表（storage_location/warehouse_location_ref/material_multi_unit/material_batch_manage/fg_receipt/other_inbound/other_outbound/production_picking/purchase_receipt/sales_delivery）必须补登记
- 迁移 997/999 已于批C `2f14a64511` 落 `20261119000000`/`20261119010000`；**勿重复**复制上游原名文件
- zh-CN updateLog 键大量已在 HEAD 预置：加键前先 grep，重复只补条目
- 上游 `material_group_preset_needs_upgrade` 测试断言与实现自相矛盾，本地按实现契约对齐

## 已落地（续）

| `2c945a39fb` | `bd7f3df973`：kingdee_cosmic_push_adapter+kingdee_purchase_receipt_push_service（im_purinbill 出站注册进诚实集合）+仓库 sbd getList 改写/预置/前端入库 Hub 外推面板+manifest inbound:push；E/F/G 域剔除 |
| `2e8ecad990` | `ada8809fd2`：苍穹 4 外推 service（im_saloutbill/im_otheroutbill/im_surplusbill/im_deficitbill）+2 面板新页+三页 Hub+BatchPanel 按 profile 选 API+manifest/hook；OtherOutbound 面板/接线 HEAD 已具剔除 |
| `d7966d33c6` | `a12547f46b`：612 无 status 失败外壳双端拦截+warehouse_preset_needs_upgrade 扩 description/api_service 仓库自愈两路 |
| `d7da8e14f8` | `a12547f46b`：连接器 org_number 唯一组织真源（apply_connector_org_to_payload）+预设去 BU-00000+单位下拉 ids 精确查；common.sh N/A |
| review 修复 | `3268f93cd2`：子代理双端 review → `kingdee_cosmic_response_status.py` 独立模块（上游 tip 结构，failCount/successCount/filter）；`DocumentPushBatchPanel` 收敛 tip（`2e8ecad990` git apply 曾误删 bindActionOptions 等 prop）；`useUniPullQuery.resetModal` 补（上游潜在缺失）；payload `force`；候选分页 skip/limit；inbound purchase 勾选恒可选；前端 manifest 4 push 权限；conftest 模型补 |

## 下一笔

`4bd853a94f`（采购入库入站同步/绑表簇——须先评本地绑表冲突）→ `905787348a`（sync-run 历史）→ `a0b353ce7e` 主体（其他入出库绑表/外推）→ `5d65aa9fa4`（客户/销售订单入站）→ `37e5213a50` …（清单见 `handoff-2026-11-16-batch-c1.md` 附录批D1/D2 76 笔）

跨批余量：`c588744e04` kingdee 两件 / `4a7f11604c` sync-push-hub 三页+核对账 / `d32d1e031d` 金蝶脏辅助单位 / `ce86f28932` api_service 预置+`report_service._finalize_inventory_api_rows` 前置链

## 验证基线

- pytest 相关域 128 过（paths/source_rows/integration/data/kuaiiot 全绿，3153 总过 1 修）；前端 `build:16g` 出 dist 成功并已提交
- tsc：触及文件 0 错；`historySourceType`/`SyncReconcilePanel`/`SyncRunHistoryPanel`/`listDocumentPushRunHistory`/`reconcileDocumentPush` 属 `905787348a`+`959f65b743` 未摘层，为 HEAD 存量负债（other-inbound/other-outbound 页已传 prop）——随主扫领回，禁止半摘
- 遗留：`kingdee_im_otherinbill` 未入 `DOCUMENT_PUSH_KNOWN_PROFILES`（随其他入库出站提交一并补）；`document_push_silent` 新源类型仅手动推（上游同）
- `scan_timezone_contract`/`scan_document_action_bypass` 0；`scan_permission_bypass` 1 条 manifest 既有告警
