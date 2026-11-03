# Handoff — uncommitted combined state / commit cleanup

> Written 2026-11-02 because the session hit an OpenCode/provider balance
> limit before commits were made. The active agent has taken over the
> worktree. Read this before staging or committing anything.

## 0. First, the balance error

The “insufficient balance” is an OpenCode / model-provider account error, not
an app error. It cannot be fixed from inside the repository. Start a new
session with the same project and a funded provider.

## 1. Current git state

- Branch: `impl/mvp`
- HEAD: `7edd3ca` (`docs(promotions): record sale-cast fix status...`)
- **No commits were made by the previous agent.**
- The worktree contains **both**:
  - the previous agent’s variants/promotions/UX-audit work, and
  - the active agent’s in-flight UX/visual/push/avatar work.
- Do **not** discard or reset the worktree.

## 2. What was done so far

### Previous agent (uncommitted)

**Promotions**
- Coupon hard-delete RPC for unredeemed codes, with a SECURITY DEFINER fix so
  the `order_coupons` check can see FK rows.
- Archived coupons screen (expired/deactivated, read-only); live list filters
  them out.
- DTO null-safety for sale/coupon/banner fields.
- Migrations 0005/0006 + `docs/HANDOFF-PROMOTIONS.md`.

**Variants**
- Harmonized model: null-price `Default` is a single-price placeholder, not
  an admin-managed variant.
- Single-price vs option-pricing form behavior; hidden placeholder; last
  variant archive confirms switching to single price.
- Read model filters archived/placeholder variants; cheapest visible variant
  is the default; wishlist mirrors the rule.
- Migration 0007, seed update, `docs/HANDOFF-VARIANTS.md`,
  `test/product_variant_visibility_test.dart`.

**UX audit implementation**
- Friendly error copy (`userMessageFor`) and shared `AsyncValueWidget` error
  branch.
- Mutation-safe state: checkout placement, order cancel/upload, admin stock,
  archive, image removal, platform settings.
- Checkout friction: coupon removal/re-validation, inline address route,
  totals preview decoupled from note edits, preview error notice.
- Accessibility/responsive: `ContentWidth`, 48dp targets, semantics,
  reduced-motion timeline, wrapping rows, responsive report grid, admin
  overflow menu.
- Trust cleanup: removed mocked product claims/specs, fake courier/ETA/
  tracking, human payment labels, proof upload hidden after submission.
- Login: inline errors, reset email, password visibility, autofill.
- Admin: inline product-form validation/focus, dialog scroll/blank-name
  validation, status-aware banner actions.
- Address: geo retry, tap-to-adjust map pin, service-vs-permission settings.
- `test/error_copy_test.dart`, `test/order_lifecycle_parsing_test.dart`
  additions.
- `docs/HANDOFF-UX-VISUAL.md` (design direction + motion brief).

### Active agent (in-flight, uncommitted)

Visible in the worktree:
- `motion.dart`, `app_keys.dart`, `push_target.dart`, `staggered_grid.dart`,
  `push_navigation.dart`.
- Product-detail store-promises block using real delivery fee; motion on
  price/variant changes; mocked merchandising removed.
- Bottom navigation restored (rail reverted) with animated cart badge.
- Push notification service, avatar upload, notification order links,
  settings/profile sign-out updates.
- Delivery-fee provider, product-grid staggered entrance.
- Migrations 0008 (`avatar_storage`) and 0009 (`notification_order_link`).
- `test/notification_mapping_test.dart`.

## 3. Chosen commit strategy

**Active agent commits the combined state.** This is the chosen plan because
the two workstreams are already interleaved in shared files (e.g.
`product_detail_screen.dart`, `app_shell.dart`, `catalog_repository_impl.dart`,
`profile_screen.dart`, `admin_dashboard_branch.dart`).

Do not try to split this into “my files” vs “your files” now. Commit the
combined, verified state as a checkpoint, then continue the visual work.

## 4. Commit procedure

1. Inspect:
   ```bash
   git status --short
   git diff --stat
   git log --oneline -5
   ```
2. Ensure no secrets are staged:
   - never commit `config/`, `supabase/functions/.env`, platform secrets.
3. Exclude the unrelated pre-existing scratch file if you agree it is not
   part of this work:
   ```bash
   git reset -- "supabase/snippets/Untitled query 163.sql"
   ```
   (Only if it is still unrelated; inspect first.)
4. Regenerate/verify:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   flutter analyze
   flutter test
   ```
5. Stage the combined intended work:
   ```bash
   git add -A
   # if excluded above:
   git reset -- "supabase/snippets/Untitled query 163.sql"
   git status --short
   ```
6. Commit with a checkpoint message, for example:
   ```bash
   git commit -m "feat: UX/visual pass, variants, promotions, and push notifications"
   ```
7. Report the commit hash and any remaining dirty files.

## 5. Stateful prompt for the active agent

Paste this into the active agent’s session (it already has its own context):

> You are the active agent for `/mnt/data/projects/flutter/encueypay`.
> The previous agent’s work is uncommitted in this same worktree, mixed with
> your in-flight UX/visual/push/avatar work. Do not discard anything.
>
> Read `AGENTS.md`, `docs/HANDOFF-UX-VISUAL.md`, `docs/HANDOFF-VARIANTS.md`,
> and `docs/HANDOFF-PROMOTIONS.md`. Then commit the combined state now:
>
> 1. Inspect `git status --short`, `git diff --stat`, and recent commits.
> 2. Verify no secrets or unrelated scratch files are staged.
> 3. Run `dart run build_runner build --delete-conflicting-outputs`,
>    `flutter analyze`, and `flutter test`.
> 4. Exclude `supabase/snippets/Untitled query 163.sql` if it is unrelated.
> 5. Commit the combined intended work with a clear conventional message.
> 6. Report the commit hash, remaining dirty files, and any pending
>    migrations (`0005`–`0009` may be unapplied remotely).
>
> After committing, continue your visual/motion work from
> `docs/HANDOFF-UX-VISUAL.md`. Do not split the previous agent’s work into
> separate commits unless you intentionally want to rewrite history.

## 6. After the commit

- Continue the visual/motion pass from `docs/HANDOFF-UX-VISUAL.md`.
- Run `supabase migration list`, then `supabase db push` for pending
  migrations when the backend is ready.
- Verify the variant harmonization on hosted data: Dyson should no longer
  expose a `Default` customer option; single-price products show Price only.

## 7. Key files map

| Area | Paths |
|---|---|
| Error/feedback | `lib/core/domain/failures.dart`, `lib/core/presentation/widgets/async_value_widget.dart` |
| Responsive width | `lib/core/presentation/widgets/content_width.dart` |
| Motion | `lib/core/presentation/motion.dart` |
| Checkout | `lib/features/checkout/**` |
| Variants | `supabase/migrations/20261102000007_*`, `supabase/seed.sql`, `lib/features/catalog/**`, `lib/features/admin/**`, `docs/HANDOFF-VARIANTS.md` |
| Promotions | `lib/features/promotions/**`, `supabase/migrations/20261102000005_*`, `20261102000006_*`, `docs/HANDOFF-PROMOTIONS.md` |
| Push/avatar | `lib/features/notifications/**`, `lib/features/profile/**`, `supabase/migrations/20261102000008_*`, `20261102000009_*` |
| Visual brief | `docs/HANDOFF-UX-VISUAL.md` |
