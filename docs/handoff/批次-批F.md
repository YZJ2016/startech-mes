# 上游同步·批F 审批/企微/haoligo/OA/杂项

> 数据源：handoff-01 附录批次圈定 + `上游同步台账.md` 判定 + 本地提交映射 + R2 文件级 TSV 判定。
> 状态：✅已摘/已评（附本地 hash 或台账方式）｜🟡缓置（备注=领回条件）｜🔵R2 文件级已判/部分（积压清零轮，文件判定为准，逐提交不再单独评）｜⬜未评｜⏭跳过｜💀上游重写死哈希。
> 返回：[00-总账-上游同步](00-总账-上游同步.md)

共 **48** 笔：✅45 ｜ 🔵R2 3 ｜ 🟡0 ｜ ⬜0 ｜ ⏭0 ｜ 💀0

| 上游           | 主题                                            | 状态               | 备注                                            |
| ------------ | --------------------------------------------- | ---------------- | --------------------------------------------- |
|`543735cb03`|fix(approval): 条件分支后撤回本级不再断开流程|✅已摘(R2)|10/10文件; applied5,superset3,tracked2|
|`aea17a2124`|feat: 审批企微推送、采购申请表单与保养计划等多项交付|✅已摘(R2)|44/44文件; applied22,superset14,tracked8|
|`309b5d697c`|fix: 审批上一节点选分支与工单 BOM 快照|✅已摘(R2)|23/23文件; applied10,tracked7,superset6|
|`45a1c83df3`|fix(kuaiai): 对话补客户端渠道头；研发交付物字典与物料快速新建|✅已摘(R2)|11/11文件; applied7,superset2,tracked2|
|`a87490d93d`|feat: 单据行客商物料快照、产出单生产部门与考勤产线拉人|✅已摘(R2)|127/127文件; applied52,tracked52,superset23|
|`d17e5f9d8e`|feat: 快连接拆包门禁与应用中心缓存治理，修报价系列 latest 自愈|✅已摘(R2)|108/108文件; applied67,superset34,tracked7|
|`447d3ab6fd`|chore(backend): 移除入库的 haoligo OpenAPI 快照|✅已摘(R2)|1/2文件; tracked1|
|`6e218021b8`|feat: sync local changes after pulling develo|✅已摘(R2)|45/45文件; applied28,tracked12,superset4,domain-out1|
|`96703099f3`|feat(kuaioa): 月度考勤日格登记人与联动文案|✅已摘(R2)|3/3文件; applied2,tracked1|
|`64f169b12e`|fix: 样机制作书补齐编码规则页面与实体登记|✅已摘(R2)|4/4文件; tracked2,applied2|
|`1fa6e303be`|feat: 卧式产出单迁移编码规则与财务预支；前端更新日志|✅已摘(R2)|12/12文件; applied5,tracked4,superset2,domain-out1|
|`9ca16bd0f4`|fix(haoligo): 卧式产出单审计列迁移与定制更新日志、zh-CN|✅已摘(R2)|4/4文件; applied2,domain-out1,tracked1|
|`8f36dcf8f0`|fix(haoligo): 产出单部门筛选与分批回填的更新日志与文案|✅已摘(R2)|2/2文件; applied1,tracked1|
|`f9b11ec9fc`|fix(haoligo): 回填生产部门限流说明与更新日志|✅已摘(R2)|2/2文件; applied1,tracked1|
|`2878991ed4`|feat(wecom): 连接器可配公网地址，密钥编辑留空保持|✅已摘(R2)|17/17文件; applied11,tracked6|
|`9ebb4e8834`|feat: enhance API management import and dedup|✅已摘(R2)|10/10文件; applied7,superset1,domain-out1,tracked1|
|`b824636af8`|feat: 工作小组绩效权重自动均分；跨租户恢复软 FK 前缀偏移|✅已摘(R2)|7/7文件; applied6,tracked1|
|`0d563bf924`|fix(approval): 单据详情 loader 缺项不再拖垮全部审批明细|✅已摘(R2)|2/2文件; superset1,tracked1|
|`30aa384739`|fix(approval): 撤回后收敛待审脏数据，待我审列表与单据一致|🔵R2部分|4/4文件; superset2,applied1,deferred1|
|`46b49fd66c`|fix(auth): 企微 H5 OAuth 回跳固定 /mobile/ 并补部署说明|✅已摘(R2)|8/8文件; applied6,tracked2|
|`d2876621a7`|fix(mobile): 企微多应用按 URL tenant 切换组织|✅已摘(R2)|4/4文件; applied4|
|`141a3e16ee`|fix(wecom): 应用主页部署说明改为路径型 /mobile/wecom/CorpI|✅已摘(R2)|3/3文件; applied3|
|`93e1378873`|fix(wecom): 同 Corp 多应用按企微绑定反查组织并发现授权|✅已摘(R2)|5/5文件; applied4,tracked1|
|`6a270c2824`|fix(approval): 或签待办通知当前节点全部审批人|✅已摘(R2)|3/3文件; applied2,superset1|
|`bb5906b219`|feat(users): 账户列表显示企微钉钉飞书绑定图标|✅已摘(R2)|8/8文件; applied8|
|`dd68693d39`|feat(haoligo): 好力 GO 薪酬结算迁移与更新日志文案|✅已摘(R2)|5/5文件; domain-out3,applied2|
|`118e065603`|feat(frontend): 好力 GO 产出单导入宽表映射与更新日志|✅已摘(R2)|4/4文件; applied3,tracked1|
|`b22b3ac326`|fix(mobile): 记录企微 H5 退出再进不再转圈|✅已摘(R2)|2/2文件; applied2|
|`19c2eff526`|fix(mobile): 记录企微同一应用关掉再开不再转圈|✅已摘(R2)|2/2文件; applied2|
|`44520a667f`|fix(mobile): 记录企微关掉再开在任意页整页重开|✅已摘(R2)|2/2文件; applied2|
|`4613d982e6`|fix: 角色职能域保存与 PDF 打印压图重试增强|✅已摘(R2)|6/6文件; applied3,tracked3|
|`9a9a6d93c4`|fix(print): Chromium PDF 崩溃真因路径与诊断|✅已摘(R2)|6/6文件; applied4,tracked2|
|`c53c7695d1`|feat(audit,list): 审批通过可改白名单字段；报工/返工审核态与列表布局收敛|🔵R2部分|147/147文件; applied68,tracked49,superset17,domain-out7,deferred6|
|`96a3b0a9fb`|fix(audit,approval): 工具栏审核强制走弹窗；审批节点默认可改单|✅已摘(R2)|39/39文件; applied19,tracked14,domain-out6|
|`20b205a582`|fix(audit): 弹窗可填字段可选；审核 hub 底栏可滚动|✅已摘(R2)|6/6文件; applied4,superset1,tracked1|
|`493c679725`|fix(audit,approval): 一次发布生效；审核详情与跨轮执行履历|✅已摘(R2)|9/9文件; applied7,superset2|
|`b5d48662b1`|fix(funide-oa): 定制应用前端隔离契约与更新日志|✅已摘(R2)|3/3文件; applied1,tracked1,superset1|
|`934eab86ba`|fix(kuaizhizao): 其他费用立账与设备看板；企微审批深链更新日志|✅已摘(R2)|44/44文件; applied27,tracked13,domain-out3,superset1|
|`e42577ef2a`|fix: 企微采购选料权限、付款收款户与工单齐套等多项修复|✅已摘(R2)|21/21文件; applied10,domain-out6,tracked5|
|`9fc03de3ed`|fix(approval): 审批推进下一节点时通知待办与企微|🔵R2部分|17/17文件; applied11,tracked3,deferred2,superset1|
|`d096f24cbb`|feat(kuaioa): 年度工资统计与离职考勤收口的更新日志|✅已摘(R2)|2/2文件; applied2|
|`e16f2f2939`|feat(kuaizhizao): 会签返工部门链与领导通过后填报，兼采购变更收口|✅已摘(R2)|49/49文件; tracked27,applied21,superset1|
|`777aa1a468`|feat: 采购取单、企微审批卡、仓储推送与打印等多项交付|✅已摘(R2)|39/39文件; tracked21,applied16,superset2|
|`21e6b8fffe`|fix(migrate): 任职回填迁移对齐表结构无 deleted_at|✅已摘(R2)|1/1文件; tracked1|
|`ede53f7a31`|fix: 企微审批卡片软失效与图纸默认上传 200MB|✅已摘(R2)|7/7文件; applied6,tracked1|
|`1eb300325a`|feat(approval,tenant,kuaiconnect): 审核中心预览与软删复|✅已摘(R2)|59/59文件; applied32,tracked20,superset5,domain-out2|
|`3ff4985443`|feat(approval): 同人连任两级自动跳过，并修正已提交误显审核中|✅已摘(R2)|4/4文件; applied3,superset1|
|`599db61d5e`|feat: 工资结算分单迁移与好力更新日志，并修物料新建权限门控|✅已摘(R2)|7/7文件; applied4,domain-out2,tracked1|
