# MES Vue3 front upgrade — parent overview

Date: 2026-08-21  
Status: design (approved direction; not an implementation plan)  
Track: replace the Vue 2 admin UI by growing a Vue 3 app, without changing the 3.8.2 backend contract.

## Goal

Grow `startech-mes-basic/startech-mes-front` (RuoYi Vue3 3.9.2 shell, Vue 3 + Element Plus + Vite) until it can replace the current Vue 2 admin at `startech-mes-basic/frontend`. Phase 1 rewrites **all 122 MES business pages** to `<script setup>`. Cutover is a later decision (child spec 08); until then both apps exist and Vue 2 stays runnable.

## Spelling

The working directory is `startech-mes-front` (with the **r** in `star`). A typed variant `statech-mes-front` is incorrect and must not be used for paths, package name, or docs.

## Directory and git facts

| Location | Role | Git |
| --- | --- | --- |
| Outer `startech-mes/` | Docs, scripts, `AGENTS.md` | Outer repo. Gitignores `/startech-mes-basic/` and the old `/RuoYi-Vue3-front/` path. |
| `startech-mes-basic/` | MES product (backend + both fronts) | **Independent** git repo (not a submodule). Never `git add` its files from the outer repo. |
| `startech-mes-basic/frontend/` | Current Vue 2 RuoYi 3.8.2 admin | Leave untouched and runnable. Vue 2 freeze in `AGENTS.md` still applies here. |
| `startech-mes-basic/startech-mes-front/` | Vue 3 migration target | Lives in the inner repo. Copied from outer `RuoYi-Vue3-front` (that folder was removed after copy). |
| `startech-mes-basic/backend/` | Java 8 / Spring Boot 2.5.x / RuoYi-compatible 3.8.2 APIs | Frozen for this track. Default HTTP port 8085. |

Before any git command: `git rev-parse --show-toplevel` in the directory being operated on. Inner-repo changes stay in `startech-mes-basic`. Outer-repo changes are docs/`AGENTS.md` only.

`package.json` name in the Vue 3 app is `startech-mes-front`. Vue/Vite/Element Plus versions stay on the 3.9.2 shell; this track does not bump that stack.

## Constraints (from AGENTS.md)

1. No secrets, tokens, AccessKeys, DB credentials, or production hosts in new files, samples, or specs. Env values are placeholders or `${ENV_VAR}`.
2. Do not change API contracts: URL, HTTP method, `Authorization: Bearer <jwt>`, response `code/msg/data` and list `rows/total`.
3. Do not introduce a second auth or data-access scheme. Keep Spring Security/JWT on the backend; Vue 3 uses the same `/login`, `/getInfo`, `/getRouters`, `/logout`, `/captchaImage`.
4. Java / Spring Boot / Vue 2 `frontend/` stack remains frozen. Vue 3 work happens only under `startech-mes-front/`.
5. Do not claim tests or builds passed unless the commands were actually run.
6. UReport and any report designer URL go through env vars. Never hardcode IPs in Vue 3 config or pages (the Vue 2 `src/config/website.js` pattern is technical debt, not to be copied).

## Page conversion rule

Every MES business page and every MES selector in phase 1 is rewritten to **`<script setup>`**. Options API compatibility (`export default { ... }` in new MES pages) is out of scope. RuoYi stock system/monitor/tool pages that already ship as `<script setup>` in the 3.9.2 shell may stay as-is unless a MES customization touches them.

## Child specs and dependencies

Implementation is split. Child specs may proceed in parallel only where listed.

| Spec | File | Scope | Depends on |
| --- | --- | --- | --- |
| 01 | `2026-08-21-spec-01-vue3-shell.md` | Login, proxy, axios timeout, MinIO upload, SSO `/loginOuth`, disable 3.9 lock/password-expiry UI. No MES business pages. | — |
| 02 | `2026-08-21-spec-02-mes-selectors.md` | ~29 MES select components → `<script setup>` + Element Plus. | 01 |
| 03 | `2026-08-21-spec-03-md.md` | 18 md pages + matching `src/api/mes/md`. | 02 |
| 04 | `2026-08-21-spec-04-pro.md` | 17 pro pages; dhtmlx-gantt called out as optional 4b. | 02 |
| 05 | `2026-08-21-spec-05-wm.md` | 34 wm pages. | 02 |
| 06 | `2026-08-21-spec-06-qc.md` | 13 qc pages. | 02 |
| 07 | `2026-08-21-spec-07-cal-dv.md` | cal 13 + dv 8. | 02 |
| 08 | `2026-08-21-spec-08-cutoff.md` | Remaining ~19 pages (tm/edu/report/camera/contract/sale), dashboard, autocode, in-app messages, ureport-via-env, prod build, cutover decision. | 01 plus 03–07 |

03–07 are independent of each other after 02. Do not start domain pages before selectors exist: MES lists and dialogs depend on those pickers.

Survey counts (Vue 2 `frontend/src/views/mes`, 122 `.vue` files):

| Domain | Pages | Child spec |
| --- | --- | --- |
| md | 18 | 03 |
| pro | 17 | 04 |
| wm | 34 | 05 |
| qc | 13 | 06 |
| cal | 13 | 07 |
| dv | 8 | 07 |
| tm | 6 | 08 |
| edu | 4 | 08 |
| report | 4 | 08 |
| camera | 2 | 08 |
| contract | 2 | 08 |
| sale | 1 | 08 |

MES API source of truth: 101 JS files under `frontend/src/api/mes`. Port into `startech-mes-front/src/api/mes` with the same URLs.

## Cutover

Vue 2 `frontend/` stays the production admin until spec 08 records a cutover decision. There is one later switch, not a rolling replace of Vue 2 files. Spec 08 may keep Vue 2 as fallback; it must not delete or freeze-lift `frontend/` as part of 03–07.

## Must-port MES customizations

These exist on Vue 2 and are missing or different on the stock Vue 3 shell. Port them; do not drop them.

- SSO: `GET /loginOuth`, route `/loginOuth`, view `views/loginOuth.vue`.
- MinIO upload: `POST /common/uploadMinio` as the FileUpload/ImageUpload default (stock Vue 3 uses `/common/upload`).
- Axios timeout: 10 minutes (`1000 * 60 * 10`), not the Vue 3 stock 10 seconds.
- Autocode: `src/api/system/autocode/*` and `views/system/autocode/*`; many MES pages call `genCode`.
- In-app messages: `src/api/system/message.js` and `views/system/message`.
- Custom dashboard: `views/index.vue` plus `views/dashboard/*` (PanelGroup and charts), including `getIndexNum` from `/mes/pro/workorder/getIndexNum`.
- UReport: `/ureportM` API wrappers, designer iframe, preview URL **from env**, never a baked-in host.

## Vue 3 3.9 features to disable (backend is 3.8.2)

The 3.8.2 backend does not provide these. Leave them off in the Vue 3 app:

- Lock screen UI: navbar “lock”, route `/lock`, `views/lock.vue`, `store/modules/lock.js`, `permission.js` lock redirect.
- `POST /unlockscreen` (`unlockScreen` in `src/api/login.js`).
- `getInfo` password-expiry UI: `isDefaultModifyPwd`, `isPasswordExpired`, session `pwrChrtype` / `passwordRule.js` driven by those fields.

Keep stock 3.8-compatible monitor “unlock user account” (`/monitor/logininfor/unlock/...`). That is not the screen lock.

## Success criteria (this document / this move)

- Vue 3 sources live at `startech-mes-basic/startech-mes-front`.
- Vue 2 `frontend/` is unmodified by this track’s move.
- Outer `RuoYi-Vue3-front` is gone; `AGENTS.md` describes both fronts and still freezes Vue 2.
- Child specs exist under `docs/superpowers/specs/` and cover all 122 MES pages without overlapping ownership.
- No production hosts, tokens, or secrets in new env samples or these specs.

## Non-goals

- Implementing any of the 122 page rewrites in this document’s task.
- Changing backend Java, SQL, or API contracts.
- Replacing Vue 2 `frontend/` in place.
- Enabling Vue 3 3.9 lock screen or password-expiry against 3.8.2.
- Committing unless explicitly asked.
- Copying `node_modules`, `dist`, or secret-bearing `.env` files.

## Verification already performed (move task)

Commands were actually run:

- Copy: 287 files at destination; `package.json`, `src/main.js` present.
- `package.json` is readable; `name` is `startech-mes-front`; Vue/Vite versions unchanged (still 3.9.2 shell).
- Source `RuoYi-Vue3-front` removed; destination still 287 files.

Not run (and not claimed): `npm install`, `npm run build:prod`, backend tests, or any page migration.

## Shared conversion rules (all child specs)

Apply on every MES page and selector:

| Vue 2 | Vue 3 + Element Plus |
| --- | --- |
| Options API | `<script setup>` |
| `visible.sync` / `.sync` | `v-model` / `v-model:visible` |
| `slot-scope` / `slot=""` | `#default` / named `#` slots |
| Element UI `el-icon` classes | Element Plus icons (RuoYi string `icon="Search"` form is fine) |
| `.native` | remove |
| `this.getDicts` / dict mixin | `useDict(...)` from `@/utils/dict` |
| `@riophae/vue-treeselect` | `el-tree-select` |
| Pagination `:page.sync` `:limit.sync` | `v-model:page` `v-model:limit` |
| RightToolbar `:showSearch.sync` | `v-model:showSearch` |
| `yyyy-MM-dd` date format | `YYYY-MM-DD` |
| `process.env.VUE_APP_*` | `import.meta.env.VITE_APP_*` |

API modules stay in `src/api/` (no axios in views). `v-hasPermi` stays. Response handling stays `code/msg/data/rows/total`.
