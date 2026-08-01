vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})

-- Gitsigns
vim.pack.add {
  { src = 'https://github.com/lewis6991/gitsigns.nvim' },
}

require('gitsigns').setup { signcolumn = true }

-- Mason
vim.pack.add {
  { src = 'https://github.com/mason-org/mason.nvim' },
}

require('mason').setup {
  opts = {
    ensure_installed = {
      'tinymist',
    },
  },
}

vim.pack.add {
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '^1' },
}

-- Blink
-- TODO: Make the rust version work
require('blink.cmp').setup {
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
  keymap = {
    preset = 'default',
    -- Reset some bindings
    ['<C-space>'] = {},
    ['<Tab>'] = {},
    ['<S-Tab>'] = {},
    -- Add my own
    ['<C-y>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-a>'] = { 'select_and_accept' },
    ['<C-p>'] = { 'select_prev', 'fallback' },
    ['<C-n>'] = { 'select_next', 'fallback' },
    ['<C-b>'] = { 'scroll_documentation_down', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_up', 'fallback' },
  },

  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = 'normal',
  },

  completion = {
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 200,
    },
  },

  cmdline = {
    keymap = {
      preset = 'inherit',
      ['<CR>'] = { 'accept_and_enter', 'fallback' },
    },
  },

  sources = { default = { 'lsp' } },
}

-- Tokyo Night
vim.pack.add {
  { src = 'https://github.com/folke/tokyonight.nvim' },
}

require('tokyonight').setup {}

-- Plenary (required by telescope)
vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
}

-- Force plenary to load before telescope
require 'plenary'

-- Telescope
vim.pack.add {
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
}

require('telescope').setup {
  defaults = {
    sorting_strategy = 'ascending',
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'bottom',
        preview_width = 0.4,
        results_width = 0.9,
      },
    },
  },
}

-- FFF - Fast file finder (Rust-based, fast on Windows)
vim.pack.add {
  { src = 'https://github.com/dmtrKovalenko/fff.nvim' },
}

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd 'fff.nvim'
      end
      require('fff.download').download_or_build_binary()
    end
  end,
})

-- Configure fff
vim.g.fff = {
  lazy_sync = true,
  debug = {
    enabled = false,
    show_scores = false,
  },
  layout = {
    height = 0.8,
    width = 0.8,
    prompt_position = 'bottom',
    preview_position = 'right',
  },
  frecency = {
    enabled = true,
  },
  history = {
    enabled = true,
  },
}

-- Conform.nvim (Autoformatting)
vim.pack.add {
  { src = 'https://github.com/stevearc/conform.nvim' },
}

require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'black' },
    javascript = { 'prettier', 'bun run check:write' },
    typescript = { 'prettier', 'bun run check:write' },
    rust = { 'cargo', 'fmt' },
    odin = { 'odinfmt' },
  },
  format_on_save = function(bufnr)
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end
    return {
      timeout_ms = 500,
      lsp_format = 'fallback',
    }
  end,
}

vim.api.nvim_create_user_command('FormatDisable', function(args)
  if args.bang then
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, { desc = 'Disable auto-format on save', bang = true })

vim.api.nvim_create_user_command('FormatEnable', function(args)
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, { desc = 'Enable auto-format on save', bang = true })

-- Plenary (dependency of todo-comments)
vim.pack.add {
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
}

-- todo-comments.nvim
vim.pack.add {
  { src = 'https://github.com/folke/todo-comments.nvim' },
}
require('todo-comments').setup {}

-- eyeliner.nvim
vim.pack.add {
  { src = 'https://github.com/jinh0/eyeliner.nvim' },
}
require('eyeliner').setup {
  highlight_on_key = true,
  dim = true,
}

-- comment.nvim
vim.pack.add {
  { src = 'https://github.com/numToStr/Comment.nvim' },
}
require('Comment').setup {
  toggler = {
    line = '<leader>cc',
    block = '<leader>cb',
  },
  opleader = {
    line = '<leader>c',
    block = '<leader>b',
  },
  ignore = '^$',
}

-- outline.nvim
vim.pack.add {
  { src = 'https://github.com/hedyhli/outline.nvim' },
}
require('outline').setup {}

-- nvim-dap
vim.pack.add {
  { src = 'https://github.com/mfussenegger/nvim-dap' },
}

vim.pack.add {
  { src = 'https://github.com/nvim-neotest/nvim-nio' },
}

vim.pack.add {
  { src = 'https://github.com/rcarriga/nvim-dap-ui' },
}

vim.pack.add {
  { src = 'https://github.com/ldelossa/nvim-dap-projects' },
}

local dap = require 'dap'
local dapui = require 'dapui'

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end

vim.api.nvim_create_user_command('DapCloseUi', function()
  require('dapui').close()
end, {})

require('nvim-dap-projects').config_paths = { '.nvim-dap.lua' }
require('nvim-dap-projects').search_project_config()

-- treesitter
vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c3' },
  callback = function()
    vim.treesitter.start()
  end,
})

-- neogit
vim.pack.add {
  { src = 'https://github.com/sindrets/diffview.nvim' },
}
require('diffview').setup {}

vim.pack.add {
  { src = 'https://github.com/neogitorg/neogit' },
}
require('neogit').setup {}

-- colorscheme
vim.pack.add {
  { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
}
