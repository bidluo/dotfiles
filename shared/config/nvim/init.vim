call plug#begin()
Plug 'numkil/ag.nvim'
Plug 'scrooloose/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'

call plug#end()

" Options
let g:airline_powerline_fonts = 1
" let g:airline_theme='gruvbox'

" colorscheme gruvbox
set bg=dark
set ttyfast
set autoindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set backspace=indent,eol,start
set showmatch
set hlsearch
set updatetime=100
set laststatus=2

nnoremap <silent> <Leader>+ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <Leader>- :exe "resize " . (winheight(0) * 2/3)<CR>

" Key Binds
let mapleader=" "
noremap <Leader>n :NERDTreeToggle<CR>
noremap <Leader>t :CtrlP<CR>
noremap <Leader>m :set invnumber<CR>
noremap <Leader>O :OR<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gds :Gdiffsplit<CR>

noremap <Leader>ce :e $MYVIMRC<CR>
noremap <Leader>cr :source $MYVIMRC<CR>

nmap ghs <Plug>(GitGutterStageHunk)
nmap ghu <Plug>(GitGutterUndoHunk)

" bind K to grep word under cursor
nnoremap <Leader>K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
nnoremap \\ :Ag<SPACE>

" ctrlp
let g:ctrlp_match_window = 'bottom,order:ttb'
let g:ctrlp_switch_buffer = 0
let g:ctrlp_working_path_mode = 0
let g:ctrlp_user_command = 'ag %s -l --ignore-dir Carthage --ignore-dir node_modules --nocolor --hidden -g ""'

" nerdtree
let g:NERDTreeIgnore = ['^build$', '^node_modules$']

" The Silver Searcher
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_use_caching = 0
endif
