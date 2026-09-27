# herdr-nvim — annotations for herdr agents

[herdr-nvim](https://github.com/ChmaraX/herdr-nvim) has two halves. The herdr plugin gives a persistent nvim sidebar per tab and a picker over the files the agent touched. The nvim plugin lets you comment lines like a code review and send them all to an agent (claude, codex, pi) with `file:line` and git context. Config in `lua/custom/plugins/herdr-nvim.lua`.

The plugin's default prefix `<leader>a` collides with sidekick, Sidekick is disabled, so the maps live under `<leader>a` and mirror the old sidekick layout.

## herdr keys (`~/.config/herdr/config.toml`)

| Key        | Action                                                   |
| ---------- | -------------------------------------------------------- |
| `prefix+n` | Toggle the nvim sidebar (panes move left, nvim on right) |
| `prefix+f` | Fuzzy picker: agent-touched files first, then whole repo |

Pane movement (`prefix+h/j/k/l`, `prefix+w`, `prefix+g`, swap with `prefix+H/J/K/L`) is plain herdr, not this plugin — see [buffers-keybinds.md](buffers-keybinds.md).

## nvim keymaps

| Mapping      | Mode          | Description                                                   |
| ------------ | ------------- | ------------------------------------------------------------- |
| `<leader>ac` | normal/visual | Comment the current line, or the selection                    |
| `<leader>av` | visual        | Comment the Visual selection                                  |
| `<leader>al` | normal        | List pending comments (float): hover jumps, `⏎` edit, `d` delete |
| `<leader>as` | normal        | Send: paste all comments into the agent input (no submit)     |
| `<leader>aS` | normal        | Submit: send all comments and run them                        |
| `<leader>at` | normal/visual | Comment This line / selection **and submit** in one go, like sidekick `<leader>at` (custom, not in the plugin) |
| `<leader>aT` | normal/visual | Same as `<leader>at` but only pastes into the agent input, no Enter: keep typing, then submit yourself (custom) |

`:Herdr comment|list|send|submit` do the same (`:5,10Herdr comment` takes a range).

Comments are in-memory only, follow your edits (extmarks) and are cleared after a successful send. Pending count shows in lualine as `● N`.

Sending skips the agent picker when the target is obvious (the only agent, or the one sharing the tab).

Doctor: `herdr-nvim doctor` (or `--with-agent claude`).
