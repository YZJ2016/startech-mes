# 批D1/D2 进度交接 — 2026-11-20（结构前置簇已落地 `60259301a4`）

## 状态

- 本地 HEAD：`bd7f3df973`（develop，未推送）
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

## 下一笔

`2e8ecad990`（苍穹销售出库/其他出库/盘盈盘亏出站——4 个新 push service≈1900 行+面板+presets；企微同步推送属 F 域剔除）→ `4bd853a94f` → `4bd853a94f` → `d7966d33c6` → `d7da8e14f8` → `905787348a` → `a0b353ce7e` 主体 → `5d65aa9fa4` → `37e5213a50` …（清单见 `handoff-2026-11-16-batch-c1.md` 附录批D1/D2 76 笔）

跨批余量：`c588744e04` kingdee 两件 / `4a7f11604c` sync-push-hub 三页+核对账 / `d32d1e031d` 金蝶脏辅助单位 / `ce86f28932` api_service 预置+`report_service._finalize_inventory_api_rows` 前置链

## 验证基线

- pytest 相关域 193 过；tsc 增量 0 新错（存量负债同基线）
- `scan_timezone_contract`/`scan_document_action_bypass` 0；`scan_permission_bypass` 1 条 manifest 既有告警
