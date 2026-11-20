# 上游同步·批D1/D2 数据互通（金蝶/同步/库位）

> 数据源：handoff-01 附录批次圈定 + `上游同步台账.md` 判定 + 本地提交映射 + R2 文件级 TSV 判定。
> 状态：✅已摘/已评（附本地 hash 或台账方式）｜🟡缓置（备注=领回条件）｜🔵R2 文件级已判/部分（积压清零轮，文件判定为准，逐提交不再单独评）｜⬜未评｜⏭跳过｜💀上游重写死哈希。
> 返回：[00-总账-上游同步](00-总账-上游同步.md)

共 **76** 笔：✅23 ｜ 🔵R2 52 ｜ 🟡0 ｜ ⬜1 ｜ ⏭0 ｜ 💀0

| 上游 | 主题 | 状态 | 备注 |
|---|---|---|---|
| `2c945a39fb` | feat: 苍穹采购入库出站、仓库 getList 同步与设备/字段权限等联调改动 | ✅已评(D 子集+适配) |  |
| `2e8ecad990` | feat: 苍穹销售出库/其他出库/盘盈盘亏出站与企微同步推送 | ✅已评(D 子集+适配) |  |
| `4bd853a94f` | feat(inbound): 采购入库金蝶外推字段、空白建单与采购中心超时修复 | ✅已评(D 子集+适配（混合 4) |  |
| `d7966d33c6` | fix: 采购入库外推门禁与苍穹仓库列表预览 | ✅已评(D 子集) |  |
| `d7da8e14f8` | fix: 苍穹组织取连接器、物料单位禁全表扫、加速 dist 发布 | ✅已评(D 子集) |  |
| `905787348a` | feat: 质检国标抽检、仓库同步记录与数据互通运行历史 | ✅已评(D 子集+适配（混合 6) |  |
| `a0b353ce7e` | feat(warehouse): 其他入出库金蝶外推与同步运行历史对齐采购入库 | ✅已评(摘取+适配（混合 113) |  |
| `994bc9a312` | fix(sync): 修复苍穹物料同步 request_body 为 None 时合并崩溃 | ✅已评(摘取（依赖先行）) |  |
| `5d65aa9fa4` | feat(master-data): 客户伙伴类型/业务职能与供需同步字段 | 🔵R2部分(5/22文件) | applied,tracked |
| `37e5213a50` | fix: 苍穹 getcustomer 测试漏导入；客户同步按组织过滤 | ✅已评(摘取+适配（客户 org) |  |
| `a0ccb13d08` | feat: 仓储金蝶成品/领料外推、其他费用申请与采购部门字段 | 🔵R2部分(36/141文件) | applied,deferred,superset,trac |
| `ef05d62736` | fix(master-data): 有仓库读权限即可拉库位/库区下拉 | 🔵R2部分(1/4文件) | superset,tracked |
| `48b0341563` | fix: 仓位 getList 保留空 data，并登记工程图纸菜单图标 | 🔵R2部分(3/5文件) | applied |
| `520cde9e49` | feat: 库位金蝶同步、批次库存状态列与仓位外推对齐 | 🔵R2部分(25/71文件) | applied,deferred,superset,trac |
| `9f50375a01` | fix(master-data): 补全物料多单位同步入口到物料管理页 | 🔵R2文件级已判 | applied |
| `0550761f59` | improve(warehouse): 采购入库 uni-wh 明细与库位批号 UX | 🔵R2部分(6/10文件) | applied,deferred,superset,trac |
| `7d1f000361` | fix(kuaizhizao): 发货通知仓库下推出库单时 defer 库位校验 | 🔵R2文件级已判 | applied,deferred |
| `2e90d9a7ae` | fix(kuaizhizao): 工序委外流程、仓储库位与 IQC 自动下推 | 🔵R2部分(15/50文件) | applied,deferred,superset,trac |
| `fc12d17278` | fix(sync): 苍穹增量把 modifytime 水位打进源端，避免全量翻页拖死 | 🔵R2部分(2/5文件) | applied,tracked |
| `3021870683` | fix(sync): 仓储推送金蝶从接口样例正确读取 data 单据头 | 🔵R2部分(3/4文件) | applied,tracked |
| `282f15a0fd` | fix(kuaizhizao): 采购入库外推仓位、批号同步与编辑表单 | 🔵R2部分(16/36文件) | applied,deferred,superset,trac |
| `3f8d606f7c` | fix(sync): 加载采购入库预设时保留已填编码 | 🔵R2部分(5/6文件) | applied,tracked |
| `43f1fef415` | fix: 收付款草稿随核销下调，并修正审核撤回与菜单同步提醒 | 🔵R2部分(4/13文件) | applied,tracked |
| `7a4f8e4230` | improve(qms): 体系文件导航与内审能力，放宽菜单同步提示 | 🔵R2部分(7/21文件) | applied,superset,tracked |
| `6c83770a65` | feat(sync): 销售订单 push-binding 与销售出库确认外推 | 🔵R2部分(10/19文件) | applied,deferred,superset,trac |
| `633a054eee` | fix(kingdee): 仓储外推从采购入库继承库存状态与领用人字段 | 🔵R2部分(2/3文件) | applied,tracked |
| `15c4dc1de5` | fix: 金蝶外推审核、费用申请引用加载与协作分类扩展 | 🔵R2部分(8/53文件) | applied,tracked |
| `75046d4f03` | improve(kingdee): 其他入库外推组包对齐开放平台与其他出库 | 🔵R2部分(5/8文件) | applied,tracked |
| `bdcd5fa735` | fix(kingdee): 其他入库无库管组不写库管员，outinv 仅显式配置 | 🔵R2部分(1/2文件) | applied,tracked |
| `3ba3d049c0` | fix(kingdee): 其他出库/生产领料外推补全领用人写键 | 🔵R2部分(3/5文件) | applied,tracked |
| `607939c9a7` | fix: 其他入库出站绑定路由顺序导致外推校验失败 | 🔵R2文件级已判 | applied |
| `58e6ab9e4d` | fix: 金蝶其他入库明细补齐 outinv 库存类型状态 | 🔵R2部分(4/5文件) | applied,tracked |
| `093512788c` | feat(kuaiconnect): 金蝶云星空物料同步支持组织范围与分组适配 | ✅已评(摘取+适配) |  |
| `11632b238b` | feat: 金蝶仓储外推链路增强与物料组织范围展示 | 🔵R2部分(11/16文件) | applied,deferred,superset,trac |
| `7fa73e053a` | feat(integration): 金蝶星空/银河物料同步与集成适配 | ✅已评(摘取+适配) |  |
| `e817c50d24` | feat(integration): 金蝶银河物料同步适配与部署脚本调整 | ✅已评(摘取) |  |
| `fdcfdd500b` | feat(integration): 金蝶银河物料分组与集成配置优化 | ✅已评(摘取+适配) |  |
| `22e0787317` | feat: 仓储出入库 Hub、金蝶成品入库外推与接口库契约 | ✅已评(簇内,台账有述) |  |
| `91c8157e1e` | feat: 采购入库外推支持强制重推、是否推送开关与详情状态 | ✅已评(摘取+适配) |  |
| `05d001dd6d` | feat: 仓储双计量与金蝶外推补审、部门批量启停与组织同步 | 🔵R2部分(38/130文件) | applied,deferred,superset,trac |
| `b164bfd1db` | feat(kuaiconnect): 销售订单同步与界面优化 | 🔵R2文件级已判 | applied |
| `431de9ea9c` | feat(kuaiconnect): 组织范围与界面优化 | 🔵R2文件级已判 | applied |
| `2485a66bcb` | feat(kuaiconnect): 入站同步与界面优化 | 🔵R2部分(5/10文件) | applied,tracked |
| `32cf90c8a2` | feat(integration): 金蝶物料同步与出库逻辑优化 | 🔵R2部分(29/44文件) | applied,deferred,superset,trac |
| `86e3d8187c` | feat(kuaiconnect): 出库同步与界面优化 | 🔵R2部分(6/22文件) | applied,deferred,superset,trac |
| `e9726667b1` | feat(kuaiconnect): 出库同步优化 | 🔵R2部分(3/8文件) | applied,deferred,tracked |
| `050638b809` | feat(kuaiconnect): 销售出库同步与界面优化 | 🔵R2部分(4/17文件) | applied,deferred,tracked |
| `7ebfacd75e` | feat: kuaiconnect 金蝶单据推送与集成适配 | 🔵R2部分(29/132文件) | applied,deferred,superset,trac |
| `69fbb7cb35` | fix(sync,ui): 物料同步空源提示与物料管理/超时中间件修正 | 🔵R2部分(4/5文件) | applied,tracked |
| `df7d635797` | feat(sync,ui): 同步绑定引用整合与前端同步/物料/BOM等页面优化 | ✅已评(D 子集+适配) |  |
| `7dad32983e` | fix(kuaiconnect): 苍穹出入库接口库补齐提交审核与盘点操作套 | 🔵R2部分(4/5文件) | applied,tracked |
| `42fb8fe9f4` | fix(warehouse,gl,kuaiconnect): 出库权限与出库人、退料行仓、 | 🔵R2部分(14/26文件) | applied,deferred,superset,trac |
| `d8afe91cad` | fix(web): 出库 Hub、BOM 弹窗与销售直推工单等多项修复 | ✅已评(簇内,台账有述) |  |
| `fd18de759f` | fix(document-push): 出库外推绑定行为显示确认出库 | 🔵R2部分(2/3文件) | applied,tracked |
| `ff71edee8d` | fix(warehouse,kingdee): 去掉无软删除明细的 deleted_at | 🔵R2部分(4/5文件) | applied,deferred,tracked |
| `361337a31a` | fix(approval,warehouse,document-push): 组织审批锚定 | 🔵R2部分(7/25文件) | applied,deferred,tracked |
| `f40f54e336` | fix(kuaizhizao): 头表价税与明细对齐，同步绑定调度窗 | ✅已评(摘取+适配（混合 57 ) |  |
| `e1340cf6a8` | fix(kuaizhizao): 即时库存单计量按行留空副单位列 | 🔵R2部分(1/2文件) | applied,tracked |
| `6b233ed3f6` | fix(kuaizhizao): 红框采购入库 HTML 模板补库位列 | 🔵R2部分(2/5文件) | applied,tracked |
| `44490cf018` | fix(kuaizhizao): 红框入库单列序为金额在库位前且数量两位 | ⬜未评 |  |
| `1e00eb3ad7` | fix(kuaiconnect,web): 金蝶仓存补提交审核与取单勾选收口 | 🔵R2部分(5/10文件) | applied,deferred,tracked |
| `e896023052` | fix(kuaiconnect): 金蝶出库预检与即时库存按仓位对齐 | 🔵R2部分(4/8文件) | applied,tracked |
| `7091b700be` | fix(kuaizhizao): 其他出库编辑用完整表单并补强金蝶一致能力 | 🔵R2部分(2/11文件) | applied,tracked |
| `2b1ffa48ae` | fix(kuaizhizao): 仓储编辑金蝶 batchUpdate 全接入并修其他出库 | 🔵R2部分(9/12文件) | applied,deferred,superset,trac |
| `76b62bf6ec` | fix(warehouse): 即时库存同步累加、仓位关系仓库分批与出库编辑 | 🔵R2部分(3/8文件) | applied,tracked |
| `e34110de2d` | fix(kuaiconnect): 出库金蝶可用预检按库位名称匹配 | 🔵R2文件级已判 | applied |
| `f9465b63cb` | fix: 金蝶外推单号组织前缀、同步暂停与采购入库打印换行 | 🔵R2部分(12/33文件) | applied,deferred,superset,trac |
| `d32d1e031d` | fix: 税率1%归一化与采购入库金蝶脏辅助单位 | ✅已摘 `a2149d428a` |  |
| `41c3a02f72` | feat(inbound): 入库确认库位自动带入、收货人默认与明细库位编辑 | 🔵R2部分(5/9文件) | applied,tracked |
| `fa9fa79b42` | fix(sync): 物料全量同步不再对未命中行停用/软删 | 🔵R2文件级已判 | applied |
| `73b89087b0` | fix(sync): 补齐同步服务对 schedule window 解析函数的 impo | 🔵R2部分(5/7文件) | applied,superset,tracked |
| `c588744e04` | fix(kuaizhizao): 生产入库外推改绑成品入库并统一税率%录入 | ✅已评(C 子集) |  |
| `959f65b743` | feat(sync): 数据互通同步对比，并修其他出库数量与物料1%税率 | ✅已评(绿区补摘) |  |
| `4a7f11604c` | fix(kuaizhizao): 采购入库金额写路径与物料快建开关、同步对比组件级 | ✅已评(C 子集) |  |
| `80da6a45f8` | fix(sync): 金蝶外推单据号统一走 resolve_kingdee_local_b | 🔵R2部分(4/11文件) | applied,tracked |
| `4ba2d15ae8` | feat(sync): 入站同步仅映射字段更新契约、金蝶供应商启用过滤与查询修正 | ✅已评(摘取+适配（同步写入契约) |  |
