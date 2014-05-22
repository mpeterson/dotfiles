" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

set nocompatible                  " enable all features
filetype off " required here

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" # Github plugins

" ## Appareance
Plugin 'altercation/vim-colors-solarized'

" ## Movements
Plugin 'sickill/vim-pasta'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat' " required by surround, commentary

" ## Navigation
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'

" ## Integrations
Plugin 'tpope/vim-fugitive' " Git

" ## Completion
Plugin 'Shougo/neocomplete'

" ### Snippets
Plugin 'honza/vim-snippets'
Plugin 'SirVer/ultisnips'

" ## Code specific
" ### HTML
Plugin 'mattn/emmet-vim'

" ### Markdown
Plugin 'tpope/vim-markdown'

call vundle#end()

filetype plugin indent on    " required

" Set window title
set title

" Vim5 and later versions support syntax highlighting. Uncommenting the next
" line enables syntax highlighting by default.
syntax on

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark
colorscheme solarized

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

" Remove search hilighting with ^N
nmap <silent> <C-N> :silent noh<CR>

" highlight a '( )' block of text
nmap <C-P>9 m[va(:sleep 350m<CR>`[

" highlight a '[ ]' block of text
nmap <C-P>[ m[va[:sleep 350m<CR>`[

" highlight a '{ }' block of text
nmap <C-P>] m[va{:sleep 350m<CR>`[

" highlight a '< >' block of text
nmap <C-P>, m[va<:sleep 350m<CR>`[

" enable these commands from 'insert' mode as well
imap <C-P>9 <ESC><C-P>9a
imap <C-P>[ <ESC><C-P>[a
imap <C-P>] <ESC><C-P>]a
imap <C-P>, <ESC><C-P>,a

" Control + t opens a new tab
nmap <C-T> :tabnew<CR>

" Control+<movement> to move between windows
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Map NERDTree
nmap <leader>n :NERDTreeToggle<cr>

" Enable neocomplete
let g:neocomplete#enable_at_startup = 1

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set nocompatible                  " enable all features

set showcmd                       " Show (partial) command in status line.
set showmatch                     " Show matching brackets.
set ignorecase                    " Do case insensitive matching
set smartcase                     " Do smart case matching
"set incsearch                    " Incremental search
"set autowrite                    " Automatically save before commands like :next and :make
set hidden                       " Hide buffers when they are abandoned
set ttymouse=xterm2               " tty mouse xterm
set mouse=a                       " Enable mouse usage (all modes) in terminals
set backspace=indent,eol,start    " :help i_backsp and :h 'backspace' for more info
set tabstop=2                     " Number of spaces for the tabstop
set shiftwidth=2                  " (Auto)indent uses 2 characters
set expandtab                     " spaces instead of tabs
set autoindent                    " guess indentation
set hlsearch                      " highlight the searchterms
set textwidth=0                   " don't wrap words
set ruler                         " show ruler
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}\ [FMT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2

" disable expand tabs for makefiles
au FileType make setlocal noexpandtab

" Mark trailing spaces
set list listchars=tab:->,trail:.,extends:> 
"highlight WhitespaceEOL ctermbg=red guibg=red
"match WhitespaceEOL /\s\+$\| \+\ze\t/

if &term == "screen"
   exec "set t_kN=\<ESC>[6;*~"
   exec "set t_kP=\<ESC>[5;*~"
endif

" load custom configs specific
runtime! custom/functions.vim
runtime! custom/python.vim
