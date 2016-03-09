set shell=/bin/bash

" Vundle
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Bundle 'hsanson/vim-android'
Plugin 'vim-scripts/L9'
Plugin 'vim-scripts/FuzzyFinder'
Plugin 'bronson/vim-trailing-whitespace'

call vundle#end()
filetype plugin indent on

" Everything Else
syntax on
set tabstop=2
set smarttab
set expandtab
set softtabstop=2
set shiftwidth=2

" Key Binds
let mapleader=" "
noremap <Leader>n :NERDTreeToggle<CR>

noremap <Leader>h <C-w>h
noremap <Leader>j <C-w>j
noremap <Leader>k <C-w>k
noremap <Leader>l <C-w>l

" Airline stuff
set laststatus=2
let g:airline_theme='luna'
let g:airline_powerline_fonts = 1
