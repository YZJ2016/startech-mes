# Spec 02 — MES selectors to script setup

Date: 2026-08-21  
Parent: `2026-08-21-mes-vue3-front-upgrade.md`  
Depends on: `2026-08-21-spec-01-vue3-shell.md`

## Goal

Port the MES picker/dialog components from Vue 2 into `startech-mes-front` as `<script setup>` + Element Plus, with the same emit/prop contracts the domain pages will need. **This spec must finish before any domain page spec (03–07).** IconSelect, RightToolbar, and SizeSelect are RuoYi stock in Vue 3 already — skip them.

## Why first

Md/pro/wm/qc/cal/dv pages open these dialogs for items, warehouses, vendors, QC docs, etc. Porting pages before pickers forces duplicated stubs or broken buttons.

## In scope (Vue 3 target)

`startech-mes-basic/startech-mes-front/src/components/<name>/` for each module below, plus any `src/api/mes/**` helpers a selector needs that spec 01 did not add. Prefer mirroring Vue 2 API import paths.

## Source of truth (Vue 2)

`startech-mes-basic/frontend/src/components/<name>/` (29 modules, 36 `.vue` files):

| Module | Vue files |
| --- | --- |
| `itemSelect` | `index.vue`, `purchase.vue`, `single.vue` |
| `workorderSelect` | `purchase.vue`, `single.vue` |
| `workstationSelect` | `simpletableSingle.vue` |
| `vendorSelect` | `single.vue` |
| `clientSelect` | `single.vue` |
| `productSelect` | `single.vue` |
| `stockSelect` | `multi.vue`, `single.vue` |
| `toolSelect` | `index.vue`, `single.vue` |
| `userSelect` | `multi.vue`, `single.vue` |
| `holderSelect` | `single.vue` |
| `machinerySelect` | `index.vue`, `single.vue` |
| `qcindexSelect` | `single.vue` |
| `iqcSelect` | `single.vue` |
| `oqcSelect` | `single.vue` |
| `calTeamSelect` | `multi.vue` |
| `designpaperSelect` | `single.vue` |
| `dvsubjectSelect` | `multi.vue` |
| `issue` | `single.vue` |
| `itemBomSelect` | `single.vue` |
| `itemRecpt` | `single.vue` |
| `package` | `single.vue` |
| `purchaseSelect` | `single.vue` |
| `reportSelect` | `single.vue` |
| `saleorderSelect` | `single.vue` |
| `TaskSelect` | `taskSelectSingle.vue` |
| `turnplateSelect` | `single.vue` |
| `trunplateTaskList` | `single.vue` (keep the Vue 2 folder spelling) |
| `workstationSelectConfig` | `simpletableSingle.vue` |
| `defectSelect` | `single.vue` |

Related Vue 2 APIs those components import (also under `frontend/src/api/mes` and `frontend/src/api/system/autocode/rule.js` for `genCode`). `reportSelect` uses `/ureportM` — keep the URL; preview host must come from env (no IP copy).

## Decisions

1. **`<script setup>` only** for these components. No Options API shims.
2. **Keep folder names** including `trunplateTaskList` so later page imports stay mechanical.
3. **Public contract:** preserve Vue 2 prop names (`visible`/`open` as used), `v-model` for selected rows/ids, and emit names (`onSelected`, etc.). If Vue 2 used `.sync` on `visible`, Vue 3 uses `v-model:visible` (or `v-model` if it was the default model). Document any unavoidable rename in the PR, do not silently diverge.
4. **Pagination / RightToolbar** already exist in the Vue 3 shell — consume them with `v-model:page` / `v-model:limit` / `v-model:showSearch`.
5. **Dicts** via `useDict` from `@/utils/dict`.
6. **Trees** via `el-tree-select`, not `vue-treeselect`.
7. **Autocode** `genCode` stays on `/system/autocode/get/:ruleCode` (add the API module here if spec 01 did not).
8. Skip RuoYi stock: `IconSelect`, `RightToolbar`, `SizeSelect`.

## Conversion checklist

- `visible.sync` → `v-model` / `v-model:visible`
- `slot-scope` / `slot=""` → `#default` / named slots
- `el-icon` → Element Plus icons
- `.native` → remove
- dict mixin → `useDict`
- treeselect → `el-tree-select`
- Pagination/RightToolbar `.sync` → `v-model:*`
- `process.env.VUE_APP_*` → `import.meta.env.VITE_APP_*`
- date `yyyy` → `YYYY`
- dialogs: Element Plus `v-model` not `:visible.sync`

## Success criteria

- All 29 modules exist under `startech-mes-front/src/components/` with `<script setup>`.
- Each picker still calls the same backend list/get URLs as Vue 2.
- A host page can open/close the dialog with `v-model` and receive the selected record without Options API.
- No `vue-treeselect` dependency added to Vue 3 `package.json`.
- No secrets or hosts in component source.
- Vue 2 components left in place (source of truth until cutover).

## Non-goals

- No domain `views/mes/**` pages (specs 03–08).
- No backend contract change.
- No restyling beyond Element Plus equivalents.
- No renaming of `trunplateTaskList` “for cleanliness”.
- Do not implement UReport designer (spec 08); `reportSelect` only needs list/preview wiring with env-based preview base.

## Verification

- File-level: 29 directories present; grep for leftover `slot-scope`, `.sync`, `this.$set`, `vue-treeselect`.
- Spot-check one single-select and one multi-select against local 8085 (do not claim pass unless run).
- `npm run build:prod` is not required to close this spec if 03+ will rebuild; if claimed, the command must have been run.
