# Reading diffs — unified format, guh.nvim and diffs.nvim

Quick guide to reviewing diffs in this config: what each line of a unified diff means, how guh.nvim's PR buffer is organized, and where diffs.nvim's colors come from.

1. [Anatomy of a unified diff](#1-anatomy-of-a-unified-diff)
2. [The `@@` header of each hunk](#2-the--header-of-each-hunk)
3. [Context vs added/removed](#3-context-vs-addedremoved)
4. [The guh.nvim prdiff buffer](#4-the-guhnvim-prdiff-buffer)
5. [Outdated/outside sections](#5-outdatedoutside-sections)
6. [Colors: diffs.nvim](#6-colors-diffsnvim)
7. [Side-by-side diff](#7-side-by-side-diff)

## 1. Anatomy of a unified diff

Every modified file starts with a header block:

```diff
diff --git a/pnpm-workspace.yaml b/pnpm-workspace.yaml
index 8a3406d4..4cdff4ee 100644
--- a/pnpm-workspace.yaml
+++ b/pnpm-workspace.yaml
```

- `diff --git a/X b/Y` — starts a file's section. `a/` is the old version (the PR base) and `b/` the new one. If X != Y there was a rename.
- `index old..new` — abbreviated blob hashes before/after, plus the file mode (100644 normal, 100755 executable).
- `--- a/...` and `+++ b/...` — repeat the two sides. `/dev/null` on the `---` side means a new file; on the `+++` side, a deleted file.

Then come one or more "hunks" (chunks with changes), each headed by an `@@` line.

## 2. The `@@` header of each hunk

```diff
@@ -12728,6 +13368,15 @@ snapshots:
```

Read it as: "in the old file this chunk started at line 12728 and spanned 6 lines; in the new one it starts at 13368 and spans 15".

- `-start,count` — position in the old version (the ` ` and `-` lines).
- `+start,count` — position in the new one (the ` ` and `+` lines).
- Whatever follows the second `@@` (here `snapshots:`) is context: the nearest enclosing function/section, to help you orient yourself.

Trick: with `-...,6 +...,15` you know without looking that this hunk has 9 net added lines (15 − 6), and the rest is shared context.

## 3. Context vs added/removed

Inside a hunk, the FIRST CHARACTER of each line is what matters:

| Prefix | Meaning |
| ------ | ------- |
| ` ` (space) | Context: the line exists unchanged in both versions. Deliberately not colored. |
| `-` | Only in the old version (removed). Red background. |
| `+` | Only in the new one (added). Green background. |
| `+` alone | An added blank line (painted the same: a thin green stripe at the end of a block). |

The classic trap (it got us with `pnpm-lock.yaml`): in a lockfile the context looks a lot like the changes. For example:

```diff
@@ -12728,6 +13368,15 @@ snapshots:
     '@turbo/windows-64': 2.10.4      <- space: context, no color

+  turbo@2.10.5:                      <- added: green
+    optionalDependencies:
```

The `2.10.4` snapshot still exists in the file (something still references it), so it shows up as unpainted context right next to the new block. It's not that "it isn't being highlighted" — it just didn't change. When in doubt, look at the first character of the line, not the color.

## 4. The guh.nvim prdiff buffer

`:Guh` on a PR loads three buffers: `pr/` (description), `prdiff/` (the full PR diff) and `prcomments/` (threads). See [guh.md](guh.md) for everything; the ones I use most in `prdiff/`:

| Mapping | Description |
| ------- | ----------- |
| `]]` / `[[` | Jump to next/previous `diff --git` section |
| `gf` | Open the full file at the PR's head commit |
| `cv` | Toggle the file as Viewed (collapses its diff to a `(viewed) path` line) |
| `cr` | Reply to / resolve the thread under the cursor |
| `dd` | (from the `pr/` view) open diff + comments in splits with `'scrollbind'` |
| `R` | Refresh the PR (repaints and repositions everything) |
| `-` | Go up to `guh://status` (notifications) |

The first line of the buffer (`PR DIFF | Files: N (Viewed: n) | ...`) carries the file count and the number of unresolved threads.

PR comments also show up as diagnostics and in the quickfix list.

## 5. Outdated/outside sections

Above the current diff, guh adds pseudo-sections with names like:

```
outdated-3628824729:apps/auth-app/src/.../google-auth.service.ts
outside-3628824729:apps/auth-app/src/.../other.ts
```

They are not part of the PR's current diff: they exist only to anchor UNRESOLVED comments left on code from an old push (`outdated-`) or on code outside the diff (`outside-`).

- `gf` there gives "guh: Cannot fetch file for outdated diff" on purpose: guh fetches the file at the current head, and those lines no longer match the head. Go down to the file's real section (no prefix) and use `gf` there, or open the file from the working tree.
- Replying/resolving (`cr`) does work from the pseudo-section.
- When you resolve the thread (or mark the file Viewed), the pseudo-section disappears on the next refresh.

## 6. Colors: diffs.nvim

The prdiff highlighting (and fugitive's, telescope's, etc.) comes from diffs.nvim. Things worth knowing:

- The red/green backgrounds are NOT invented by the plugin: they start from the colorscheme's `DiffAdd` / `DiffDelete`, blended toward the background according to `highlights.blend_alpha` (default 0.6; in this config 0.9, almost the theme's pure color). Theme with muted diffs ⇒ muted diff.
- Intra-line word-diff (`highlights.intra`) paints the characters that changed within the line in ANOTHER, lighter tone (`DiffsAddText`/`DiffsDeleteText`). In lockfiles with mile-long lines it was unreadable, so in this config it is DISABLED: a single green/red per line.
- If you add `iwhite`/`iwhiteall` to `'diffopt'`, the `-`/`+` pairs that only differ in whitespace get de-emphasized to a neutral gray (`DiffsDim`). With the default `'diffopt'` it doesn't apply.

All of this is configured in `vim.g.diffs` (`lua/custom/package.lua`, BEFORE the `vim.pack.add`). The `Diffs*` groups accept direct overrides via `highlights.overrides` if a theme ships ugly diffs.

When switching colorschemes on the fly (`:colorscheme kanagawa`, etc.) diffs.nvim recomputes its colors on its own: you can compare themes with the prdiff open.

## 7. Side-by-side diff

The guh prdiff is always unified. For side-by-side use diffs.nvim on a local checkout:

```vim
gh pr checkout <n>
:Diff review                  " whole repo vs origin/main, unified,
                              " quickfix with one entry per file
:Diff review ++layout=split   " file by file in two columns
```

Navigation in review: `:cnext`/`:cprev` between files, `:lnext`/`:lprev` between hunks. Also without a checkout:

```vim
:Diff review origin/main...origin/pr-branch
```

Trade-off: `:Diff review` has no PR comments/threads; to comment, go back to the guh prdiff.

See also: [guh.md](guh.md), `:h diffs.nvim`, `:h diff-format`.
