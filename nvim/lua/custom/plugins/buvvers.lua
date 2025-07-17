vim.keymap.set('n', '<leader>bt', function()
  require('buvvers').toggle()
end)
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<cr>')

vim.keymap.set('n', '<leader>i', '<cmd>bnext<cr>')
vim.keymap.set('n', '<leader>o', '<cmd>bprevious<cr>')

return {
  'aidancz/buvvers.nvim',
  opts = {},
  setup = function()
    require('buvvers').setup()
  end,
}
