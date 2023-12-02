vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.gd"},
  callback = function(ev)
    vim.cmd('setl shiftwidth=4 expandtab tabstop=4 softtabstop=4')
  end
})

vim.cmd("autocmd TermOpen * startinsert")
