# Quickfix & location lists — how to use nvim's lists

Two built-in lists of file positions. **Quickfix** is global (one per session): project-wide results. **Location list** is per-window (`l*` variants of every command): local results like diagnostics of one buffer. Everything below works on either — swap `:c...` for `:l...`.

## Filling the list

| How                    | Mnemonic / source        | Description                                                    |
| ---------------------- | ------------------------ | -------------------------------------------------------------- |
| `<C-q>` in Telescope   | `q`uickfix               | Send **all** picker results to quickfix (works in `<leader>sg`, `sw`, `sd`, `gr`...) |
| `<M-q>` in Telescope   | selected only            | Send only the multi-selected entries (`<Tab>` marks them)      |
| `<leader>dl`           | `d`iagnostic `l`ist      | Buffer diagnostics → location list                             |
| `:grep foo`            | external grep            | Populate quickfix without UI                                   |
| `:vimgrep /foo/ **/*.ts` | internal grep          | Same, with vim regex                                           |

## Navigating

| Command             | Shorthand   | Description                                        |
| ------------------- | ----------- | -------------------------------------------------- |
| `:copen` / `:cclose` | `:cope`    | Open / close the quickfix window                   |
| `:cnext` / `:cprev` | `:cn` / `:cp` | Jump to next / previous entry                    |
| `:cfirst` / `:clast` | `:cfir`    | Jump to first / last entry                         |
| `:cc {n}`           | —           | Jump to entry n                                    |
| `:colder` / `:cnewer` | history   | Previous / next list (nvim remembers the last 10)  |
| `:Trouble qflist`   | —           | Same list in trouble.nvim's prettier UI            |

In the quickfix window itself: `j`/`k` to move, `<CR>` jumps to the entry.

## Acting on every entry — `:cdo` / `:cfdo`

- `:cdo {cmd}` runs `{cmd}` once per **entry** (line).
- `:cfdo {cmd}` runs `{cmd}` once per **file** — usually what you want for substitutions.

## Recipes

**Rename a word across the project** (plain text — for code symbols prefer LSP `<leader>ln`, see [lsp-keybinds](lsp-keybinds.md)):

1. `<leader>sw` on the word (or `<leader>sg` and type it)
2. `<C-q>` → results land in quickfix
3. `:cfdo %s/\<old\>/new/gc | update`

`\< \>` = whole word, `c` asks per match (drop it to replace blindly), `update` saves each file. Dry-run first with `:copen` to review what matched. To prune false positives before the `cfdo`: `:packadd cfilter`, then `:Cfilter /keep/` or `:Cfilter! /drop/` (bundled plugin; filters the list, `:colder` restores the unfiltered one).

**Undo a bad mass-substitution**: `:cfdo undo | update` on the same list.

**Review all project diagnostics**: `<leader>sd` → `<C-q>` → `:cn`/`:cp` through them, or `:Trouble diagnostics`.

**Delete every line matching a pattern**: fill quickfix, then `:cdo delete | update` (entry-wise, not file-wise).

Notes: `:cfdo`/`:cdo` abort on the first file that fails (e.g. no match with `%s`); add `e` to the substitute flags (`/ge`) to skip files without matches. `<C-q>`/`<M-q>` are Telescope defaults (`lua/custom/plugins/telescope.lua` keeps them). The location-list twins are `:lopen`, `:lnext`, `:ldo`, `:lfdo`...
