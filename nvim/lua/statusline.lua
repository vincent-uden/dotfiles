Statusline = {}

-- LSP progress tracking
local lsp_progress = {}

vim.api.nvim_create_autocmd('LspProgress', {
  group = vim.api.nvim_create_augroup('StatuslineLspProgress', { clear = true }),
  callback = function(ev)
    if not ev.data or not ev.data.params then
      return
    end

    local client_id = ev.data.client_id
    local token = ev.data.params.token
    local value = ev.data.params.value
    local kind = value and value.kind

    if not kind or not token then
      return
    end

    if kind == 'begin' then
      lsp_progress[client_id] = lsp_progress[client_id] or {}
      lsp_progress[client_id][token] = value.title or 'working'
    elseif kind == 'end' then
      if lsp_progress[client_id] then
        lsp_progress[client_id][token] = nil
        if next(lsp_progress[client_id]) == nil then
          lsp_progress[client_id] = nil
        end
      end
    end

    vim.cmd.redrawstatus()
  end,
})

-- Highlight groups for LSP status (yellow in-progress, green done)
local hl_group = vim.api.nvim_create_augroup('StatuslineHighlights', { clear = true })

local function setup_highlights()
  vim.api.nvim_set_hl(0, 'StatuslineLspProgress', { link = 'DiagnosticWarn' })
  vim.api.nvim_set_hl(0, 'StatuslineLspOk', { link = 'DiagnosticOk' })
end

setup_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = hl_group,
  callback = setup_highlights,
})

local function git()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == '' then
    return ''
  end

  local head = git_info.head
  local added = git_info.added and (' +' .. git_info.added) or ''
  local changed = git_info.changed and (' ~' .. git_info.changed) or ''
  local removed = git_info.removed and (' -' .. git_info.removed) or ''
  if git_info.added == 0 then
    added = ''
  end
  if git_info.changed == 0 then
    changed = ''
  end
  if git_info.removed == 0 then
    removed = ''
  end

  return table.concat {
    '[ ', -- branch icon
    head,
    added,
    changed,
    removed,
    ']',
  }
end

local function lsp_status()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    return ''
  end

  for _, client in ipairs(clients) do
    local progress = lsp_progress[client.id]
    if progress and next(progress) ~= nil then
      for _, title in pairs(progress) do
        return '%#StatuslineLspProgress#[ ' .. title .. ']%#Statusline#'
      end
    end
  end

  return '%#StatuslineLspOk#[ OK]%#Statusline#'
end

function Statusline.active()
  local lsp = lsp_status()
  return table.concat {
    '[%f] ',
    git(),
    '%=',
    lsp ~= '' and ' ' .. lsp or '',
    '%y [%P %l:%c]',
  }
end

function Statusline.inactive()
  return ' %t'
end

local group = vim.api.nvim_create_augroup('Statusline', { clear = true })

vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
  group = group,
  desc = 'Activate statusline on focus',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.Statusline.active()'
  end,
})

vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
  group = group,
  desc = 'Deactivate statusline when unfocused',
  callback = function()
    vim.opt_local.statusline = '%!v:lua.Statusline.inactive()'
  end,
})
