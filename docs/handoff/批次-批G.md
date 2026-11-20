# 上游同步·批G deploy/ops/仓库治理/造数收尾

> 数据源：handoff-01 附录批次圈定 + `上游同步台账.md` 判定 + 本地提交映射 + R2 文件级 TSV 判定。
> 状态：✅已摘/已评（附本地 hash 或台账方式）｜🟡缓置（备注=领回条件）｜🔵R2 文件级已判/部分（积压清零轮，文件判定为准，逐提交不再单独评）｜⬜未评｜⏭跳过｜💀上游重写死哈希。
> 返回：[00-总账-上游同步](00-总账-上游同步.md)

共 **59** 笔：✅59 ｜ 🔵R2 0 ｜ 🟡0 ｜ ⬜0 ｜ ⏭0 ｜ 💀0

| 上游           | 主题                                            | 状态              | 备注                         |
| ------------ | --------------------------------------------- | --------------- | -------------------------- |
|`c7fa35d334`|chore: 依赖口径清理与看板图表懒加载韧性|✅已摘(R2)|17/17文件; applied12,superset3,tracked2|
|`2c2c2c6848`|chore(aoci): 修复合并冲突残留并补齐合入侧索引|✅已摘(R2)|2/2文件; superset2|
|`54fec48d47`|chore: workspace compose 同步与 PLM/福尼特更新日志|✅已摘(R2)|6/6文件; applied5,tracked1|
|`2182a09f88`|chore(aoci): 合入后补齐 missing/stale 索引|✅已摘(R2)|2/2文件; superset2|
|`41fcf29a17`|fix: 修复 platformUpdateLog 合并残留多余大括号|✅已摘(R2)|2/2文件; superset1,applied1|
|`77448fd970`|chore: 流程造数与设备运维造数移出仓库（本机保留）|✅已摘(R2)|31/31文件; superset23,tracked6,applied2|
|`3ab10aefc2`|docs: 推送 SOP 按分流重写，死代码自检降为可选|✅已摘(R2)|4/4文件; superset3,tracked1|
|`992f191c27`|chore(fast-deploy): legacy 主仓 dist 提交使用 git a|✅已摘(R2)|1/1文件; tracked1|
|`f978467013`|improve(fast-deploy): 生产向导可选 dist 拉取或本机构建|✅已摘(R2)|7/7文件; tracked3,applied2,superset1,domain-out1|
|`577b7cad81`|improve(fast-deploy): 向导一步三选一并通用化文案|✅已摘(R2)|7/7文件; tracked4,superset1,domain-out1,applied1|
|`8c4db8cdad`|fix(fast-deploy): dist 仓 commit 继承主仓作者并支持跳过 n|✅已摘(R2)|2/2文件; tracked2|
|`76fcb4cfea`|chore(aoci): 主仓停止跟踪 .aoci 治理 JSON|✅已摘(R2)|3/4文件; superset2,tracked1|
|`90f3593703`|chore(repo): 收窄 Git 跟踪范围并加索引漂移扫描|✅已摘(R2)|9/11文件; superset8,tracked1|
|`5c313c150c`|chore(aoci): 主仓完全停止跟踪 .aoci 目录|✅已摘(R2)|3/5文件; superset2,tracked1|
|`1bca62aecf`|chore(repo): 主仓停止跟踪 .cursor、AGENTS.md、.gitatt|✅已摘(R2)|106/207文件; superset105,tracked1|
|`310daba2bf`|chore(fast-deploy): AOCI 仓同步 AGENTS/.cursor 与|✅已摘(R2)|3/3文件; tracked2,domain-out1|
|`c91b13c20c`|docs: 更新微信群截图素材|✅已摘(R2)|1/1文件; domain-out1|
|`09300569ac`|feat(fast-deploy): 适配 CTyunOS/openEuler 系安装与|✅已摘(R2)|4/4文件; domain-out2,superset1,tracked1|
|`521f06b72f`|fix(fast-deploy): CTyunOS 上 Caddy 改走官方静态包|✅已摘(R2)|4/4文件; domain-out2,superset1,tracked1|
|`e1650484c4`|fix(fast-deploy): Caddy 静态包优先国内镜像下载|✅已摘(R2)|4/4文件; superset1,domain-out1,tracked1,applied1|
|`995b74b491`|fix(deploy): Windows 按用户安装 Node 后环境检测可识别|✅已摘(R2)|2/2文件; tracked1,applied1|
|`f0f05414c6`|fix(deploy): Windows uv sync 预装 Python 3.11 并|✅已摘(R2)|3/3文件; tracked3|
|`47cb9831a8`|docs: 对齐分仓推送 SOP 与 push.sh 默认行为|✅已摘(R2)|2/2文件; superset1,tracked1|
|`bf97d3a44a`|chore(docs): 更新微信群截图并停止跟踪内部文档|✅已摘(R2)|35/35文件; superset33,tracked1,domain-out1|
|`ffa55326df`|docs: 记录移动端登录鉴权回退到 10-31|✅已摘(R2)|2/2文件; applied2|
|`9093398b50`|fix(deploy): 一般模式恢复蓝绿，低配关闭蓝绿|✅已摘(R2)|3/3文件; tracked2,applied1|
|`0368c115f6`|fix(deploy): 一般模式 update 默认蓝绿（含运维台非交互）|✅已摘(R2)|4/4文件; tracked3,applied1|
|`99c960026c`|fix(fast-deploy): repair Windows dependency i|✅已摘(R2)|6/6文件; applied3,tracked2,domain-out1|
|`34b1a1d3ed`|fix(fast-deploy): Windows uv detection and Ca|✅已摘(R2)|3/3文件; tracked2,applied1|
|`5f9690fc5f`|fix(fast-deploy): avoid PowerShell $args shad|✅已摘(R2)|1/1文件; applied1|
|`27552972c4`|fix(deploy): Ubuntu 无 pip 时装 uv 与 LOCALAPPDAT|✅已摘(R2)|1/1文件; tracked1|
|`d827731540`|fix(deploy): 迁移与 uvicorn 改 python -m 避开 uv tr|✅已摘(R2)|6/6文件; tracked5,applied1|
|`a1c2a8d424`|fix(deploy): aerich 迁移改用 python -m aerich.cli|✅已摘(R2)|4/4文件; tracked3,applied1|
|`4f572a2431`|fix(deploy): Windows 跳过 PATH 中 Linux 版 Caddy|✅已摘(R2)|1/1文件; tracked1|
|`d003ff3404`|fix(deploy): 蓝绿 backend 健康等待随 worker 加长|✅已摘(R2)|3/3文件; tracked3|
|`18cd0581d9`|fix(deploy): Taskiq 启动改 python -m taskiq 避开 u|✅已摘(R2)|6/6文件; domain-out3,tracked2,applied1|
|`8700bd8a16`|revert(deploy): 恢复 fast-deploy 至 11-05 末版 (5f|✅已摘(R2)|11/11文件; tracked6,domain-out3,applied2|
|`351fe4815e`|revert(deploy): 恢复 fast-deploy 至 11-04 日快照 (0|✅已摘(R2)|6/6文件; tracked4,domain-out1,applied1|
|`0d021ef663`|revert(deploy): 移除 11-05 新增的 promote-prod-bra|✅已摘(R2)|1/1文件; superset1|
|`489fb03d8a`|fix(deploy): Windows 识别可用 uv，不用 11-05 install|✅已摘(R2)|1/1文件; tracked1|
|`1821d9dfb7`|fix(deploy): Windows 识别 Roaming Python312 Scr|✅已摘(R2)|2/2文件; tracked1,applied1|
|`c05a1f0f33`|fix(deploy): 迁移改用 python -m aerich.cli 避开 uv|✅已摘(R2)|3/3文件; tracked2,applied1|
|`34177331ca`|fix(deploy): 迁移直调 .venv python，不再 uv run|✅已摘(R2)|2/2文件; tracked2|
|`fd25330958`|fix(deploy): Windows 全站绕过 uv run，直调 .venv Pyt|✅已摘(R2)|3/3文件; tracked3|
|`1cd3a1dfeb`|fix(deploy): Windows 直调 venv 时去掉多余 python 参数|✅已摘(R2)|1/1文件; tracked1|
|`f26a029719`|fix(deploy): Windows 跳过 PATH 上 Linux 版 caddy|✅已摘(R2)|1/1文件; tracked1|
|`08ed0e510f`|fix(deploy): Windows Caddy 下载修复 curl 调用与 IWR|✅已摘(R2)|1/1文件; applied1|
|`83a29492cf`|fix(deploy): update 时保留 fast-deploy/.tools 便携|✅已摘(R2)|3/3文件; tracked2,applied1|
|`8a0f731a42`|fix(deploy): Windows Caddy 改存主仓外 riveredge-ru|✅已摘(R2)|5/5文件; tracked3,domain-out1,applied1|
|`ab912e4c14`|fix(deploy): Windows Caddy 国内优先山大 Release 镜像|✅已摘(R2)|2/2文件; tracked1,applied1|
|`aa7d181320`|fix(deploy): install-component.ps1 Caddy 错误文案|✅已摘(R2)|1/1文件; applied1|
|`c16cf35d1c`|fix(deploy): 锁定 Windows Caddy 唯一落点 riveredge-|✅已摘(R2)|4/4文件; tracked3,applied1|
|`95efae8f6d`|fix(deploy): 撤回 riveredge-runtime，Caddy 固定 fa|✅已摘(R2)|5/5文件; tracked3,domain-out1,applied1|
|`454e306f9a`|fix(deploy): Windows 不 git clean；禁止 install 覆|✅已摘(R2)|4/4文件; tracked3,applied1|
|`0ea3994534`|fix(deploy): 移除未核实的 SDU Caddy 镜像，优先 ghproxy.n|✅已摘(R2)|3/3文件; tracked1,domain-out1,applied1|
|`8908591c5f`|chore(docs): 更新微信交流群截图|✅已摘(R2)|1/1文件; domain-out1|
|`12550024bb`|fix(migrate,deploy): 报工/返工 review_status 列幂等与|✅已摘(R2)|3/3文件; applied3|
|`707700c8d0`|fix(deploy): install-web-dist 同步刷新 dist-live，|✅已摘(R2)|2/2文件; tracked2|
|`220d2ce271`|fix(deploy): 低配机后端健康检查超时改为 360s|✅已摘(R2)|3/3文件; tracked2,applied1|
