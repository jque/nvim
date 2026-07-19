# Buffers — keybinds

`prefix` = herdr `ctrl+b`. Same letter = same action; Shift = workspace level.

| Description                  | Mnemonic                 | nvim                        | herdr                                          | AeroSpace           |
| ---------------------------- | ------------------------ | --------------------------- | ---------------------------------------------- | ------------------- |
| **Focus**                    |                          |                             |                                                |                     |
| Focus left                   | `h` / ←                  | `<C-h>`                     | `prefix+h`                                     | `ctrl+cmd+h`        |
| Focus down                   | `j` / ↓                  | `<C-j>`                     | `prefix+j`                                     | `ctrl+cmd+j`        |
| Focus up                     | `k` / ↑                  | `<C-k>`                     | `prefix+k`                                     | `ctrl+cmd+k`        |
| Focus right                  | `l` / →                  | `<C-l>`                     | `prefix+l`                                     | `ctrl+cmd+l`        |
| Move node left/down/up/right | heavier chord            | —                           | —                                              | `ctrl+alt+cmd+hjkl` |
| **Windows / panes**          |                          |                             |                                                |                     |
| Split horizontal             | `s` = split              | `<C-w>s`                    | `prefix+s`                                     | —                   |
| Split vertical               | `v` = vertical split     | `<C-w>v`                    | `prefix+v`                                     | —                   |
| Cycle next                   | `w` = window             | `<C-w>w`                    | `prefix+tab`                                   | —                   |
| Resize mode                  | `r` = resize             | `<C-w>r` → `hjkl`/`=`/`Esc` | `prefix+r` → `hjkl`/`Esc`                      | —                   |
| Close window/pane            | `q` vim / `x` herdr      | `<C-w>q`                    | `prefix+x`                                     | —                   |
| Buffer → new tab             | `T` = Tab                | `<C-w>T`                    | —                                              | —                   |
| Zoom                         | `z` = zoom               | — (`<C-w>_` + `<C-w>\|`)    | `prefix+z`                                     | —                   |
| Equalize sizes               | `=`                      | `<C-w>=`                    | —                                              | —                   |
| **Tabs / workspaces**        |                          |                             |                                                |                     |
| Create tab                   | `a` = append             | `<C-w>a`                    | `prefix+a`                                     | —                   |
| Create workspace             | `A` = append (workspace) | —                           | `prefix+A`                                     | —                   |
| Next / prev tab              | `n` / `p`                | `gt` / `gT`                 | `prefix+n` / `prefix+p`                        | —                   |
| Next / prev workspace        | `N` / `P`                | —                           | `prefix+N` / `prefix+P`                        | —                   |
| Go to tab n                  | number                   | `{n}gt`                     | `prefix+1..9`                                  | —                   |
| Close tab                    | `X` = bigger `x`         | `:tabclose`                 | `prefix+X`                                     | —                   |
| Close workspace              | `D` = delete             | —                           | `prefix+D`                                     | —                   |
| Create git worktree          | `W` = Worktree           | —                           | `prefix+W`                                     | —                   |
| Rename tab/workspace         | `e` / `E` = edit         | —                           | `prefix+e` / `prefix+E`                        | —                   |
| **herdr navigate**           | `prefix+w`               | —                           | spaces `j`/`k` + `enter` · panes `h` `C-p` `C-n` `l` | —             |
| **herdr find pane**          | `prefix+g`               | —                           | `j`/`k` move · `/` search · `enter` switch     | —                   |
| **Cheatsheet library (popup)** | `i` = info             | —                           | `prefix+i` → pick doc · `esc` back · `q` close | —                   |
| **TUI selector (popup)**     | `t` = tui                | —                           | `prefix+t` → fzf over `tui-*` aliases · `esc` cancels | —            |

Notes: pane ↔ window, tab ↔ tab, herdr workspace ↔ session, AeroSpace workspace ↔ OS space. `prefix+W` (`new_worktree`, default `prefix+G`) creates a git worktree under `~/.herdr/worktrees` and opens a new workspace on it; also available from the CLI as `herdr worktree create|open|remove` (`open_worktree`/`remove_worktree` have no default binding). In navigate mode (`prefix+w`) moving between spaces needs `enter` to confirm (`esc` cancels); pane moves apply instantly and close the mode. The pane finder (`prefix+g`) has fixed keys — custom `navigate_*` binds don't apply there.

Unified focus: bare `ctrl+h/j/k/l` (no prefix) move across nvim splits **and** herdr panes as one layout, via [herdr-splits.nvim](https://github.com/lmilojevicc/herdr-splits.nvim) (herdr plugin + nvim plugin; nvim delegates to herdr at edges, herdr forwards the key when the pane runs nvim). Works from nvim terminal buffers too. Caveat: in a plain shell pane `ctrl+l` now moves focus instead of clearing the screen (use `clear`).
