" Setup Plugins Support {
    set nocompatible  " enable all features, required here by Vundle
    filetype off      " required here

    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
" }

" Plugins {
    " Dependencies {
        Plugin 'gmarik/Vundle.vim'  " let Vundle manage Vundle, required
        Plugin 'tpope/vim-repeat'   " required by surround, commentary
    " }

    " Appareance {
        Plugin 'altercation/vim-colors-solarized'
        Plugin 'zhaocai/GoldenView.Vim'
    " }

    " Movements {
        Plugin 'sickill/vim-pasta'
        Plugin 'tpope/vim-surround'
        Plugin 'tpope/vim-commentary'
    " }

    " Navigation {
        Plugin 'kien/ctrlp.vim'
        Plugin 'scrooloose/nerdtree'
    " }

    " Integrations {
        Plugin 'tpope/vim-fugitive' " Git
    " }

    " Completion {
        Plugin 'Shougo/neocomplete'
    " }

    " Snippets {
        Plugin 'honza/vim-snippets'
        Plugin 'Shougo/neosnippet-snippets'
        Plugin 'Shougo/neosnippet.vim'
    " }

    " Code specific {
        " HTML {
            Plugin 'mattn/emmet-vim'
        " }

        " Markdown {
            Plugin 'tpope/vim-markdown'
        " }

        " Python {
            Plugin 'klen/python-mode'
        " }

        " Go {
            Plugin 'jnwhiteh/vim-golang'
        " }

        " PHP {
            Plugin 'spf13/PIV'
        " }
    " }

    call vundle#end()
    filetype plugin indent on    " required
" }

" Plugin's configurations {
    " Colorscheme and background
    set background=dark
    colorscheme solarized

    " Map NERDTree
    nmap <leader>n :NERDTreeToggle<cr>

    " Enable neocomplete
    let g:neocomplete#enable_at_startup = 1

    " Enable Python-mode
    let g:pymode = 1

    " ctrlp config
    let g:ctrlp_cmd = 'CtrlPMixed'
" }

" Mappings {
    " Remove search hilighting with ^N
    nmap <silent> <C-N> :silent noh<CR>

    " Control + t opens a new tab
    nmap <C-T> :tabnew<CR>

    " Control+<movement> to move between windows
    map <c-j> <c-w>j
    map <c-k> <c-w>k
    map <c-l> <c-w>l
    map <c-h> <c-w>h
" }

" Sane defaults {
    " The following are commented out as they cause vim to behave a lot
    " differently from regular Vi. They are highly recommended though.
    set nocompatible                  " enable all features

    syntax on                         " syntax highlighting
    set title                         " Set window title
    set showcmd                       " Show (partial) command in status line.
    set showmatch                     " Show matching brackets.
    set ignorecase                    " Do case insensitive matching
    set smartcase                     " Do smart case matching
    set hidden                        " Hide buffers when they are abandoned
    set ttymouse=xterm2               " tty mouse xterm
    set mouse=a                       " Enable mouse usage (all modes) in terminals
    set backspace=indent,eol,start    " :help i_backsp and :h 'backspace' for more info
    set tabstop=4                     " Number of spaces for the tabstop
    set shiftwidth=4                  " (Auto)indent uses 2 characters
    set expandtab                     " spaces instead of tabs
    set autoindent                    " guess indentation
    set hlsearch                      " highlight the searchterms
    set textwidth=0                   " don't wrap words
    set ruler                         " show ruler
    set number                        " show line numbers
    set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [FMT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
    set laststatus=2
" }

" Custom behaviour {
    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
      au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
        \| exe "normal g'\"" | endif
    endif

    " disable expand tabs for makefiles
    au FileType make setlocal noexpandtab

    " Mark trailing spaces
    set list listchars=tab:->,trail:.,extends:>
" }

" Environment fixes {
    if &term == "screen"
       exec "set t_kN=\<ESC>[6;*~"
       exec "set t_kP=\<ESC>[5;*~"
    endif
" }

" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker:
