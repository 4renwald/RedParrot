" Enable mouse support in normal and visual mode
set mouse=nv

" Set the terminal type for proper mouse support
if !has('nvim')
    set ttymouse=xterm2
endif

" Enable line numbers
set number

" Enable syntax highlighting
syntax on

" Set tab width to 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Enable auto-indentation
set autoindent

" Show matching brackets
set showmatch

" Enable incremental search
set incsearch

" Highlight search results
set hlsearch

" Enable case-insensitive search
set ignorecase
set smartcase

" Enable line wrapping
set wrap

" Enable ruler (show cursor position)
set ruler

" Enable status line
set laststatus=2

" Enable wildmenu for command-line completion
set wildmenu

" Set color scheme (you can change this to your preferred scheme)
colorscheme default

" Enable clipboard support (if available)
if has('clipboard')
    set clipboard=unnamed
endif

" Enable backspace in insert mode
set backspace=indent,eol,start