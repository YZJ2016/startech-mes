# Spec 01 — Vue3 shell wiring

Date: 2026-08-21  
Parent: `2026-08-21-mes-vue3-front-upgrade.md`  
Depends on: none (first implementation slice)

## Goal

Make `startech-mes-basic/startech-mes-front` a MES-compatible admin **shell** against the existing 3.8.2 backend: login/JWT, proxy, 10-minute axios timeout, MinIO upload, SSO `/loginOuth`, and 3.9-only UI turned off. After this spec the stock RuoYi system/monitor pages can talk to ktg-admin; **no MES business pages** are added here.

## In scope (Vue 3 target)

Under `startech-mes-basic/startech-mes-front`:

- `vite.config.js` — dev proxy; target from env/local config, not a hardcoded production host. MES admin default port is **8085** (stock shell comments 8080).
- `.env.development`, `.env.production`, `.env.staging` — keep `VITE_APP_BASE_API` as a path prefix (`/dev-api` style). Optional extra keys for UReport later (spec 08) as placeholders only.
- `src/utils/request.js` — timeout `1000 * 60 * 10`; keep Bearer JWT and `code/msg/data` error handling.
- `src/api/login.js`, `src/store/modules/user.js`, `src/views/login.vue`, `src/permission.js`, `src/router/index.js`.
- SSO: port `frontend/src/api/login.js` `loginOuth`, `frontend/src/views/loginOuth.vue`, route `/loginOuth`.
- Upload: `src/components/FileUpload/index.vue`, `src/components/ImageUpload/index.vue` — default action `/common/uploadMinio` (stock default `/common/upload` is wrong for this MES).
- Disable lock screen: `src/views/lock.vue`, `src/store/modules/lock.js`, `src/layout/components/Navbar.vue` lock entry, `/lock` route, `permission.js` lock redirect, `unlockScreen` API.
- Disable password-expiry prompts in `src/store/modules/user.js` (`isDefaultModifyPwd`, `isPasswordExpired`, `pwrChrtype`). Do not call APIs the 3.8.2 backend does not expose.
- Titles: `VITE_APP_TITLE` may say MES/StarTech; no secrets.

## Source of truth (Vue 2)

Under `startech-mes-basic/frontend`:

- `src/utils/request.js` (timeout, Bearer, interceptors)
- `src/api/login.js` (`login`, `getInfo`, `logout`, `getCodeImg`, **`loginOuth`**, `getIndexNum` — `getIndexNum` is used by the dashboard in spec 08; the API helper may be added here or in 08, but URL must remain `/mes/pro/workorder/getIndexNum`)
- `src/views/login.vue`, `src/views/loginOuth.vue`, `src/router/index.js` (`/loginOuth`)
- `src/components/FileUpload/index.vue`, `src/components/ImageUpload/index.vue` (`/common/uploadMinio`)
- `vue.config.js` / `.env.*` as **behavior** reference only. Do not copy proxy hosts or any real IP into Vue 3 files. Vite proxy target is local/env config.

## Decisions

1. **One auth path.** Same `/login` POST body (`username`, `password`, `code`, `uuid`), token in `Authorization: Bearer`, then `/getInfo` and `/getRouters`.
2. **SSO is additive.** `/loginOuth` remains GET with query params as Vue 2. Failure handling matches Vue 2 (redirect to login, no parallel token store).
3. **Upload default is MinIO.** Callers can still pass another `action` if a page needs local `/common/upload`; default must be MinIO for MES parity.
4. **Lock screen is removed from UX**, not left as a hidden 404 that still POSTs `/unlockscreen`.
5. **Password-expiry fields are ignored** if present and not required if absent. 3.8.2 `getInfo` shape is enough (`user`, `roles`, `permissions`).
6. **Dev proxy** rewrites `/dev-api` to the backend origin from env (example name `VITE_DEV_PROXY_TARGET` or a local untracked override). Document the key; never commit a production URL. Typical local backend is port 8085.

## Conversion checklist (shell-only)

- `process.env.VUE_APP_BASE_API` → `import.meta.env.VITE_APP_BASE_API`
- Vue 2 router `component: () => import('@/views/loginOuth')` → Vue 3 equivalent constant-route entry, hidden from sidebar
- Element UI login form → Element Plus; no `.native`; `v-model` not `.sync`
- Keep captcha `/captchaImage` and 20s timeout on that call if Vue 2 does

## Success criteria

- Unauthenticated user can open the Vue 3 login page and obtain a JWT from the 3.8.2 `/login` (manual or documented local run; do not claim it unless executed).
- `request.js` timeout is 10 minutes; Authorization header still Bearer.
- File/image upload components default to `/common/uploadMinio`.
- `/loginOuth` route and API exist; no `/unlockscreen` calls from UI.
- Navbar has no lock-screen action; `/lock` is not a reachable app flow.
- `getInfo` does not block login when password-expiry fields are missing.
- `.env.development` still uses a path-style `VITE_APP_BASE_API`; no real IPs in the repo.
- Vue 2 `frontend/` unchanged.

## Non-goals

- No MES `views/mes/**` pages or selectors.
- No backend contract or Java changes.
- No Vue/Vite/Element Plus version bump.
- No lockfile commit; no `npm` stack upgrade to “make install work”.
- No production build claim unless `npm run build:prod` is actually run in a later task.
- Do not copy Vue 2 hardcoded report/dashboard URLs.

## Verification

- Static: grep the Vue 3 tree for `unlockscreen`, `lockScreen`, `/common/uploadMinio`, `loginOuth`, `timeout`.
- Runtime (optional for this slice, required before calling the shell “done”): log in against local 8085 with placeholder env; upload hits MinIO path.
- Never state “build succeeded” without command output.
