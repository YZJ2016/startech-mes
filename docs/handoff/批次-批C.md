# 上游同步·批C 价税/采购/销售

> 数据源：handoff-01 附录批次圈定 + `上游同步台账.md` 判定 + 本地提交映射 + R2 文件级 TSV 判定。
> 状态：✅已摘/已评（附本地 hash 或台账方式）｜🟡缓置（备注=领回条件）｜🔵R2 文件级已判/部分（积压清零轮，文件判定为准，逐提交不再单独评）｜⬜未评｜⏭跳过｜💀上游重写死哈希。
> 返回：[00-总账-上游同步](00-总账-上游同步.md)

共 **37** 笔：✅37 ｜ 🔵R2 0 ｜ 🟡0 ｜ ⬜0 ｜ ⏭0 ｜ 💀0

| 上游 | 主题 | 状态 | 备注 |
|---|---|---|---|
|`31b1179a8e`|失焦反算|✅已摘(R2)|9/9文件; applied6,tracked3|
|`ebdc66ac4d`|/`ad91f99f5e` PO 金额契约对齐两笔|✅已摘(R2)|7/7文件; applied4,tracked3|
|`c346cff13b`|采购入库价税与订单统一及采购链多项修复|✅已摘(R2)|26/26文件; tracked14,applied11,superset1|
|`0c014426a7`|入库撤回前回退应付审核状态（C3）|✅已摘(R2)|3/3文件; applied2,tracked1|
|`2e57ae600e`|采购发票取单预览（C3）|✅已摘(R2)|3/3文件; applied3|
|`2a5b2caf14`|/`6ba9b54cdc`/`c583dd0b25` 允许账户负余额三连（C3）|✅已摘(R2)|16/16文件; tracked11,applied5|
|`9de82e8d57`|解散群+采购结算价格+图纸（混合）|✅已摘(R2)|17/17文件; tracked10,applied7|
|`d32d1e031d`|税率1%归一化+入库金蝶脏辅助单位（C/D）|✅已摘(R2)|9/9文件; tracked5,applied4|
|`ec29267f5b`|打印表头+付款申请打印+出库批号（混合）|✅已摘(R2)|60/60文件; tracked28,applied26,superset4,domain-out2|
|`777aa1a468`|采购取单/企微审批卡/仓储推送/打印（混合大提交）|✅已摘(R2)|39/39文件; tracked21,applied16,superset2|
|`e16f2f2939`|会签返工部门链+采购变更收口（F/C）|✅已摘(R2)|49/49文件; tracked27,applied21,superset1|
|`1eb300325a`|手工建单自动提交等混合|✅已摘(R2)|59/59文件; applied32,tracked20,superset5,domain-out2|
|`6abba1dbd5`|服务采购全流程+申请转单占用修复|✅已摘(R2)|113/115文件; tracked58,applied48,superset7|
|`9ec209fab8`|采购订单同步预加载价税+详情未税单价|✅已摘(R2)|8/8文件; applied4,tracked4|
|`c588744e04`|生产入库外推改绑成品入库+统一税率%录入（C/D）|✅已摘(R2)|11/11文件; applied8,tracked3|
|`4a7f11604c`|采购入库金额写路径+物料快建开关+同步对比组件级|✅已摘(R2)|17/19文件; applied10,tracked7|
|`13ac1e63d9`|采购发票登记 DocumentRelation 软删误用（C3）|✅已摘(R2)|4/4文件; applied4|
|`dbfcfe37a9`|销售订单列表+采购入库价税+供应商联系人（评估 tip）|✅已摘(R2)|15/15文件; tracked9,applied6|
|`37409d3b29`|客商地址与取价、列表与物料选择体验|✅已摘(R2)|105/105文件; tracked51,applied50,superset3,domain-out1|
|`870e5476bf`|销售订单列表作用域遮蔽|✅已摘(R2)|3/3文件; applied2,superset1|
|`93b3cb5998`|工单页签表单+财务取单+委外发料（大混合；批A 台账记为遗留依赖）|✅已摘(R2)|273/273文件; tracked152,applied109,superset6,domain-out6|
|`7e553638e1`|fix: 发货通知明细误用 deleted_at 过滤；侧栏图标恢复同尺寸形变|✅已摘(R2)|5/5文件; applied3,tracked2|
|`ce86f28932`|feat(sales): 销售订单与集成适配|✅已摘(R2)|5/5文件; superset2,applied2,tracked1|
|`c09c7d188b`|fix: 采购订单类型只留两项，审核记录按连线排序|✅已摘(R2)|7/7文件; applied4,tracked2,superset1|
|`05fb1f835e`|fix(db,migration): 核心API主键唯一与master_partners主|✅已摘(R2)|4/4文件; tracked2,applied2|
|`c83c6d5589`|fix(kuaizhizao): 采购入库取单支持采购订单仅回显权限|✅已摘(R2)|7/7文件; tracked5,applied2|
|`52b1abf2e3`|fix(kuaizhizao): 采购详情含税单价与浮动辅单位台账|✅已摘(R2)|11/11文件; tracked6,applied5|
|`31b1179a8e`|fix(kuaizhizao): 单据明细金额失焦仅在实际改值时反算单价|✅已摘(R2)|9/9文件; applied6,tracked3|
|`ebdc66ac4d`|fix(kuaizhizao): 采购订单金额与 documentLineAmounts|✅已摘(R2)|7/7文件; applied4,tracked3|
|`ad91f99f5e`|fix(kuaizhizao): 采购订单头表汇总与前端行价税算法对齐|✅已摘(R2)|4/4文件; tracked2,applied2|
|`6abba1dbd5`|feat(kuaizhizao): 服务采购全流程与申请转单占用修复|✅已摘(R2)|113/115文件; tracked58,applied48,superset7|
|`88b0c140f1`|feat(config,ui): 下推默认模式改草稿、客户选择快照回显与kuaiplm联动|✅已摘(R2)|6/6文件; applied4,tracked2|
|`c346cff13b`|fix(kuaizhizao): 采购入库价税与订单统一及采购链多项修复|✅已摘(R2)|26/26文件; tracked14,applied11,superset1|
|`4d124a088e`|feat(kuaizhizao): 单据行价税统一与采购入库含税算价|✅已摘(R2)|78/78文件; tracked49,applied23,domain-out4,superset2|
|`37409d3b29`|feat: 客商地址与取价、列表与物料选择体验|✅已摘(R2)|105/105文件; tracked51,applied50,superset3,domain-out1|
|`9ec209fab8`|fix(kuaiconnect,purchase): 采购订单同步预加载价税与详情未税单价|✅已摘(R2)|8/8文件; applied4,tracked4|
|`dbfcfe37a9`|fix(kuaizhizao): 销售订单列表、采购入库价税与供应商联系人|✅已摘(R2)|15/15文件; tracked9,applied6|
