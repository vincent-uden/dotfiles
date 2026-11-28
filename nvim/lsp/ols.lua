---@type vim.lsp.Config
return {
  cmd = { 'ols' },
  filetypes = { 'odin' },
  -- ols only reads <root>/ols.json (and resolves relative collection paths such
  -- as "./src/third-party") when the client tells it what the project root is.
  -- Without this, rootUri is null and ols falls back to its process cwd, so
  -- "third-party:..." imports fail with "Unknown library collection".
  root_markers = { 'ols.json', '.git' },
}
