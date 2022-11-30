call plug#begin('~/.vim/plugged')
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind.nvim'

Plug 'EdenEast/nightfox.nvim'
Plug 'shaunsingh/nord.nvim'

Plug 'glepnir/lspsaga.nvim'
Plug 'simrat39/symbols-outline.nvim'

" Neovim Tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'romgrk/nvim-treesitter-context'

" Git
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'https://github.com/airblade/vim-gitgutter'

" Languages
Plug 'rust-lang/rust.vim'

Plug 'sbdchd/neoformat'

Plug 'L3MON4D3/LuaSnip'

Plug 'mattn/emmet-vim'

" Formatting
Plug 'junegunn/vim-easy-align'

Plug 'feline-nvim/feline.nvim'

call plug#end()

colorscheme nord
highlight Normal guibg=none

let mapleader = " "
nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep for > ") })<CR>
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
nnoremap <leader>M :noh<CR>
nnoremap <leader>wv :vsplit<CR>
nnoremap <leader>ws :split<CR>
nnoremap <leader>. :e .<CR>
nnoremap <leader>h <C-W><C-H>
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>f za

nnoremap j gj
nnoremap k gk
nnoremap H ^
nnoremap L $

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

au FileType typescriptreact setl sw=2 sts=2
au FileType js setl sw=2 sts=2
au FileType typescript setl sw=2 sts=2
au FileType typescriptreact nnoremap <leader>c :!npx prettier --write %<CR>
au FileType typescript nnoremap <leader>c :!npx prettier --write %<CR>
au FileType css nnoremap <leader>c :!npx prettier --tab-size 4 --write %<CR>

let g:tex_flavor = 'tex'
au FileType tex nnoremap <leader>c :w<CR>:!xelatex <C-r>%<CR>
au FileType tex nnoremap <leader>p :!zathura %:r.pdf --fork<CR><CR>

au FileType rust nnoremap <leader>c :!cargo fmt<CR>

let g:user_emmet_mode='n'
let g:user_emmet_leader_key='<C-F>'

set termguicolors
let g:gitgutter_signs=0
let g:gitgutter_highlight_linenrs=1

autocmd BufRead,BufNewFile * setlocal signcolumn=no

highlight GitGutterAddLineNr guifg=lightgreen
highlight GitGutterChangeLineNr guifg=orange
highlight GitGutterDeleteLineNr guifg=lightred
highlight GitGutterChangeDeleteLineNr guifg=lightred

fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

augroup XOR
    autocmd!
    autocmd BufWritePre * :call TrimWhitespace()
augroup END

lua require('xor')
