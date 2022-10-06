local Remap = require("xor.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<leader>pb", function()
    require('telescope.builtin').buffers()
end)
nnoremap("<Leader>pf", function()
    require('telescope.builtin').find_files()
end)

