vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>')

return {
  'folke/zen-mode.nvim',
  opts = {
    window = {
      width = 80,
    },
    on_open = function(win)
      vim.opt.linebreak = true
      vim.opt.wrap = true
    end,
    on_close = function()
      vim.opt.linebreak = false
      vim.opt.wrap = false
    end,
  },
}
