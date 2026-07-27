---@type vim.lsp.Config
return {
  cmd = vim.fn.has 'win32' == 1
      and { 'C:\\Users\\vincentud\\.rustup\\toolchains\\nightly-x86_64-pc-windows-msvc\\bin\\rust-analyzer.exe' }
      or { '/home/vincent/.cargo/bin/rust-analyzer' },
  settings = {
    ['rust-analyzer'] = {
      files = { watcher = 'server' },
      cargo = { targetDir = true },
    },
  },
  filetypes = { 'rust' },
  root_markers = { 'Cargo.toml', 'rust-project.json' },
}
