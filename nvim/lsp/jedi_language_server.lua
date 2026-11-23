---@type vim.lsp.Config
return {
  cmd = { 'jedi-language-server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'uv.lock', '.git' },

  before_init = function(params, config)
    local root = config.root_dir
    local python = root and (root .. '/.venv/bin/python')

    if python and vim.fn.executable(python) == 1 then
      params.initializationOptions = vim.tbl_deep_extend(
        'force',
        params.initializationOptions or {},
        { workspace = { environmentPath = python } }
      )
    end
  end,
}
