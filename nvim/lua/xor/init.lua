vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local one_monokai = {
	fg       = "#E5E9F0",
	bg       = "#2E3440",
	green    = "#A3BE8C",
	yellow   = "#EBCB8B",
	purple   = "#B48EAD",
	orange   = "#D08770",
	peanut   = "#8FBCBB",
	red      = "#BF616A",
	aqua     = "#88C0D0",
	darkblue = "#5E81AC",
	dark_red = "#BF616A",
}

require('feline').setup{theme=one_monokai}

local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
ft_to_parser.astro = "tsx"

require('zen-mode').setup {
    window = {
        backdrop = 1,
        width = 80,
    }
}

require('idris2').setup({})

require('eyeliner').setup {
    highlight_on_key =  true,
    dim = true
}

require('tabnine').setup({
  disable_auto_comment=true,
  accept_keymap="<C-i>",
  dismiss_keymap = "<C-o>",
  debounce_ms = 800,
  suggestion_color = {gui = "#808080", cterm = 244},
  exclude_filetypes = {"TelescopePrompt", "NvimTree"},
  log_file_path = nil, -- absolute path to Tabnine log file
})
