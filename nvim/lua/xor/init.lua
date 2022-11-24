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
