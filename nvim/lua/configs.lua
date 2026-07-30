local opt = vim.opt

-- Faster fzf on Windows: set default command
-- Use ripgrep if available (faster than find), otherwise use improved find
local fzf_cmd = vim.fn.executable 'rg' == 1 and 'rg --files --hidden --glob !.git/ --glob !node_modules/ --glob !target/'
  or 'find . -type f -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/target/*"'
vim.env.FZF_DEFAULT_COMMAND = fzf_cmd
-- Also set for CtrlP mode if used
vim.env.FZF_CTRL_T_COMMAND = fzf_cmd
vim.env.FZF_ALT_C_COMMAND = 'fd --type d --hidden --not-ignore-git -E .git -E node_modules -E target'

opt.termguicolors = true
opt.ignorecase = true
opt.swapfile = false

opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true

opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes:1'

opt.wrap = false
opt.cursorline = true
opt.scrolloff = 4

opt.inccommand = 'nosplit'
opt.undodir = (os.getenv 'HOME' or os.getenv 'USERPROFILE') .. '/.vim/undodir'
opt.undofile = true

opt.completeopt = { 'menuone', 'popup', 'noinsert' } -- Options for completion menu

vim.cmd.filetype 'plugin indent on'

vim.cmd.colorscheme 'tokyonight-night' -- marker[colorscheme]
vim.o.background = 'dark' -- marker[background]