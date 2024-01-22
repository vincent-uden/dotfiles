vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

local one_monokai = {
	fg       = "#CDD6F4",
	bg       = "#1E1E2F",
	green    = "#A5E3A1",
	yellow   = "#F0E2AF",
	purple   = "#F5C2E7",
	orange   = "#D08770",
	peanut   = "#8FBCBB",
	red      = "#F38BA8",
	aqua     = "#94E2D5",
	darkblue = "#94E2D5",
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

require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

vim.api.nvim_create_user_command("DefineFunction",
    function()
        vim.cmd("normal [{b\"wyw") -- copy the class name
        local keys = vim.api.nvim_replace_termcodes('<C-o>yy<C-w><C-h>p<<_w"wPxi::<Esc>$C {<CR>}<CR><Esc><C-w><C-l>', false, false, true)
        vim.api.nvim_feedkeys(keys, "n", {})
    end,
    {}
)
