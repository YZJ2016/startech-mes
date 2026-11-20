# 上游同步·批G deploy/ops/仓库治理/造数收尾

> 数据源：handoff-01 附录批次圈定 + `上游同步台账.md` 判定 + 本地提交映射 + R2 文件级 TSV 判定。
> 状态：✅已摘/已评（附本地 hash 或台账方式）｜🟡缓置（备注=领回条件）｜🔵R2 文件级已判/部分（积压清零轮，文件判定为准，逐提交不再单独评）｜⬜未评｜⏭跳过｜💀上游重写死哈希。
> 返回：[00-总账-上游同步](00-总账-上游同步.md)

共 **59** 笔：✅0 ｜ 🔵R2 35 ｜ 🟡0 ｜ ⬜24 ｜ ⏭0 ｜ 💀0

| 上游 | 主题 | 状态 | 备注 |
|---|---|---|---|
| `c7fa35d334` | chore: 依赖口径清理与看板图表懒加载韧性 | 🔵R2部分(4/17文件) | applied,tracked |
| `2c2c2c6848` | chore(aoci): 修复合并冲突残留并补齐合入侧索引 | ⬜未评(文件已见2/2) |  |
| `54fec48d47` | chore: workspace compose 同步与 PLM/福尼特更新日志 | 🔵R2部分(2/6文件) | applied,tracked |
| `2182a09f88` | chore(aoci): 合入后补齐 missing/stale 索引 | ⬜未评(文件已见2/2) |  |
| `41fcf29a17` | fix: 修复 platformUpdateLog 合并残留多余大括号 | 🔵R2部分(1/2文件) | applied,tracked |
| `77448fd970` | chore: 流程造数与设备运维造数移出仓库（本机保留） | 🔵R2部分(2/31文件) | applied,tracked |
| `3ab10aefc2` | docs: 推送 SOP 按分流重写，死代码自检降为可选 | ⬜未评(文件已见4/4) |  |
| `992f191c27` | chore(fast-deploy): legacy 主仓 dist 提交使用 git a | ⬜未评(文件已见1/1) |  |
| `f978467013` | improve(fast-deploy): 生产向导可选 dist 拉取或本机构建 | 🔵R2部分(3/7文件) | applied,domain-out,tracked |
| `577b7cad81` | improve(fast-deploy): 向导一步三选一并通用化文案 | 🔵R2部分(2/7文件) | applied,domain-out,tracked |
| `8c4db8cdad` | fix(fast-deploy): dist 仓 commit 继承主仓作者并支持跳过 n | ⬜未评(文件已见2/2) |  |
| `76fcb4cfea` | chore(aoci): 主仓停止跟踪 .aoci 治理 JSON | ⬜未评(文件已见3/4) |  |
| `90f3593703` | chore(repo): 收窄 Git 跟踪范围并加索引漂移扫描 | ⬜未评(文件已见1/11) |  |
| `5c313c150c` | chore(aoci): 主仓完全停止跟踪 .aoci 目录 | ⬜未评(文件已见3/5) |  |
| `1bca62aecf` | chore(repo): 主仓停止跟踪 .cursor、AGENTS.md、.gitatt | ⬜未评(文件已见91/207) |  |
| `310daba2bf` | chore(fast-deploy): AOCI 仓同步 AGENTS/.cursor 与 | 🔵R2部分(1/3文件) | domain-out,tracked |
| `c91b13c20c` | docs: 更新微信群截图素材 | 🔵R2文件级已判 | domain-out |
| `09300569ac` | feat(fast-deploy): 适配 CTyunOS/openEuler 系安装与 | 🔵R2部分(2/4文件) | domain-out,tracked |
| `521f06b72f` | fix(fast-deploy): CTyunOS 上 Caddy 改走官方静态包 | 🔵R2部分(2/4文件) | domain-out,tracked |
| `e1650484c4` | fix(fast-deploy): Caddy 静态包优先国内镜像下载 | 🔵R2部分(2/4文件) | applied,domain-out,tracked |
| `995b74b491` | fix(deploy): Windows 按用户安装 Node 后环境检测可识别 | 🔵R2部分(1/2文件) | applied,tracked |
| `f0f05414c6` | fix(deploy): Windows uv sync 预装 Python 3.11 并 | ⬜未评(文件已见3/3) |  |
| `47cb9831a8` | docs: 对齐分仓推送 SOP 与 push.sh 默认行为 | ⬜未评(文件已见1/2) |  |
| `bf97d3a44a` | chore(docs): 更新微信群截图并停止跟踪内部文档 | 🔵R2部分(1/35文件) | domain-out,tracked |
| `ffa55326df` | docs: 记录移动端登录鉴权回退到 10-31 | 🔵R2文件级已判 | applied |
| `9093398b50` | fix(deploy): 一般模式恢复蓝绿，低配关闭蓝绿 | 🔵R2部分(1/3文件) | applied,tracked |
| `0368c115f6` | fix(deploy): 一般模式 update 默认蓝绿（含运维台非交互） | 🔵R2部分(1/4文件) | applied,tracked |
| `99c960026c` | fix(fast-deploy): repair Windows dependency i | 🔵R2部分(4/6文件) | applied,domain-out,tracked |
| `34b1a1d3ed` | fix(fast-deploy): Windows uv detection and Ca | 🔵R2部分(1/3文件) | applied,tracked |
| `5f9690fc5f` | fix(fast-deploy): avoid PowerShell $args shad | 🔵R2文件级已判 | applied |
| `27552972c4` | fix(deploy): Ubuntu 无 pip 时装 uv 与 LOCALAPPDAT | ⬜未评(文件已见1/1) |  |
| `d827731540` | fix(deploy): 迁移与 uvicorn 改 python -m 避开 uv tr | ⬜未评(文件已见5/6) |  |
| `a1c2a8d424` | fix(deploy): aerich 迁移改用 python -m aerich.cli | ⬜未评(文件已见3/4) |  |
| `4f572a2431` | fix(deploy): Windows 跳过 PATH 中 Linux 版 Caddy | ⬜未评(文件已见1/1) |  |
| `d003ff3404` | fix(deploy): 蓝绿 backend 健康等待随 worker 加长 | ⬜未评(文件已见3/3) |  |
| `18cd0581d9` | fix(deploy): Taskiq 启动改 python -m taskiq 避开 u | 🔵R2部分(3/6文件) | domain-out,tracked |
| `8700bd8a16` | revert(deploy): 恢复 fast-deploy 至 11-05 末版 (5f | 🔵R2部分(3/11文件) | domain-out,tracked |
| `351fe4815e` | revert(deploy): 恢复 fast-deploy 至 11-04 日快照 (0 | 🔵R2部分(2/6文件) | applied,domain-out,tracked |
| `0d021ef663` | revert(deploy): 移除 11-05 新增的 promote-prod-bra | ⬜未评(文件已见1/1) |  |
| `489fb03d8a` | fix(deploy): Windows 识别可用 uv，不用 11-05 install | ⬜未评(文件已见1/1) |  |
| `1821d9dfb7` | fix(deploy): Windows 识别 Roaming Python312 Scr | 🔵R2部分(1/2文件) | applied,tracked |
| `c05a1f0f33` | fix(deploy): 迁移改用 python -m aerich.cli 避开 uv | ⬜未评(文件已见2/3) |  |
| `34177331ca` | fix(deploy): 迁移直调 .venv python，不再 uv run | ⬜未评(文件已见2/2) |  |
| `fd25330958` | fix(deploy): Windows 全站绕过 uv run，直调 .venv Pyt | ⬜未评(文件已见3/3) |  |
| `1cd3a1dfeb` | fix(deploy): Windows 直调 venv 时去掉多余 python 参数 | ⬜未评(文件已见1/1) |  |
| `f26a029719` | fix(deploy): Windows 跳过 PATH 上 Linux 版 caddy | ⬜未评(文件已见1/1) |  |
| `08ed0e510f` | fix(deploy): Windows Caddy 下载修复 curl 调用与 IWR | 🔵R2文件级已判 | applied |
| `83a29492cf` | fix(deploy): update 时保留 fast-deploy/.tools 便携 | 🔵R2部分(1/3文件) | applied,tracked |
| `8a0f731a42` | fix(deploy): Windows Caddy 改存主仓外 riveredge-ru | 🔵R2部分(2/5文件) | applied,domain-out,tracked |
| `ab912e4c14` | fix(deploy): Windows Caddy 国内优先山大 Release 镜像 | 🔵R2部分(1/2文件) | applied,tracked |
| `aa7d181320` | fix(deploy): install-component.ps1 Caddy 错误文案 | 🔵R2文件级已判 | applied |
| `c16cf35d1c` | fix(deploy): 锁定 Windows Caddy 唯一落点 riveredge- | 🔵R2部分(1/4文件) | applied,tracked |
| `95efae8f6d` | fix(deploy): 撤回 riveredge-runtime，Caddy 固定 fa | 🔵R2部分(2/5文件) | applied,domain-out,tracked |
| `454e306f9a` | fix(deploy): Windows 不 git clean；禁止 install 覆 | 🔵R2部分(1/4文件) | applied,tracked |
| `0ea3994534` | fix(deploy): 移除未核实的 SDU Caddy 镜像，优先 ghproxy.n | 🔵R2部分(2/3文件) | applied,domain-out,tracked |
| `8908591c5f` | chore(docs): 更新微信交流群截图 | 🔵R2文件级已判 | domain-out |
| `12550024bb` | fix(migrate,deploy): 报工/返工 review_status 列幂等与 | 🔵R2部分(1/3文件) | applied |
| `707700c8d0` | fix(deploy): install-web-dist 同步刷新 dist-live， | ⬜未评(文件已见2/2) |  |
| `220d2ce271` | fix(deploy): 低配机后端健康检查超时改为 360s | 🔵R2部分(1/3文件) | applied,tracked |
