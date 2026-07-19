# Registers — where yanks, deletes and macros live

Every yank/delete lands in a register; `"{reg}` before an operator picks which one. `:registers` shows them all.
This config keeps the OS clipboard **separate** (`clipboard=unnamedplus` off): `<leader>y` / `<leader>p` bridge to it explicitly.

## Using a register

| Keys           | Description                                                     |
| -------------- | --------------------------------------------------------------- |
| `"ayy`         | Yank line into register `a`                                      |
| `"Ayy`         | **Append** to register `a` (uppercase = append, works for any op) |
| `"ap` / `"aP`  | Paste register `a` after / before cursor                         |
| `:registers`   | Inspect all registers (`:reg ab` for just `a` and `b`)           |
| `<C-r>a`       | Insert register `a` in **insert or cmdline** mode                |
| `<C-r><C-w>`   | Insert word under cursor into cmdline (great for `:%s/`)         |

## The special registers

| Register  | Description                                                              |
| --------- | ------------------------------------------------------------------------ |
| `""`      | Unnamed — every yank/delete lands here; bare `p` pastes it               |
| `"0`      | **Yank register** — last yank only, deletes never touch it               |
| `"1`–`"9` | Delete history — `"1` last big delete, shifts down each time             |
| `"-`      | Small deletes (less than one line): `x`, `daw`...                        |
| `"+`      | System clipboard (`<leader>y` / `<leader>p` in this config)              |
| `"*`      | Primary selection — on macOS same as `"+`                                |
| `"_`      | Black hole — delete without clobbering anything: `"_dd`                  |
| `".`      | Last inserted text (read-only)                                           |
| `"%`      | Current file name (read-only)                                            |
| `":`      | Last ex command (read-only; `@:` repeats it)                             |
| `"/`      | Last search pattern (writable with `:let @/ = 'foo'`)                    |
| `"=`      | Expression register — `<C-r>=` in insert: type `2*21<CR>` → inserts `42` |

## Macros are just registers

`q{a-z}` records keystrokes into that register, `q` stops, `@a` plays, `@@` repeats the last one, `5@a` plays 5 times.
Because a macro *is* register text: `"ap` pastes it, edit the keystrokes in the buffer, `"ay$` yanks it back — macro fixed.
`qA` appends to an existing macro instead of re-recording.

## Recipes

**Paste over a selection without losing the yank**: `viwp` clobbers `""` with the replaced text — next paste is wrong.
Use `viw"0p` (yank register survives) or delete into the void first: `viw"_dP`.

**Repeated paste-over**: after one yank, `"0p` on every target — deletes in between never pollute `"0`.

**Recover an older delete**: `:reg 1-9`, find it, `"3p`. Or paste `"1p`, wrong one? `u` then `"2p`, `u`, `"3p`...
(`.` after `"1p` actually pastes `"2`, `"3`... in sequence — numbered-register rotation).

**Delete without side effects**: `"_d{motion}` when you're about to paste and don't want the delete stealing `""`.

**Search-driven substitution**: `*` on a word, then `:%s//new/g` — empty pattern reuses `"/`. Or `<C-r>/` in the cmdline to edit it.

Notes: registers `a-z`, `0-9`, `-`, `+`, `*`, `/` persist across sessions in shada. `<leader>y`/`<leader>p` are normal-mode only
(`lua/custom/remap.lua`) — in visual mode use `"+y` directly. `y` also copies into `"0` *and* `""`; deletes go to `""` plus
`"1`–`"9` (linewise) or `"-` (small). For position bookmarks rather than text, see [marks](marks.md).
