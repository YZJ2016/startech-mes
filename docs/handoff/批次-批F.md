# 上游同步·批F 审批/企微/haoligo/OA/杂项

> 数据源：handoff-01 附录批次圈定 + `上游同步台账.md` 判定 + 本地提交映射 + R2 文件级 TSV 判定。
> 状态：✅已摘/已评（附本地 hash 或台账方式）｜🟡缓置（备注=领回条件）｜🔵R2 文件级已判/部分（积压清零轮，文件判定为准，逐提交不再单独评）｜⬜未评｜⏭跳过｜💀上游重写死哈希。
> 返回：[00-总账-上游同步](00-总账-上游同步.md)

共 **48** 笔：✅5 ｜ 🔵R2 40 ｜ 🟡0 ｜ ⬜3 ｜ ⏭0 ｜ 💀0

| 上游 | 主题 | 状态 | 备注 |
|---|---|---|---|
| `543735cb03` | fix(approval): 条件分支后撤回本级不再断开流程 | 🔵R2部分(2/10文件) | applied,tracked |
| `aea17a2124` | feat: 审批企微推送、采购申请表单与保养计划等多项交付 | 🔵R2部分(6/44文件) | applied,tracked |
| `309b5d697c` | fix: 审批上一节点选分支与工单 BOM 快照 | 🔵R2部分(3/23文件) | applied,tracked |
| `45a1c83df3` | fix(kuaiai): 对话补客户端渠道头；研发交付物字典与物料快速新建 | 🔵R2部分(3/11文件) | applied,tracked |
| `a87490d93d` | feat: 单据行客商物料快照、产出单生产部门与考勤产线拉人 | 🔵R2部分(11/127文件) | applied,deferred,tracked |
| `d17e5f9d8e` | feat: 快连接拆包门禁与应用中心缓存治理，修报价系列 latest 自愈 | 🔵R2部分(53/108文件) | applied,domain-out,superset,tr |
| `447d3ab6fd` | chore(backend): 移除入库的 haoligo OpenAPI 快照 | ⬜未评(文件已见1/2) |  |
| `6e218021b8` | feat: sync local changes after pulling develo | 🔵R2部分(9/45文件) | applied,domain-out,superset,tr |
| `96703099f3` | feat(kuaioa): 月度考勤日格登记人与联动文案 | 🔵R2部分(2/3文件) | applied,tracked |
| `64f169b12e` | fix: 样机制作书补齐编码规则页面与实体登记 | 🔵R2部分(2/4文件) | applied,tracked |
| `1fa6e303be` | feat: 卧式产出单迁移编码规则与财务预支；前端更新日志 | 🔵R2部分(6/12文件) | applied,deferred,domain-out,su |
| `9ca16bd0f4` | fix(haoligo): 卧式产出单审计列迁移与定制更新日志、zh-CN | 🔵R2部分(3/4文件) | applied,domain-out,tracked |
| `8f36dcf8f0` | fix(haoligo): 产出单部门筛选与分批回填的更新日志与文案 | 🔵R2部分(1/2文件) | applied,tracked |
| `f9b11ec9fc` | fix(haoligo): 回填生产部门限流说明与更新日志 | 🔵R2部分(1/2文件) | applied,tracked |
| `2878991ed4` | feat(wecom): 连接器可配公网地址，密钥编辑留空保持 | 🔵R2部分(2/17文件) | applied,tracked |
| `9ebb4e8834` | feat: enhance API management import and dedup | 🔵R2部分(3/10文件) | applied,domain-out,tracked |
| `b824636af8` | feat: 工作小组绩效权重自动均分；跨租户恢复软 FK 前缀偏移 | 🔵R2部分(2/7文件) | applied,tracked |
| `0d563bf924` | fix(approval): 单据详情 loader 缺项不再拖垮全部审批明细 | ⬜未评(文件已见2/2) |  |
| `30aa384739` | fix(approval): 撤回后收敛待审脏数据，待我审列表与单据一致 | 🔵R2部分(1/4文件) | applied,tracked |
| `46b49fd66c` | fix(auth): 企微 H5 OAuth 回跳固定 /mobile/ 并补部署说明 | 🔵R2部分(5/8文件) | applied,tracked |
| `d2876621a7` | fix(mobile): 企微多应用按 URL tenant 切换组织 | 🔵R2文件级已判 | applied |
| `141a3e16ee` | fix(wecom): 应用主页部署说明改为路径型 /mobile/wecom/CorpI | 🔵R2部分(2/3文件) | applied,tracked |
| `93e1378873` | fix(wecom): 同 Corp 多应用按企微绑定反查组织并发现授权 | 🔵R2部分(2/5文件) | applied,tracked |
| `6a270c2824` | fix(approval): 或签待办通知当前节点全部审批人 | 🔵R2部分(2/3文件) | applied,tracked |
| `bb5906b219` | feat(users): 账户列表显示企微钉钉飞书绑定图标 | 🔵R2部分(5/8文件) | applied,tracked |
| `dd68693d39` | feat(haoligo): 好力 GO 薪酬结算迁移与更新日志文案 | 🔵R2部分(4/5文件) | applied,domain-out |
| `118e065603` | feat(frontend): 好力 GO 产出单导入宽表映射与更新日志 | 🔵R2部分(2/4文件) | applied,tracked |
| `b22b3ac326` | fix(mobile): 记录企微 H5 退出再进不再转圈 | 🔵R2文件级已判 | applied |
| `19c2eff526` | fix(mobile): 记录企微同一应用关掉再开不再转圈 | 🔵R2文件级已判 | applied |
| `44520a667f` | fix(mobile): 记录企微关掉再开在任意页整页重开 | 🔵R2文件级已判 | applied |
| `4613d982e6` | fix: 角色职能域保存与 PDF 打印压图重试增强 | ✅已评(簇内,台账有述) |  |
| `9a9a6d93c4` | fix(print): Chromium PDF 崩溃真因路径与诊断 | ✅已评(簇内,台账有述) |  |
| `c53c7695d1` | feat(audit,list): 审批通过可改白名单字段；报工/返工审核态与列表布局收敛 | 🔵R2部分(11/147文件) | applied,superset,tracked |
| `96a3b0a9fb` | fix(audit,approval): 工具栏审核强制走弹窗；审批节点默认可改单 | 🔵R2部分(8/39文件) | applied,deferred,tracked |
| `20b205a582` | fix(audit): 弹窗可填字段可选；审核 hub 底栏可滚动 | 🔵R2部分(3/6文件) | applied,superset,tracked |
| `493c679725` | fix(audit,approval): 一次发布生效；审核详情与跨轮执行履历 | 🔵R2部分(3/9文件) | applied,superset,tracked |
| `b5d48662b1` | fix(funide-oa): 定制应用前端隔离契约与更新日志 | 🔵R2部分(2/3文件) | applied,superset,tracked |
| `934eab86ba` | fix(kuaizhizao): 其他费用立账与设备看板；企微审批深链更新日志 | 🔵R2部分(10/44文件) | applied,deferred,domain-out,su |
| `e42577ef2a` | fix: 企微采购选料权限、付款收款户与工单齐套等多项修复 | 🔵R2部分(4/21文件) | applied,tracked |
| `9fc03de3ed` | fix(approval): 审批推进下一节点时通知待办与企微 | 🔵R2部分(4/17文件) | applied,deferred,tracked |
| `d096f24cbb` | feat(kuaioa): 年度工资统计与离职考勤收口的更新日志 | 🔵R2文件级已判 | applied |
| `e16f2f2939` | feat(kuaizhizao): 会签返工部门链与领导通过后填报，兼采购变更收口 | ✅已摘 `9a7bf76c68` |  |
| `777aa1a468` | feat: 采购取单、企微审批卡、仓储推送与打印等多项交付 | ✅已摘 `b7b8ef7d20` |  |
| `21e6b8fffe` | fix(migrate): 任职回填迁移对齐表结构无 deleted_at | ⬜未评(文件已见1/1) |  |
| `ede53f7a31` | fix: 企微审批卡片软失效与图纸默认上传 200MB | 🔵R2部分(3/7文件) | applied,tracked |
| `1eb300325a` | feat(approval,tenant,kuaiconnect): 审核中心预览与软删复 | ✅部分 | **引擎+采购 hooks C 子集已摘 `c9edcdc2cd`（复核 `8745468 |
| `3ff4985443` | feat(approval): 同人连任两级自动跳过，并修正已提交误显审核中 | 🔵R2部分(2/4文件) | applied,tracked |
| `599db61d5e` | feat: 工资结算分单迁移与好力更新日志，并修物料新建权限门控 | 🔵R2部分(3/7文件) | applied,tracked |
