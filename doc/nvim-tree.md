# nvim-tree — file explorer

[nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) is the file tree, docked on the **right** (60 cols). Toggle it with `<leader>t`.
All mappings below apply **inside the tree buffer** and are the plugin defaults, with one local change: `<C-k>` is freed for window/herdr
navigation (see `plugins/smart-splits.lua`), so the "file info" popup lives on `gi` instead. Hit `g?` inside the tree for the full list.

This config sets `update_focused_file` + `update_root`: the tree **follows the file you are editing** (highlights it and changes root if
needed), so opening the tree always shows where you are. Dotfiles are hidden by default — `H` toggles them.

## Opening files

| Mapping         | Description                                                        |
| --------------- | ------------------------------------------------------------------ |
| `<Enter>` / `o` | Open file, or expand/collapse directory                            |
| `<C-v>`         | Open in a vertical split                                           |
| `<C-x>`         | Open in a horizontal split                                         |
| `<C-t>`         | Open in a new tab                                                  |
| `<Tab>`         | Preview: opens the file but keeps focus in the tree                |
| `O`             | Open without the window picker (uses the last window directly)     |

## Moving around the tree

| Mapping     | Description                                                            |
| ----------- | ---------------------------------------------------------------------- |
| `P`         | Jump to the parent directory of the current node                       |
| `<BS>`      | Close the directory under/above the cursor                             |
| `J` / `K`   | Jump to last / first sibling                                           |
| `>` / `<`   | Next / previous sibling                                                |
| `E` / `W`   | Expand all / collapse all                                              |
| `-`         | Change root to the parent directory (go up)                            |
| `<C-]>`     | Change root to the directory under the cursor (cd into it)             |
| `S`         | Search: prompt for a path and jump to it                               |
| `f` / `F`   | Live filter the tree as you type / clear the filter                    |
| `]c` / `[c` | Next / previous node with a git change                                 |
| `]e` / `[e` | Next / previous node with a diagnostic                                 |

## File operations

Creation understands paths: `a` then `foo/bar.lua` creates the directory too; a trailing `/` (`foo/`) creates a directory.

| Mapping | Description                                                                |
| ------- | -------------------------------------------------------------------------- |
| `a`     | Create file/directory inside the directory at cursor                       |
| `r`     | Rename (edit the filename)                                                  |
| `e`     | Rename only the basename (keeps the extension selected out)                 |
| `u`     | Rename editing the full path — doubles as **move**                          |
| `d`     | Delete (asks for confirmation)                                              |
| `D`     | Move to trash                                                               |
| `x`     | Cut                                                                         |
| `c`     | Copy                                                                        |
| `p`     | Paste the cut/copied node into the directory at cursor                      |
| `y`     | Copy the file **name** to the clipboard                                     |
| `Y`     | Copy the **relative path**                                                  |
| `gy`    | Copy the **absolute path**                                                  |

Bookmarks let you batch-move: `m` toggles a bookmark on nodes, then `bmv` moves all bookmarked nodes to the directory at cursor.

## Toggles & misc

| Mapping | Description                                                                |
| ------- | -------------------------------------------------------------------------- |
| `H`     | Toggle dotfiles (hidden by default in this config)                          |
| `I`     | Toggle git-ignored files                                                    |
| `R`     | Refresh the tree                                                            |
| `gi`    | File info popup (size, dates, path) — remapped here from the default `<C-k>` |
| `s`     | Open the node with the system default app (Finder/`open`)                   |
| `q`     | Close the tree window                                                       |
| `g?`    | Built-in help with every mapping                                            |

## Notes

- `<C-h>`/`<C-j>`/`<C-k>`/`<C-l>` still navigate windows from inside the tree, like from any other window.
- For *finding* files by name, Telescope (`<leader>sf`) is faster; the tree shines for **browsing structure** and file operations (create/rename/move).
- Git status and diagnostics are shown per node with icons; `]c`/`[c` and `]e`/`[e` jump between them.
