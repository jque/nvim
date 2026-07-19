# nvim config

### Introduction

Custom version of [https://github.com/nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Keymap Cheat Sheet

> 📖 Guías completas: [buffers, splits y pestañas](doc/buffers-keybinds.md) · [LSP y diagnósticos](doc/lsp-keybinds.md) · [quickfix y listas](doc/quickfix-lists.md) · [edición: comentarios, surround, case](doc/editing-keybinds.md) · [marcas](doc/marks.md) · [registros](doc/registers.md) · [Sidekick (agentes AI)](doc/sidekick.md)
>
> En herdr, `prefix+i` abre estas guías renderizadas en un popup (glow).

### General

| Mapping | Mode | Description |
| --- | --- | --- |
| `<leader>f` | normal | Format buffer |
| `<leader>df` | normal | Show diagnostics in a floating window |
| `<leader>dl` | normal | Send diagnostics to the location list |
| `<leader>y` | normal | Yank to the system clipboard |
| `<leader>p` | normal | Paste from the system clipboard |
| Ctrl + backtick | insert | Leave insert mode quickly (Ghostty friendly) |

### Buffers & Windows

Ver la guía completa con todos los comandos nativos en [doc/buffers-keybinds.md](doc/buffers-keybinds.md).

| Mapping | Mode | Description |
| --- | --- | --- |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | normal/terminal | Move to the left / lower / upper / right window — inside herdr also crosses herdr panes ([herdr-splits.nvim](https://github.com/lmilojevicc/herdr-splits.nvim)) |
| `<leader>sb` | normal | List open buffers (Telescope) |
| `<C-^>` | normal | Toggle between the current and the alternate buffer |
| `<C-w>s` / `<C-w>v` | normal | Horizontal / vertical split |
| `<C-w>H/J/K/L` | normal | Move the current window to the far left / bottom / top / right |
| `<C-w>=` | normal | Equalize window sizes |
| `<C-w>o` | normal | Close all other windows |
| `:bd` | command | Delete (close) the current buffer |

### File Navigation

#### File explorer (`nvim-tree`)

| Mapping | Mode | Description |
| --- | --- | --- |
| `<leader>t` | normal | Toggle the file tree on the right side |

#### Telescope pickers

| Mapping | Mode | Description |
| --- | --- | --- |
| `<leader>?` | normal | Open recently used files |
| `<leader>/` | normal | Fuzzy search in the current buffer |
| `<leader>sf` | normal | Search project files (git files) |
| `<leader>sb` | normal | List open buffers |
| `<leader>sg` | normal | Live grep in the project |
| `<leader>sw` | normal | Grep the word under the cursor |
| `<leader>sh` | normal | Search help tags |
| `<leader>sd` / `<leader>se` | normal | Search diagnostics / errors |
| `<leader>sc` | normal | Show git status entries |
| `<leader>sk` | normal | Search keymaps |
| `<leader>sj` | normal | Show the jumplist |
| `<leader>sr` | normal | Resume the previous picker |

#### Harpoon

| Mapping | Mode | Description |
| --- | --- | --- |
| `<leader>ha` | normal | Add the current file to Harpoon |
| `<leader>hm` | normal | Toggle the Harpoon menu |
| `<leader>hp` | normal | Jump to the previous Harpoon entry |
| `<leader>hn` | normal | Jump to the next Harpoon entry |
| `<leader><space>` | normal | Toggle the Harpoon quick menu |
| `<leader>sm` | normal | Telescope picker with Harpoon marks |

### LSP & Diagnostics

Ver la guía completa con todos los atajos en [doc/lsp-keybinds.md](doc/lsp-keybinds.md).

| Mapping | Mode | Description |
| --- | --- | --- |
| `gd` / `gD` / `gi` | normal | Go to definition (Snacks picker) / declaration / implementation |
| `<leader>gr` | normal | References via Telescope |
| `<leader>rn` | normal | Rename symbol |
| `<leader>do` | normal | Code action |
| `K` | normal | Hover documentation |
| `<leader>e` / `<leader>E` | normal | Jump to the next / previous diagnostic |

### Completion & AI assistants

#### nvim-cmp

| Mapping | Mode | Description |
| --- | --- | --- |
| `<C-d>` | insert | Scroll completion documentation up |
| `<C-f>` | insert | Scroll completion documentation down |
| `<C-Space>` | insert | Trigger completion manually |
| `<CR>` | insert | Confirm the selected item |
| `<Tab>` | insert/select | Next item or expand/jump in a snippet |
| `<S-Tab>` | insert/select | Previous item or jump backward in a snippet |

#### GitHub Copilot

| Mapping | Mode | Description |
| --- | --- | --- |
| `<C-y>` | insert | Accept suggestion |
| `<C-]>` | insert | Dismiss suggestion |
| `<C-j>` | insert | Accept the next word |

#### Sidekick CLI

Ver la guía completa con todos los atajos en [doc/sidekick.md](doc/sidekick.md).

| Mapping | Mode | Description |
| --- | --- | --- |
| `<Tab>` | normal | Jump to the next Sidekick edit suggestion (fallbacks to Tab) |
| `<C-.>` | normal/insert/visual/terminal | Toggle the Sidekick CLI window |
| `<leader>aa` | normal | Toggle the Sidekick CLI |
| `<leader>as` | normal | Select a Sidekick CLI session |
| `<leader>ad` | normal | Close the active CLI session |
| `<leader>at` | normal/visual | Send the current context (`{this}`) |
| `<leader>af` | normal | Send the current file |
| `<leader>av` | visual | Send the visual selection |
| `<leader>ap` | normal/visual | Open the Sidekick prompt picker |
| `<C-p>` | agent window | Open the Sidekick prompt picker |
| `<C-b>` | agent window | Open the buffer picker (inserts the buffer into the agent prompt) |
| `<C-[>` | terminal | Exit terminal mode and return to normal mode |

### Treesitter

#### Incremental selection

| Mapping | Mode | Description |
| --- | --- | --- |
| `<C-Space>` | normal/visual | Start or expand the selection |
| `<C-s>` | normal/visual | Expand selection to the current scope |
| Alt + Space | normal/visual | Shrink to the previous node |

#### Textobjects & movements

| Mapping | Mode | Description |
| --- | --- | --- |
| `aa` / `ia` | visual | Parameter (outer / inner) |
| `af` / `if` | visual | Function (outer / inner) |
| `ac` / `ic` | visual | Class (outer / inner) |
| `]m` / `[m` | normal | Next / previous function start |
| `]M` / `[M` | normal | Next / previous function end |
| `]]` / `[[` | normal | Next / previous class start |
| `][` / `[]` | normal | Next / previous class end |
| `<leader>a` / `<leader>A` | normal | Swap parameter with next / previous |

### Additional resources

- https://codeium.com/
- https://supermaven.com/
- https://github.com/augmentcode/augment.vim

