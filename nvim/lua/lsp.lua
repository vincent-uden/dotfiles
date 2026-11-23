-- ~/.config/nvim-new/lua/lsp.lua
vim.lsp.enable {
  'clangd',
  'lua_ls',
  'rust-analyzer',
  'zls',
  'vtsls',
  'tinymist',
  'ols',
  'ruff',
  'jedi_language_server',
}
vim.diagnostic.config { virtual_text = false }
