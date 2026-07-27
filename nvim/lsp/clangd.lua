---@type vim.lsp.Config
return {
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "h" },
	root_markers = { ".git", "compile_commands.json", "compile_flags.txt", "build/compile_commands.json" },
}
