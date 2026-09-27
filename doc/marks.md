# Marks — bookmarks for positions

A mark stores a position (file + line + column) under a single character. Lowercase = local to one buffer, uppercase = global across files.
Vim also maintains automatic marks for you (last edit, last jump, yanked region...).

## Setting and jumping

| Keys        | Description                                                        |
| ----------- | ------------------------------------------------------------------ |
| `m{a-z}`    | Set local mark — only reachable while in that buffer               |
| `m{A-Z}`    | Set **global** mark — jumps back to the file too (project bookmarks) |
| `` `{mark}`` | Jump to exact position (line **and** column)                      |
| `'{mark}`   | Jump to first non-blank of the mark's line                         |
| ``` `` ``` | Jump back to position before the last jump (toggle between two spots) |
| `''`        | Same, but to start of line                                         |

Rule of thumb: always use backtick `` ` `` — it's exact; `'` is the line-wise sloppy twin. Both are motions,
so they compose: `` d`a `` deletes to mark `a`, `` y'b `` yanks whole lines through mark `b`'s line, `` v`a `` selects to it.

## Automatic marks (the useful ones)

| Mark       | Description                                                       |
| ---------- | ----------------------------------------------------------------- |
| `` `. ``   | Position of the **last change** in this buffer                    |
| `` `^ ``   | Where insert mode was last left (`gi` jumps there *and* re-enters insert) |
| ``` `` ```  | Position before the last jump (see above)                        |
| `` `" ``   | Cursor position when you last exited the buffer                   |
| `` `[ `` / `` `] `` | Start / end of the last change or yank                   |
| `` `< `` / `` `> `` | Start / end of the last visual selection (`gv` reselects it) |
| `` `0 ``–`` `9 `` | Cursor position when you last exited nvim (0 = most recent session) |

`` `] `` after a paste puts you at the end of what you pasted; `` `[ `` at the start. `:'<,'>` in cmdline is these marks in action.

## Managing

| Command             | Description                                          |
| ------------------- | ---------------------------------------------------- |
| `:marks`            | List all marks                                       |
| `:marks aB`         | List only marks `a` and `B`                          |
| `:delmarks a b`     | Delete marks `a` and `b`                             |
| `:delmarks a-d`     | Delete marks `a` through `d`                         |
| `:delmarks!`        | Delete all lowercase marks in the current buffer     |
| `:Telescope marks`  | Fuzzy-pick a mark (built-in picker, no keymap bound) |

## Recipes

**Two-point editing**: `ma` where you are, navigate anywhere (search, LSP jump...), edit, `` `a `` back. For a quick
back-and-forth after a single jump, ``` `` ``` alone toggles — no named mark needed.

**Project anchors**: `mM` in the main file, `mT` in its test, `mC` in the config — `` `M ``/`` `T ``/`` `C `` from anywhere.
Global marks survive restarts (saved in shada), so they work as lightweight persistent bookmarks.

**Operate over a region**: `ma` at one end, move to the other, `` d`a `` / `` y`a `` / `` gq'a `` (format lines through mark).

**Back to where I was editing**: `` `. `` (last change) or `gi` (resume insert where you left it) — often faster than any named mark.

Notes: lowercase marks live in the buffer (persisted per-file in shada); capital marks are the ones to use as cross-file bookmarks.
Marks stick to their line when you edit above them, but deleting the marked line drops column accuracy. Jumps to marks also push onto
the jumplist (`<C-o>`/`<C-i>` walk it). For *file*-level navigation use the pickers instead: `<leader>sf` git files, `<leader>sb` open
buffers, `<leader>sj` jumplist, `<leader>?` recently opened — marks shine *within* files and as operator motion targets.
