# guh.nvim — GitHub PRs/issues from Neovim

[guh.nvim](https://github.com/justinmk/guh.nvim) wraps the `gh` CLI to review PRs, read issues/notifications and inspect CI logs **without checking out the branch**.
No config, one command: `:Guh`. Everything lives in `guh://…` buffers, and all mappings below work in any of them. Hit `g?` inside a guh buffer to see this list.
Diff highlighting comes from diffs.nvim; markdown rendering from render-markdown.nvim (both already in `lua/custom/package.lua`).

## The `:Guh` command

| Command                                       | Result                                                            |
| --------------------------------------------- | ----------------------------------------------------------------- |
| `:Guh`                                        | Repo overview: recent commits, branches, open PRs/issues, `gh pr status`. Falls back to notifications if no repo is detected |
| `:Guh 123` / `:Guh #123`                      | PR or issue number in the current repo                            |
| `:Guh a1b2c3d`                                | Commit SHA (fetched via API, no checkout)                          |
| `:Guh owner/repo` / `:Guh owner/repo#123`     | Repo / PR by slug                                                  |
| `:Guh https://github.com/...`                 | Any GitHub URL (PR, commit, repo, branch)                          |
| `:Guh owner/repo/tree/branch`                 | Branch                                                             |
| `:Guh .`                                      | The WORD under the cursor (URL, SHA, `#123`…) — works anywhere     |

Accepts mods: `:vertical Guh 123`, `:tab Guh 123`. Without mods, an existing window for that target is reused/focused.

## Navigation (any `guh://` buffer)

| Mapping   | Description                                                                    |
| --------- | ------------------------------------------------------------------------------ |
| `<Enter>` | Open the target at cursor (PR, issue, commit, branch…)                          |
| `o`       | Same, but in a split window                                                     |
| `-`       | Go "up": diff/comments/logs → PR → repo page → notifications (`guh://status`)   |
| `R`       | Refresh the current view (data is cached until you do this)                     |
| `dd`      | View the PR diff + comments                                                     |
| `dl`      | View the latest CI logs (all jobs in the matrix)                                |
| `]f` / `[f` | Next/previous "thing": next CI job in a logs buffer, next commit in a PR view |
| `gf`      | In a diff: open the full contents of the file at cursor                         |
| `]]` / `[[` | In a diff: jump to next/previous file section (`diff --git` heading)          |
| `gX`      | Open the current view on github.com                                             |
| `g?`      | Built-in help with all mappings                                                 |
| `<C-^>`   | From the diff, back to the PR view (it's the alternate file). On a Spanish keyboard `^` is a dead key — press `<C-6>` instead, it's the exact same command (`:h CTRL-^`) |

## Reviewing a PR

Typical flow: `:Guh 123` → `dd` for the diff → read/reply to comments → `cR` to approve or request changes.

The diff opens with comments in a `'scrollbind'` split (if it desyncs: `:syncbind`). Comments also arrive as:

- **Diagnostics** (INFO, source "guh.nvim") on the diff buffer → navigate with `]d` / `[d`, peek the full comment with `<C-w>d`.
- **Quickfix list** ("Guh comments") → `]q` / `[q` or `:copen`.

Only *unresolved* comments are shown. Files marked as Viewed collapse to a `(viewed) path` line. Comments on outdated pushes or outside the diff appear
in pseudo-sections (`outdated-…`, `outside-…`) above the current diff.

| Mapping         | Description                                                              |
| --------------- | ------------------------------------------------------------------------ |
| `cc` / visual `c` | Comment on the diff line(s) at cursor; on an existing comment, edits it |
| `cr`            | On a thread: menu → 1. Reply, 2. Resolve                                  |
| `cv`            | Toggle "Viewed" on the file at cursor (refresh with `R` to collapse it)   |
| `cC`            | Top-level comment on the PR/issue                                         |
| `cR`            | Review menu → 1. Approve, 2. Comment, 3. Request-changes, 4. Toggle draft |
| `cM`            | Merge menu → 1. squash, 2. merge, 3. rebase, 4–6. same with `--admin`     |
| `cI`            | Rerun CI → 1. current job, 2. failed jobs                                 |
| `cV`            | Mark notification as Read (irreversible — GitHub has no unread API)       |
| `c:`            | Edit title/body/labels/milestone via `gh` in a `:terminal`                |

**Skip a picker with a count**: `1cR` = approve directly, `4cR` = toggle draft, `1cM` = squash, `2cr` = resolve thread.

## Confirming actions (comment, merge, review…)

Actions that take text open an editable `guh://…/edit` buffer:

- **Confirm**: write-and-close → `ZZ` or `:wq`.
- **Abort**: close without writing → `ZQ` or `:q!` (or write it empty if content is required).

`:GuhComment` is the ex-command equivalent of `cc`: `:.GuhComment` (line), `:'<,'>GuhComment` (range), `:%GuhComment` (top-level), `:.GuhComment!` (delete).

### Translate/fix a draft with local ollama

In any comment/review draft buffer, before confirming with `ZZ`:

| Mapping / command | Description |
| ----------------- | ----------- |
| `<C-t>` (normal)  | Rewrite the whole draft: Spanish → English, or fix grammar if already English |
| `<C-t>` (visual)  | Same, but only the selected lines |
| `:[range]Translate` | Ex-command version, works in any buffer (no range = whole buffer) |

Runs 100% locally against ollama (`translategemma:4b` by default — needs `ollama serve` running). Markdown and code blocks come through intact. Configured in `lua/custom/plugins/ollama-translate.lua`; override model/prompt/url via `vim.g.ollama_translate`.

## Notes

- Data loads eagerly and is **never** re-fetched until you press `R`.
- Custom keymaps: map anything to `<Plug>(guh-…)` and guh skips its default (e.g. `nnoremap Ug <cmd>Guh .<cr>` to open the cursor target from any buffer). Prefix a count to bake in a menu choice: `nnoremap D 4<Plug>(guh-review)`.
- Debugging: `vim.g.guh_debug = 'debug'` then `:log guh`.
