# Harpoon — fast file navigation

[Harpoon](https://github.com/ThePrimeagen/harpoon) keeps a tiny, **hand-picked list of files** (the 3–6 you are actually working on) and jumps between them
instantly — no fuzzy-finding, no cycling through every open buffer. This config uses harpoon v1 with `mark_branch = true`, so **each git branch gets its
own list**: switch branch and your harpooned files switch with it.

Mental model: Telescope is for *finding* files you don't remember; Harpoon is for *returning* to files you already decided matter.

## Keymaps

| Mapping           | Description                                                        |
| ----------------- | ------------------------------------------------------------------ |
| `<leader>ha`      | [H]arpoon [A]dd — mark the current file                            |
| `<leader><space>` | Toggle the quick menu (also `<leader>hm`)                          |
| `<leader>hn`      | Jump to the [N]ext file in the list                                |
| `<leader>hp`      | Jump to the [P]revious file in the list                            |
| `<leader>sm`      | [S]earch [M]arks — the same list as a Telescope picker             |

`hn`/`hp` wrap around, so with 2–3 marked files they work as a fast toggle. Adding a file that is already in the list does nothing (no duplicates).

## The quick menu is just a buffer

The `<leader><space>` popup is an editable list of paths, one per line — normal Vim editing applies:

| Action            | How                                                                |
| ----------------- | ------------------------------------------------------------------ |
| Open file at cursor | `<Enter>`                                                        |
| Remove a mark     | `dd` the line                                                      |
| Reorder marks     | Move lines around (`dd` + `p`, or visual-select + move)            |
| Close (and save)  | `q` or `<Esc>` — changes to the list are persisted on close        |

Order matters: it is the order `hn`/`hp` cycle through, so put your two hottest files next to each other.

## The Telescope picker

`<leader>sm` shows the marks through Telescope, with the usual picker actions: `<Enter>` open, `<C-x>` horizontal split, `<C-v>` vertical split, `<C-t>` new tab.
Useful when the list has grown and you want to fuzzy-match inside it or open a mark in a split.

## Harpoon vs marks vs jumplist

- **Harpoon**: file-level, per-branch, curated by hand. Best for "the files of this task".
- **Capital marks** (`mA`…`'A`): exact line+column in a file, global. Best for one precise spot you keep coming back to — see [marks.md](marks.md).
- **Jumplist** (`<C-o>`/`<C-i>`): automatic history of where you've been. Best for "go back to where I just was" (`<leader>sj` shows it in Telescope).

## Notes

- Marks are persisted in `stdpath('data')/harpoon.json` (project- and branch-keyed), so they survive restarts.
- Because of `mark_branch = true`, a freshly created branch starts with an **empty** list — re-add or copy marks if you need them.
- Marks store the cursor position too: jumping to a harpooned file restores where you left it.
- `ui.nav_file(n)` (jump straight to entry *n*) exists but is unmapped here; the list is short enough that `hn`/`hp` and the menu cover it.
