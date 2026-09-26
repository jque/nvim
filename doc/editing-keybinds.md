# Editing operators — comments, surround, case

Native commenting, two editing plugins and treesitter text objects. All follow vim grammar: `operator + motion/text-object`.

## Comments (built into Neovim >= 0.10, see `:help commenting`)

| Mapping     | Mode   | Mnemonic            | Description                                        |
| ----------- | ------ | ------------------- | -------------------------------------------------- |
| `gcc`       | normal | `g` `c`omment line  | Toggle comment on the current line                 |
| `gc{motion}` | normal | comment + motion   | Toggle comment over a motion: `gcip` (paragraph), `gc3j` (3 lines down), `gcG` (to end of file) |
| `gc`        | visual | —                   | Toggle comment on the selection                    |

Combos with treesitter text objects: `gcaf` comments the whole function, `gcac` the whole class.

## Surround ([vim-surround](https://github.com/tpope/vim-surround))

| Mapping          | Mnemonic              | Description                                              |
| ---------------- | --------------------- | -------------------------------------------------------- |
| `ys{motion}{ch}` | `y`ou `s`urround      | Add: `ysiw"` → word in quotes, `ysap(` → paragraph in parens |
| `cs{old}{new}`   | `c`hange `s`urround   | Change: `cs"'` → double to single quotes, `cs(]` → parens to brackets |
| `ds{ch}`         | `d`elete `s`urround   | Remove: `ds"` → drop the quotes                          |
| `S{ch}`          | visual mode           | Surround the selection                                   |

Closing char (`)`, `]`, `}`) hugs tight; opening char adds inner spaces. `t` = HTML tag: `cst<div>` retags, `dst` untags.

## Case conversion ([vim-camelsnek](https://github.com/nicwest/vim-camelsnek), commands over selection or word under cursor)

| Command   | Alias              | Result                          |
| --------- | ------------------ | ------------------------------- |
| `:Snek`   | `:ConvertToSnek`   | `foo bar` → `foo_bar`           |
| `:Camel`  | `:ConvertToCamel`  | `foo bar` → `FooBar`            |
| `:CamelB` | `:ConvertToCamelB` | `foo bar` → `fooBar`            |
| `:Kebab`  | `:ConvertToKebab`  | `foo bar` → `foo-bar`           |
| `:Screm`  | `:ConvertToScrem`  | `foo bar` → `FOO_BAR`           |

## Text objects (treesitter, work with any operator)

| Object      | Description               | Examples                                    |
| ----------- | ------------------------- | ------------------------------------------- |
| `af` / `if` | function (outer / inner)  | `gcaf` comment it, `daf` delete it, `yif` yank its body |
| `ac` / `ic` | class (outer / inner)     | `vac` select it                             |
| `aa` / `ia` | argument (outer / inner)  | `cia` rewrite an argument, `daa` remove it with its comma |

Movements and swaps (`]m`, `[[`, `<leader>a`...) are in the README's Treesitter section.
