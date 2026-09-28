# LSP & diagnostics — keybinds

Servers via [mason](https://github.com/mason-org/mason.nvim): `ts_ls`, `lua_ls`, `vimls`, `eslint`, `biome`. LSP keymaps are buffer-local, set on `LspAttach` (`lua/custom/plugins/lsp.lua`); diagnostic ones are global (`lua/custom/remap.lua`).

## Go to

| Mapping      | Mnemonic                | Description                                        |
| ------------ | ----------------------- | -------------------------------------------------- |
| `gd`         | `g`oto `d`efinition     | Definition (Telescope)                         |
| `gD`         | bigger jump             | Declaration                                        |
| `gi`         | `g`oto `i`mplementation | Implementation                                     |
| `<leader>ld` | `l`sp `d`efinition      | Definition (Telescope), same as `gd`               |
| `<leader>li` | `l`sp `i`mplementation  | Implementation, same as `gi`                       |
| `<leader>lr` | `l`sp `r`eferences      | References (Telescope)                             |
| `<leader>lt` | `l`sp `t`ype            | Type definition                                    |

## Docs & symbols

| Mapping      | Mnemonic            | Description                                        |
| ------------ | ------------------- | -------------------------------------------------- |
| `K`          | vim's "keyword"     | Hover documentation                                |
| `gK`         | `g`oto + `K` hover  | Signature help (`<C-k>` is window navigation)      |
| `<leader>ls` | `l`sp `s`ymbols      | Document symbols (Telescope)                      |
| `<leader>lS` | `l`sp `S`ymbols (big) | Workspace symbols, dynamic (Telescope)           |

## Refactor & format

| Mapping      | Mnemonic          | Description                                          |
| ------------ | ----------------- | ---------------------------------------------------- |
| `<leader>ln` | `l`sp re`n`ame    | Rename symbol project-wide                           |
| `<leader>la` | `l`sp `a`ction    | Code action                                          |
| `<leader>f`  | `f`ormat          | Format buffer ([conform](https://github.com/stevearc/conform.nvim); also formats on save) |

## Diagnostics

| Mapping      | Mnemonic             | Description                                       |
| ------------ | -------------------- | ------------------------------------------------- |
| `<leader>e`  | `e`rror              | Jump to next diagnostic                           |
| `<leader>E`  | `E` = backwards `e`  | Jump to previous diagnostic                       |
| `<leader>df` | `d`iagnostic `f`loat | Show diagnostic under cursor in a float           |
| `<leader>dl` | `d`iagnostic `l`ist  | Send diagnostics to the location list             |
| `<leader>sd` | `s`earch `d`iagnostics | All project diagnostics (Telescope)             |
| `:Trouble diagnostics` | —          | Diagnostics UI ([trouble](https://github.com/folke/trouble.nvim), no keymap bound) |

## Workspace folders (rarely used)

| Mapping      | Mnemonic           | Description                                         |
| ------------ | ------------------ | --------------------------------------------------- |
| `<leader>lwa` | `l`sp `w`orkspace `a`dd  | Add workspace folder                              |
| `<leader>lwr` | `l`sp `w`orkspace `r`emove | Remove workspace folder                         |
| `<leader>lwl` | `l`sp `w`orkspace `l`ist | Print workspace folders                           |

Notes: diagnostic jumps use `vim.diagnostic.jump` (with a float). `<leader>ld`/`<leader>li` duplicate `gd`/`gi`. `<leader>g` is git hunks (gitsigns), see [reading-diffs](reading-diffs.md).
