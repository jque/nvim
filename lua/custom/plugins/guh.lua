-- guh.nvim hardcodes `botright vertical split` for the prcomments panel
-- (guh/comments.lua), which lands it to the RIGHT of nvim-tree (side="right"),
-- breaking the tree-at-the-edge layout and <C-l> edge delegation to herdr.
-- Re-anchor the panel next to the diff window instead.
local comments = require('guh.comments')
local show_pr_comments = comments.show_pr_comments

function comments.show_pr_comments(id, repo, diff_buf)
  show_pr_comments(id, repo, diff_buf)
  local buf = require('guh.state').get_buf('prcomments', repo, id, false)
  local comments_win = buf and vim.fn.win_findbuf(buf)[1]
  local diff_win = vim.fn.win_findbuf(diff_buf)[1]
  if comments_win and diff_win then
    vim.fn.win_splitmove(comments_win, diff_win, { vertical = true, rightbelow = true })
  end
end
