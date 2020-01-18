" Plugins {
    " Setup Plugins Support {
        call plug#begin('~/.vim/plugged')
    " }

    " Dependencies {
        Plug 'tpope/vim-repeat'   " required by surround, commentary
    " }
    " Appareance {
        Plug 'altercation/vim-colors-solarized'
        Plug 'zhaocai/GoldenView.Vim'
        Plug 'mhinz/vim-signify'
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'
        Plug 'rakr/vim-one'
    " }
    " Movements {
        Plug 'sickill/vim-pasta'
        Plug 'tpope/vim-surround'
        Plug 'tpope/vim-commentary', { 'on': '<Plug>Commentary' }
        Plug 'easymotion/vim-easymotion'
    " }
    " Navigation {
        Plug 'ctrlpvim/ctrlp.vim'
        Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
    " }
    " Integrations {
        Plug 'tpope/vim-fugitive' " Git
        Plug 'christoomey/vim-conflicted' " On top of tpope/fugitive
        Plug 'christoomey/vim-tmux-navigator' " tmux
    " }
    " Completion {
        if has('nvim')
          Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        else
          Plug 'Shougo/deoplete.nvim'
          Plug 'roxma/nvim-yarp'
          Plug 'roxma/vim-hug-neovim-rpc'
        endif
        Plug 'Shougo/echodoc.vim'
    " }
    " Snippets {
        "Plug 'honza/vim-snippets'
        Plug 'Shougo/neosnippet-snippets'
        Plug 'Shougo/neosnippet.vim'
    " }
    " Code specific {
        " General {
            Plug 'neomake/neomake'
            Plug 'tpope/vim-endwise'
        " }

        " Go {
            Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
            Plug 'deoplete-plugins/deoplete-go', { 'do': 'make' }
            Plug 'sebdah/vim-delve'
        " }
        " HTML {
            Plug 'mattn/emmet-vim'
        " }
        " Javascript {
            Plug 'pangloss/vim-javascript'
            Plug 'othree/javascript-libraries-syntax.vim'
        " }
        " Markdown {
            Plug 'vim-pandoc/vim-pandoc'
            Plug 'vim-pandoc/vim-pandoc-syntax', { 'for': 'pandoc' }
            Plug 'dhruvasagar/vim-table-mode', { 'for': 'pandoc' }
            Plug 'vim-pandoc/vim-pandoc-after', { 'for': 'pandoc' }
        " }
        " PHP {
            Plug 'spf13/PIV'
        " }
        " Python {
            Plug 'zchee/deoplete-jedi'
            Plug 'davidhalter/jedi-vim', { 'for': 'python' }
        " }
    " }

    call plug#end()
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
    if !has('nvim')
        set ttymouse=xterm2                             " tty mouse xterm
    endif
    set mouse=a                                         " Enable mouse usage (all modes) in terminals
    set backspace=indent,eol,start                      " :help i_backsp and :h 'backspace' for more info
    set tabstop=4                                       " Number of spaces for the tabstop
    set shiftwidth=4                                    " (Auto)indent uses 2 characters
    set expandtab                                       " spaces instead of tabs
    set autoindent                                      " guess indentation
    set hlsearch                                        " highlight the searchterms
    set textwidth=0                                     " don't wrap words
    set ruler                                           " show ruler
    set number relativenumber                           " show line numbers (hybrid mode)
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
    set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [FMT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]\ %{ConflictedVersion()}
    set laststatus=2
    let mapleader=' '

    if has('conceal')
        set conceallevel=1
        set listchars+=conceal:Δ
    endif
" }

" Plugin's configurations {
    "Credit joshdick
    "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
    "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
    "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
    " if (empty($TMUX))
      if (has("nvim"))
      "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
      let $NVIM_TUI_ENABLE_TRUE_COLOR=1
      endif
      "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
      "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
      " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
      if (has("termguicolors"))
        set termguicolors
      endif
    " endif
    " Colorscheme and background
    colorscheme one
    set background=dark
    let g:one_allow_italics = 1

    " vim-airline {
    let g:airline_powerline_fonts = 1
    let g:airline_theme = 'one'
    let g:airline#extensions#tabline#enabled = 1
    let g:airline#extensions#whitespace#enabled = 0
    " }

    " NERDTree {
        nmap <leader>n :NERDTreeToggle<cr>
        " Load Nerdtree when a folder is opened, as per:
        " https://github.com/junegunn/vim-plug/issues/424
        augroup nerd_loader
          autocmd!
          autocmd VimEnter * silent! autocmd! FileExplorer
          autocmd BufEnter,BufNew *
                \  if isdirectory(expand('<amatch>'))
                \|   call plug#load('nerdtree')
                \|   execute 'autocmd! nerd_loader'
                \| endif
        augroup END
    " }

    " deoplete {
        " Enable
        let g:deoplete#enable_at_startup = 1
        let g:deoplete#enable_smart_case = 1

        if !exists('g:deoplete#omni#input_patterns')
            let g:deoplete#omni#input_patterns = {}
        endif


        " Disable the candidates in Comment/String syntaxes.
        call deoplete#custom#source('_',
                    \ 'disabled_syntaxes', ['Comment', 'String'])

        autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

        " Plugin key-mappings.
        " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
        imap <C-k>     <Plug>(neosnippet_expand_or_jump)
        smap <C-k>     <Plug>(neosnippet_expand_or_jump)
        xmap <C-k>     <Plug>(neosnippet_expand_target)

        " SuperTab like snippets behavior.
        " Note: It must be "imap" and "smap".  It uses <Plug> mappings.
        imap <expr><TAB>
         \ pumvisible() ? "\<C-n>" :
         \ neosnippet#expandable_or_jumpable() ?
         \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
        smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
         \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

        " For conceal markers.
        if has('conceal')
          set conceallevel=2 concealcursor=niv
        endif

        " enable bibtool completion
        let g:pandoc#biblio#use_bibtool = 1
        " vim-pandoc-after integration with neocomplete
        let g:pandoc#after#modules#enabled = ["neosnippets", "tablemode" ]
    " }

    " jedi {
        let g:jedi#completions_enabled = 0
        let g:jedi#show_call_signatures = "1"
    " }

    " ctrlp config
    let g:ctrlp_cmd = 'CtrlPMixed'
    let g:ctrlp_mruf_relative = 1

    " Change table-mode corner
    let g:table_mode_corner="|"

    " GoldenView disable default mapping
    let g:goldenview__enable_default_mapping = 0

    " Disable tmux navigator when zooming the Vim pane
    let g:tmux_navigator_disable_when_zoomed = 1

    " vertical splits for diffs
    " https://github.com/tpope/vim-fugitive/issues/508
    set diffopt+=vertical

    " neomake {
        call neomake#configure#automake('nrwi', 500)
        let g:neomake_open_list = 2
    " }

    " vim-commentary
    map  gc  <Plug>Commentary
    nmap gcc <Plug>CommentaryLine

    " vim-signify
    let g:signify_vcs_list = [ 'git' ]

    " vim-go {
    let g:go_highlight_build_constraints = 1
    let g:go_highlight_extra_types = 1
    let g:go_highlight_fields = 1
    let g:go_highlight_functions = 1
    let g:go_highlight_methods = 1
    let g:go_highlight_operators = 1
    let g:go_highlight_structs = 1
    let g:go_highlight_types = 1
    let g:go_auto_sameids = 1
    let g:go_fmt_command = "goimports"
    let g:go_auto_type_info = 1
    let g:go_addtags_transform = "snakecase"
    let g:go_snippet_engine = "neosnippet"
    " }

    " Plugin: zchee/deoplete-go {
        " Enable completing of go pointers
        let g:deoplete#sources#go#pointer = 1

        " Enable autocomplete of unimported packages
        let g:deoplete#sources#go#unimported_packages = 0
    " }

    " Plugin: Shougo/echodoc.vim {
        let g:echodoc#enable_at_startup = 1
        if exists('*nvim_open_win')
            let g:echodoc#type = 'floating'
        else
            let g:echodoc#type = 'virtual'
        endif
    " }
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
    " NOTE: This is commented to allow for the better tmux integration
    " map <c-j> <c-w>j
    " map <c-k> <c-w>k
    " map <c-l> <c-w>l
    " map <c-h> <c-w>h

    " <leader>+<movement> to move between tabs
    map <silent> <leader>l :tabnext<CR>
    map <silent> <leader>h :tabprevious<CR>

    " GoldenView split
    nmap <silent> <leader>s <Plug>GoldenViewSplit

    " easy motion mappings
    "map  / <Plug>(easymotion-sn)
    "omap / <Plug>(easymotion-tn)

    " close a window with ctrl+x
    nmap <c-x> <c-w>c

    " Language: Go {
    au FileType go nmap <leader>d :GoDef<cr>
    au FileType go nmap <leader>r :GoReferrers<cr>
    au FileType go nmap <leader>gt :GoDeclsDir<cr>
    au Filetype go nmap <leader>ga <Plug>(go-alternate-edit)
    au Filetype go nmap <leader>gah <Plug>(go-alternate-split)
    au Filetype go nmap <leader>gav <Plug>(go-alternate-vertical)
    au FileType go nmap <F9> :GoCoverageToggle -short<cr>
    au FileType go nmap <F10> :GoTest -short<cr>
    " }
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

    " enable spell check for Markdown files
    autocmd FileType Markdown setlocal spell

    " Language: Go {
    au FileType go set noexpandtab
    au FileType go set shiftwidth=4
    au FileType go set softtabstop=4
    au FileType go set tabstop=4
    au FileType go set nolist
    " }
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
