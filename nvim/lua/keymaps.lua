local keymap = vim.keymap.set

vim.g.mapleader = ' '

keymap('n', '<Esc>', '<cmd>nohlsearch<CR>')

keymap('n', '<leader>E', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })

-- Splits Navigation
keymap('n', '<leader>h', '<C-w><C-h>', { desc = 'Move focus to the left window' })
keymap('n', '<leader>l', '<C-w><C-l>', { desc = 'Move focus to the right window' })
keymap('n', '<leader>j', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
keymap('n', '<leader>k', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Splitting
keymap('n', '<leader>wv', '<cmd>vsplit<CR>', { desc = 'Vertical split' })
keymap('n', '<leader>ws', '<cmd>split<CR>', { desc = 'Horizontal split' })

-- Line Navigation
keymap('n', 'j', 'gj', { desc = 'Down' })
keymap('n', 'k', 'gk', { desc = 'Up split' })
keymap('n', 'H', '_', { desc = 'Beginning of line' })
keymap('n', 'L', '$', { desc = 'End of line' })

-- Searching (Telescope)
keymap('n', '<leader>pf', function()
  require('telescope.builtin').find_files()
end)
keymap('n', '<leader>ps', function()
  require('telescope.builtin').live_grep()
end)
keymap('n', '<leader>pb', function()
  require('telescope.builtin').buffers()
end)

-- LSP searches (using Telescope)
keymap('n', '<leader>pr', function()
  require('telescope.builtin').lsp_references {
    path_display = { 'smart' },
  }
end)
keymap('n', '<leader>pd', function()
  require('telescope.builtin').lsp_document_symbols()
end)
keymap('n', '<leader>pp', function()
  require('telescope.builtin').lsp_dynamic_workspace_symbols()
end)
keymap('n', '<leader>gd', function()
  require('telescope.builtin').lsp_definitions()
end)

-- Other LSP Stuff
keymap('n', '<leader>rr', vim.lsp.buf.rename)
keymap('n', '<leader>.', vim.lsp.buf.code_action)
keymap('n', '<leader>o', '<cmd>Outline<CR>', { desc = 'Toggle Outline' })

--- Formatting
keymap('n', '<leader>tf', function()
  if vim.g.disable_autoformat then
    vim.cmd 'FormatEnable'
    vim.notify 'Enabled autoformatting'
  else
    vim.cmd 'FormatDisable'
    vim.notify 'Disabled autoformatting'
  end
end)

-- Debugging
keymap('n', '<F4>', function()
  vim.cmd 'DapCloseUi'
end)
keymap('n', '<F5>', function()
  require('dap').continue()
end)
keymap('n', '<F10>', function()
  require('dap').step_over()
end)
keymap('n', '<F11>', function()
  require('dap').step_into()
end)
keymap('n', '<F12>', function()
  require('dap').step_out()
end)
keymap('n', '<leader>b', function()
  require('dap').toggle_breakpoint()
end)

-- Neogit
keymap('n', '<leader>gg', '<cmd>Neogit<cr>', { desc = 'Show Neogit UI' })

-- Build and run
keymap('n', '<F2>', function()
  local cwd = vim.fn.getcwd()
  vim.system({ 'nu', 'build.nu', 'debug' }, { cwd = cwd }, function(obj)
    if obj.code ~= 0 then
      vim.schedule(function()
        vim.notify('Build failed (exit ' .. tostring(obj.code) .. ')', vim.log.levels.ERROR)
      end)
      return
    end
    local executable = vim.fn.has 'win32' == 1 and 'main-hot-reload.exe' or './main-hot-reload.bin'
    vim.schedule(function()
      vim.notify('Build succeeded, launching ' .. executable, vim.log.levels.INFO)
    end)
    vim.system({ executable }, { cwd = cwd }, function(run_obj)
      vim.schedule(function()
        if run_obj.code ~= 0 then
          vim.notify('Run exited with code ' .. tostring(run_obj.code), vim.log.levels.WARN)
        end
      end)
    end)
  end)
end, { desc = 'Full reload' })

keymap('n', '<F3>', function()
  local cwd = vim.fn.getcwd()
  vim.system({ 'nu', 'build.nu', 'hot-reload' }, { cwd = cwd }, function(obj)
    vim.schedule(function()
      if obj.code ~= 0 then
        vim.notify('Hot reload build failed (exit ' .. tostring(obj.code) .. ')', vim.log.levels.ERROR)
      else
        vim.notify('Hot reload build complete', vim.log.levels.INFO)
      end
    end)
  end)
end, { desc = 'Hot reload' })
