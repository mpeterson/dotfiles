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
        Plugin 'Lokaltog/vim-easymotion'
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
        " Go {
            Plugin 'jnwhiteh/vim-golang'
        " }
        " HTML {
            Plugin 'mattn/emmet-vim'
        " }
        " Javascript {
            Plugin 'pangloss/vim-javascript'
            Plugin 'othree/javascript-libraries-syntax.vim'
        " }
        " Markdown {
            Plugin 'tpope/vim-markdown'
        " }
        " PHP {
            Plugin 'spf13/PIV'
        " }
        " Python {
            Plugin 'klen/python-mode'
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
    let g:pymode_rope = 0

    " ctrlp config
    let g:ctrlp_cmd = 'CtrlPMixed'

    " Enable neosnippet compatiblity
    let g:neosnippet#enable_snipmate_compatibility=1
    imap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : (pumvisible() ? "\<C-n>" : "\<TAB>")
    smap <expr><TAB> neosnippet#expandable_or_jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
    imap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
    smap <expr><S-TAB> pumvisible() ? "\<C-p>" : ""
" }

" Custom functions/helpers {
      function! EnsureExists(path) " {
          if !isdirectory(expand(a:path))
              call mkdir(expand(a:path))
          endif
      endfunction " }
      " detect OS { 
        let s:is_windows = has('win32') || has('win64')
        let s:is_cygwin = has('win32unix')
        let s:is_macvim = has('gui_macvim')
      " }
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
    set nocompatible                                    " enable all features

    syntax on                                           " syntax highlighting
    set title                                           " Set window title
    set showcmd                                         " Show (partial) command in status line.
    set showmatch                                       " Show matching brackets.
    set ignorecase                                      " Do case insensitive matching
    set smartcase                                       " Do smart case matching
    set hidden                                          " Hide buffers when they are abandoned
    set ttymouse=xterm2                                 " tty mouse xterm
    set mouse=a                                         " Enable mouse usage (all modes) in terminals
    set backspace=indent,eol,start                      " :help i_backsp and :h 'backspace' for more info
    set tabstop=4                                       " Number of spaces for the tabstop
    set shiftwidth=4                                    " (Auto)indent uses 2 characters
    set expandtab                                       " spaces instead of tabs
    set autoindent                                      " guess indentation
    set hlsearch                                        " highlight the searchterms
    set textwidth=0                                     " don't wrap words
    set ruler                                           " show ruler
    set number                                          " show line numbers
    set viewoptions=folds,options,cursor,unix,slash     " unix/windows compatibility
    set foldenable                                      " enable folds by default
    set foldmethod=syntax                               " fold via syntax of files
    set foldlevelstart=99                               " open all folds by default
    set encoding=utf-8                                  " set encoding for text
    set autoread                                        " auto reload if file saved externally
    set fileformats+=mac                                " add mac to auto-detection of file format line endings
    set nrformats-=octal                                " always assume decimal numbers
    set wildmenu                                        " show list for autocomplete
    set wildmode=list:full
    set wildignorecase
    set splitbelow
    set splitright
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store
    set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [FMT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
    set laststatus=2

    if has('conceal')
        set conceallevel=1
        set listchars+=conceal:Δ
    endif
" }

" vim file/folder management {
   " persistent undo
   if exists('+undofile')
       set undofile
       set undodir=~/.vim/.cache/undo
   endif

   " backups
   set backup
   set backupdir=~/.vim/.cache/backup

   " swap files
   set directory=~/.vim/.cache/swap
   set noswapfile

   call EnsureExists('~/.vim/.cache')
   call EnsureExists(&undodir)
   call EnsureExists(&backupdir)
   call EnsureExists(&directory)
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

    if s:is_windows && !s:is_cygwin
        " ensure correct shell in gvim
        set shell=c:\windows\system32\cmd.exe
    endif
" }

" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker:
