# nvim config

### Introduction

Custom version of [https://github.com/nvim-lua/kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

### nvim-tree

| Mappings | Description |
| --- | --- |
| R | (refresh) to perform a reread of the files contained in the project |
| H | (hide) to hide/display hidden files and folders (beginning with a dot .) |
| E | (expand_all) to expand the entire file tree starting from the root folder (workspace) |
| W | (collapse_all) to close all open folders starting from the root folder |
| - | (dir_up) allows you to go back up folders. This navigation also allows you to exit the root folder (workspace) to your home directory |
| s | (system) to open the file with the system application set by default for that file type |
| f | (find) to open the interactive file search to which search filters can be applied |
| F | to close the interactive search |
| Ctrl + k | to display information about the file such as size, creation date, etc. |
| g + ? | to open the help with all the predefined shortcuts for quick reference |
| q | to close the file explorer |


### Avante

| Mappings | Description |
| --- | --- |
| <leader>a | Activate the Avante prompt |
| <leader>aa | Open the Avante chat window |
| <leader>ac | Send the selected code to Claude |
| <leader>ae | Explain the selected code |
| <leader>ar | Request a code review for the selection |
| <leader>af | Fix or improve the selected code |
| <leader>ad | Generate documentation for the selection |
| <leader>at | Generate tests for the selected code |


### LSP

| Mappings | Description |
| --- | --- |
| <leader>rn | [R]e[n]ame |
| <leader>do | [C]ode [A]ction |
| <leader>gd | [G]oto [D]efinition |
| <leader>gr | [G]oto [R]eferences |
| <leader>gi | [G]oto [I]mplementation |
| <leader>D | Type [D]efinition |
| <leader>ds | [D]ocument [S]ymbols |
| <leader>ws | [W]orkspace [S]ymbols |
| gD | [G]oto [D]eclaration |
| gd | [G]oto [D]efinition |
| <C-k> | Signature Documentation |
| <leader>wa | [W]orkspace [A]dd Folder |
| <leader>wr | [W]orkspace [R]emove Folder |
| <leader>wl | [W]orkspace [L]ist Folders |


### Copilot

| Mappings | Description |
| --- | --- |
| <C-y> | Accept suggestion |
| <C-]> | Dismiss suggestion |
| <C-j> | Accept word |


### code suggestions
- https://codeium.com/
- https://supermaven.com/
- https://github.com/augmentcode/augment.vim
