# Sidekick — keybinds

> **Disabled.** sidekick is commented out in `lua/custom/package.lua`; `<leader>a` now belongs to [herdr-nvim](herdr-nvim.md). Config kept in `lua/custom/plugins/sidekick.lua` to re-enable.

[sidekick.nvim](https://github.com/folke/sidekick.nvim) integrates AI CLI agents (Claude, Codex, Copilot...) in a side window inside nvim (`layout = left`, 100 columns). Config in `lua/custom/plugins/sidekick.lua`.

## Global (from any buffer)

| Mapping      | Mode                          | Description                                            |
| ------------ | ----------------------------- | ------------------------------------------------------ |
| `<C-.>`      | normal/insert/visual/terminal | Toggle the agent window                                |
| `<leader>aa` | normal                        | Toggle CLI                                             |
| `<leader>as` | normal                        | Select CLI session (pick agent)                        |
| `<leader>ad` | normal                        | Close/detach the active CLI session                    |
| `<leader>at` | normal/visual                 | Send the current context (`{this}`)                    |
| `<leader>af` | normal                        | Send the current file (`{file}`)                       |
| `<leader>av` | visual                        | Send the visual selection (`{selection}`)              |
| `<leader>ap` | normal/visual                 | Open the prompt picker (predefined prompts + context)  |
| `<leader>aq` | normal/visual                 | Ask directly (free input)                              |
| `<leader>ar` | normal                        | Focus the agent window                                 |

## Inside the agent window (buffer-local)

| Mapping   | Mode            | Description                                                      |
| --------- | --------------- | ---------------------------------------------------------------- |
| `<C-p>`   | normal/terminal | Prompt picker — predefined prompts + context                     |
| `<C-b>`   | normal/terminal | Buffer picker — inserts the chosen buffer into the agent prompt  |
| `<C-f>`   | normal/terminal | File picker — inserts the chosen file into the prompt            |
| `<C-.>`   | normal/terminal | Hide the agent window                                            |
| `<C-z>`   | normal/terminal | Go back to the previous window without hiding the agent          |
| `q` / `<C-q>` | normal      | Hide the agent window                                            |
| `<C-q>`   | terminal        | Exit to normal mode (scroll, copy, etc.)                         |
| `<CR>`    | normal          | Send `<CR>` to the terminal and go back to insert mode           |
| `<C-h>` `<C-j>` `<C-k>` `<C-l>` | terminal | Move to the neighboring window (like regular splits) |

Notes: `<C-p>`, `<C-b>` and `<C-f>` are sidekick's defaults; the prompt picker is also available from any buffer via `<leader>ap`. Buffer/file pickers insert the path as context into the agent prompt; they don't switch buffers.
