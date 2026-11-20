# 上游同步·批E 仓储/MES 核心

> 数据源：handoff-01 附录批次圈定 + `上游同步台账.md` 判定 + 本地提交映射 + R2 文件级 TSV 判定。
> 状态：✅已摘/已评（附本地 hash 或台账方式）｜🟡缓置（备注=领回条件）｜🔵R2 文件级已判/部分（积压清零轮，文件判定为准，逐提交不再单独评）｜⬜未评｜⏭跳过｜💀上游重写死哈希。
> 返回：[00-总账-上游同步](00-总账-上游同步.md)

共 **42** 笔：✅4 ｜ 🔵R2 36 ｜ 🟡0 ｜ ⬜2 ｜ ⏭0 ｜ 💀0

| 上游 | 主题 | 状态 | 备注 |
|---|---|---|---|
| `a98e70dee3` | feat(kuaizhizao): BOM外领料、调拨批号入库日与 MRP 下推修复 | 🔵R2部分(4/39文件) | applied,deferred,tracked |
| `d15b47984a` | feat: 过程检验方案快速新建与执行回填，修需求计算预校验失败态 | 🔵R2部分(3/13文件) | applied,tracked |
| `1f239033e9` | feat: 需求草稿级联撤回与重算、委外检验/巡检编码规则、销售订单列表导入拆分 | 🔵R2部分(3/16文件) | applied,tracked |
| `759be91800` | feat: 需求草稿级联撤回与重算、委外检验/巡检编码规则、销售订单列表导入拆分 | 🔵R2部分(3/16文件) | applied,tracked |
| `f7c52a4dc0` | fix: 收货通知自动通知仓库、计算完成下推工单与委外结束时间 | 🔵R2部分(6/21文件) | applied,deferred,tracked |
| `9d94441ae0` | fix: 质量检验拆分服务、单据 API 门禁与质检中心联调硬化 | 🔵R2部分(17/39文件) | applied,deferred,superset,trac |
| `5db37fe829` | feat: 登录默认组织、下推转到与确认出库换仓刷新库存 | 🔵R2部分(6/25文件) | applied,superset,tracked |
| `a7e644b2ba` | feat: 发货通知库存提示明细与侧栏菜单 Morphicons 悬停形变 | 🔵R2部分(5/10文件) | applied,tracked |
| `84bccf2711` | fix(master-data): 补齐物料多单位同步弹窗与更新日志文案 | 🔵R2文件级已判 | applied |
| `46fd028b5e` | fix(master-data): 补齐物料服务多单位相关类型导入 | ⬜未评(文件已见1/1) |  |
| `1e33dd2861` | feat: improve material and process management | 🔵R2部分(6/17文件) | applied,tracked |
| `895ace488c` | fix(kuaizhizao): OQC 取单补全 quality_inspection_ | 🔵R2部分(2/3文件) | applied,tracked |
| `1531ccc53e` | feat(kuaizhizao): 呆滞物料统计支持库龄天数分段筛选 | 🔵R2部分(1/7文件) | applied,tracked |
| `a54feb82c1` | feat(kuaizhizao): 序列号投产/拆单与工单列表 SN 展示 | ✅已评(簇内,台账有述) |  |
| `f2e06e453e` | fix(kuaizhizao): 质检方案编码字段与检验计划列表联动 | ✅已评(簇内,台账有述) |  |
| `eda3c9f86a` | feat(warehouse): 销售出库列表支持规格型号与日期筛选 | 🔵R2部分(6/12文件) | applied,tracked |
| `f129439b56` | feat(mes): 返工指派执行、倒冲幂等与 MRP 精度对齐 | 🔵R2部分(5/28文件) | applied,deferred,superset,trac |
| `0da09e1bc4` | feat(equipment): 设备故障/维修协作参与者与返修报工 | 🔵R2部分(2/12文件) | applied,tracked |
| `2c67aabdda` | feat(work-order): 过报规则、分批中心与报工数量增强 | 🔵R2部分(4/18文件) | applied,deferred,tracked |
| `30955e5e57` | feat(work-order): 工单创建与报工数量调整 | 🔵R2部分(2/5文件) | applied,tracked |
| `8fbbedc569` | fix: 销售出库确认批号与客商取价顺序保存 | 🔵R2部分(4/7文件) | applied,tracked |
| `01ef0734c2` | fix: 其他入库确认预览补录批号与序列号 | 🔵R2部分(3/5文件) | applied,superset,tracked |
| `8af3ae4f6e` | fix: 其他入库确认预览不再反复请求导致卡死 | 🔵R2部分(2/3文件) | applied |
| `ab3a537da9` | fix: 其他入库确认预览始终展示批号录入 | 🔵R2部分(2/4文件) | applied,tracked |
| `e34fdf1f5e` | feat: 其他入库原因类型增加生产完工入库 | 🔵R2部分(3/7文件) | applied,superset,tracked |
| `8071010916` | feat(inventory): 库存台账支持库存单位与基本单位双计量 | 🔵R2部分(10/24文件) | applied,deferred,tracked |
| `c0a917fc45` | feat: 采购入库出站映射与单位目录推送 | ✅已评(簇内,台账有述) |  |
| `6c4351b42c` | feat: 仓储出库、API文档与集成配置优化 | ✅已评(簇内,台账有述) |  |
| `11e8cb33be` | feat(warehouse): 出库确认与工序跳转优化 | 🔵R2部分(3/13文件) | applied,deferred,tracked |
| `63c2a77fc1` | fix(warehouse): 成品/半成品入库单补齐 PUT 编辑 | 🔵R2部分(5/10文件) | applied,deferred,tracked |
| `511df029e4` | feat(ui): 树表格与仓储界面优化 | 🔵R2部分(4/21文件) | applied,deferred,tracked |
| `56a77a0ff9` | fix(outbound,audit): 出库复合行键可提交；未走分支标未触发 | 🔵R2部分(2/7文件) | applied,tracked |
| `6900eeea94` | feat(material): 物料批量启用/停用与isActive字段适配 | 🔵R2文件级已判 | applied |
| `9622a5a304` | fix(production,cf): 工单成品入库默认值与自定义字段数值健壮性，装箱明细 | 🔵R2部分(3/8文件) | applied,superset,tracked |
| `59a0186016` | fix: 发货通知免审通知仓库与出库明细 Popover | 🔵R2部分(4/8文件) | applied,tracked |
| `b62c61c485` | fix(process): 工艺路线更新接口支持snake_case字段，修复允许工序跳转 | 🔵R2文件级已判 | applied |
| `469d220121` | feat(quality): 工单成品检验支持按剩余量分批加载 | 🔵R2部分(1/8文件) | applied,tracked |
| `8c6303355a` | fix(kuaizhizao): 单计量库存三量对齐并隐藏副单位列 | 🔵R2部分(3/9文件) | applied,tracked |
| `9eb17b1d9e` | feat(kuaizhizao): 其他出库单增加领用日期 | 🔵R2部分(4/10文件) | applied,tracked |
| `0a13af1635` | fix(master-data,quality): 物料质检分场景保存与方案步骤弹窗层级 | 🔵R2部分(4/5文件) | applied,tracked |
| `9c9f0d99bf` | fix(kuaizhizao): 其他入库序列号、销售出库与取单开口行 | 🔵R2部分(23/87文件) | applied,deferred,superset,trac |
| `a7bd984609` | fix(frontend): documentDetailSerialNumberColu | ⬜未评(文件已见1/1) |  |
