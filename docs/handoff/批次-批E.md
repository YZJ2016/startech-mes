# 上游同步·批E 仓储/MES 核心

> 数据源：handoff-01 附录批次圈定 + `上游同步台账.md` 判定 + 本地提交映射 + R2 文件级 TSV 判定。
> 状态：✅已摘/已评（附本地 hash 或台账方式）｜🟡缓置（备注=领回条件）｜🔵R2 文件级已判/部分（积压清零轮，文件判定为准，逐提交不再单独评）｜⬜未评｜⏭跳过｜💀上游重写死哈希。
> 返回：[00-总账-上游同步](00-总账-上游同步.md)

共 **42** 笔：✅37 ｜ 🔵R2 5 ｜ 🟡0 ｜ ⬜0 ｜ ⏭0 ｜ 💀0

| 上游 | 主题 | 状态 | 备注 |
|---|---|---|---|
|`a98e70dee3`|feat(kuaizhizao): BOM外领料、调拨批号入库日与 MRP 下推修复|✅已摘(R2)|39/39文件; applied21,tracked10,superset8|
|`d15b47984a`|feat: 过程检验方案快速新建与执行回填，修需求计算预校验失败态|✅已摘(R2)|13/13文件; applied9,tracked3,superset1|
|`1f239033e9`|feat: 需求草稿级联撤回与重算、委外检验/巡检编码规则、销售订单列表导入拆分|✅已摘(R2)|16/16文件; tracked8,applied7,superset1|
|`759be91800`|feat: 需求草稿级联撤回与重算、委外检验/巡检编码规则、销售订单列表导入拆分|✅已摘(R2)|16/16文件; tracked8,applied7,superset1|
|`f7c52a4dc0`|fix: 收货通知自动通知仓库、计算完成下推工单与委外结束时间|✅已摘(R2)|21/21文件; applied15,tracked5,superset1|
|`9d94441ae0`|fix: 质量检验拆分服务、单据 API 门禁与质检中心联调硬化|🔵R2部分|39/39文件; tracked18,applied15,superset5,deferred1|
|`5db37fe829`|feat: 登录默认组织、下推转到与确认出库换仓刷新库存|✅已摘(R2)|25/25文件; applied15,tracked6,superset4|
|`a7e644b2ba`|feat: 发货通知库存提示明细与侧栏菜单 Morphicons 悬停形变|✅已摘(R2)|10/10文件; applied7,tracked3|
|`84bccf2711`|fix(master-data): 补齐物料多单位同步弹窗与更新日志文案|✅已摘(R2)|4/4文件; applied4|
|`46fd028b5e`|fix(master-data): 补齐物料服务多单位相关类型导入|✅已摘(R2)|1/1文件; applied1|
|`1e33dd2861`|feat: improve material and process management|✅已摘(R2)|17/17文件; applied15,superset2|
|`895ace488c`|fix(kuaizhizao): OQC 取单补全 quality_inspection_|✅已摘(R2)|3/3文件; applied2,tracked1|
|`1531ccc53e`|feat(kuaizhizao): 呆滞物料统计支持库龄天数分段筛选|✅已摘(R2)|7/7文件; applied5,tracked2|
|`a54feb82c1`|feat(kuaizhizao): 序列号投产/拆单与工单列表 SN 展示|✅已摘(R2)|12/15文件; applied7,tracked4,superset1|
|`f2e06e453e`|fix(kuaizhizao): 质检方案编码字段与检验计划列表联动|✅已摘(R2)|4/4文件; tracked3,applied1|
|`eda3c9f86a`|feat(warehouse): 销售出库列表支持规格型号与日期筛选|✅已摘(R2)|12/12文件; applied10,tracked2|
|`f129439b56`|feat(mes): 返工指派执行、倒冲幂等与 MRP 精度对齐|✅已摘(R2)|28/28文件; applied17,tracked10,superset1|
|`0da09e1bc4`|feat(equipment): 设备故障/维修协作参与者与返修报工|✅已摘(R2)|12/12文件; applied6,tracked6|
|`2c67aabdda`|feat(work-order): 过报规则、分批中心与报工数量增强|✅已摘(R2)|18/18文件; applied10,tracked6,superset2|
|`30955e5e57`|feat(work-order): 工单创建与报工数量调整|✅已摘(R2)|5/5文件; applied3,superset1,tracked1|
|`8fbbedc569`|fix: 销售出库确认批号与客商取价顺序保存|✅已摘(R2)|7/7文件; applied4,tracked2,superset1|
|`01ef0734c2`|fix: 其他入库确认预览补录批号与序列号|✅已摘(R2)|5/5文件; superset2,applied2,tracked1|
|`8af3ae4f6e`|fix: 其他入库确认预览不再反复请求导致卡死|✅已摘(R2)|3/3文件; applied2,superset1|
|`ab3a537da9`|fix: 其他入库确认预览始终展示批号录入|✅已摘(R2)|4/4文件; applied2,tracked1,superset1|
|`e34fdf1f5e`|feat: 其他入库原因类型增加生产完工入库|✅已摘(R2)|7/7文件; applied4,tracked2,superset1|
|`8071010916`|feat(inventory): 库存台账支持库存单位与基本单位双计量|✅已摘(R2)|24/24文件; applied19,tracked4,superset1|
|`c0a917fc45`|feat: 采购入库出站映射与单位目录推送|🔵R2部分|34/41文件; applied25,tracked5,superset2,deferred1,domain-out1|
|`6c4351b42c`|feat: 仓储出库、API文档与集成配置优化|🔵R2部分|31/40文件; applied19,tracked11,deferred1|
|`11e8cb33be`|feat(warehouse): 出库确认与工序跳转优化|🔵R2部分|13/13文件; applied11,tracked1,deferred1|
|`63c2a77fc1`|fix(warehouse): 成品/半成品入库单补齐 PUT 编辑|✅已摘(R2)|10/10文件; applied7,tracked3|
|`511df029e4`|feat(ui): 树表格与仓储界面优化|✅已摘(R2)|21/21文件; applied12,tracked6,superset3|
|`56a77a0ff9`|fix(outbound,audit): 出库复合行键可提交；未走分支标未触发|✅已摘(R2)|7/7文件; applied4,tracked2,superset1|
|`6900eeea94`|feat(material): 物料批量启用/停用与isActive字段适配|✅已摘(R2)|4/4文件; applied3,superset1|
|`9622a5a304`|fix(production,cf): 工单成品入库默认值与自定义字段数值健壮性，装箱明细|✅已摘(R2)|8/8文件; applied4,superset2,tracked2|
|`59a0186016`|fix: 发货通知免审通知仓库与出库明细 Popover|✅已摘(R2)|8/8文件; applied5,tracked3|
|`b62c61c485`|fix(process): 工艺路线更新接口支持snake_case字段，修复允许工序跳转|✅已摘(R2)|3/3文件; applied3|
|`469d220121`|feat(quality): 工单成品检验支持按剩余量分批加载|✅已摘(R2)|8/8文件; tracked4,applied3,superset1|
|`8c6303355a`|fix(kuaizhizao): 单计量库存三量对齐并隐藏副单位列|✅已摘(R2)|9/9文件; tracked5,applied4|
|`9eb17b1d9e`|feat(kuaizhizao): 其他出库单增加领用日期|✅已摘(R2)|10/10文件; applied6,tracked4|
|`0a13af1635`|fix(master-data,quality): 物料质检分场景保存与方案步骤弹窗层级|✅已摘(R2)|5/5文件; applied3,superset1,tracked1|
|`9c9f0d99bf`|fix(kuaizhizao): 其他入库序列号、销售出库与取单开口行|🔵R2部分|87/87文件; applied53,tracked23,superset9,deferred2|
|`a7bd984609`|fix(frontend): documentDetailSerialNumberColu|✅已摘(R2)|1/1文件; tracked1|
