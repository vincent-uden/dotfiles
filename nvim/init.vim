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
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'https://gitlab.com/yorickpeterse/vim-paper.git'

Plug 'glepnir/lspsaga.nvim'
Plug 'simrat39/symbols-outline.nvim'

Plug 'neovim/nvim-lspconfig'
Plug 'MunifTanjim/nui.nvim'
Plug 'ShinKage/idris2-nvim'

" Neovim Tree sitter
Plug 'nvim-treesitter/nvim-treesitter'
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

Plug 'jxnblk/vim-mdx-js'

Plug 'Tetralux/odin.vim'

" Formatting
Plug 'junegunn/vim-easy-align'

Plug 'feline-nvim/feline.nvim'

Plug 'folke/zen-mode.nvim'

" Movement
Plug 'jinh0/eyeliner.nvim'
Plug 'codota/tabnine-nvim', { 'do': './dl_binaries.sh' }

call plug#end()

colorscheme catppuccin
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
nnoremap <leader>pd :Lexplore<CR>

nnoremap j gj
nnoremap k gk
nnoremap H ^
nnoremap L $

nnoremap ya ggVG"+y<C-O>

xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

au FileType typescriptreact setl sw=2 sts=2
au FileType js setl sw=2 sts=2
au FileType typescript setl sw=2 sts=2
au FileType cpp setl sw=2 sts=2
au FileType hpp setl sw=2 sts=2
au FileType astro setl sw=2 sts=2
au FileType astro nnoremap <leader>c :!prettier --write . --plugin=prettier-plugin-astro<CR>
au FileType typescriptreact nnoremap <leader>c :!npx prettier --write "%"<CR>
au FileType typescript nnoremap <leader>c :!npx prettier --write "%"<CR>

let g:tex_flavor = 'tex'
au FileType tex nnoremap <leader>c :w<CR>:!xelatex "%"<CR>
au FileType tex nnoremap <leader>p :!zathura '%:r'.pdf --fork<CR>

au FileType rust nnoremap <leader>c :!cargo fmt<CR>

au FileType idris2 nnoremap <leader>c :!idris2 --build<CR>

let g:user_emmet_mode='n'
let g:user_emmet_leader_key='<Space>'

let g:gitgutter_signs=0
let g:gitgutter_highlight_linenrs=1

autocmd BufRead,BufNewFile * setlocal signcolumn=no

autocmd BufRead,BufEnter *.astro set filetype=astro
autocmd BufRead,BufEnter *.astro set syntax=typescriptreact

let g:gitgutter_map_keys = 0
highlight GitGutterAddLineNr guifg=lightgreen
highlight GitGutterChangeLineNr guifg=orange
highlight GitGutterDeleteLineNr guifg=lightred
highlight GitGutterChangeDeleteLineNr guifg=lightred

let g:netrw_keepdir = 0
let g:netrw_winsize = 30
let g:netrw_banner = 0
let g:netrw_liststyle = 3

set mouse=

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
