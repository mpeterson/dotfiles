" All system-wide defaults are set in $VIMRUNTIME/debian.vim (usually just
" /usr/share/vim/vimcurrent/debian.vim) and sourced by the call to :runtime
" you can find below.  If you wish to change any of those settings, you should
" do it in this file (/etc/vim/vimrc), since debian.vim will be overwritten
" everytime an upgrade of the vim packages is performed.  It is recommended to
" make changes after sourcing debian.vim since it alters the value of the
" 'compatible' option.

" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" load bundles from .vim/bundle/
call pathogen#infect()

" Set window title
set title

" Uncomment the next line to make Vim more Vi-compatible
" NOTE: debian.vim sets 'nocompatible'.  Setting 'compatible' changes numerous
" options, so any other options should be set AFTER setting 'compatible'.
"set compatible

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

" Uncomment the following to have Vim load indentation rules according to the
" detected filetype. Per default Debian Vim only load filetype specific
" plugins.
if has("autocmd")
  filetype indent on
endif

" Enable new syntax hilight extensions
au BufNewFile,BufRead *.rst set filetype=rest

" The following are commented out as they cause vim to behave a lot
" differently from regular Vi. They are highly recommended though.
set nocompatible                  " enable all features

set showcmd												" Show (partial) command in status line.
set showmatch											" Show matching brackets.
set ignorecase										" Do case insensitive matching
set smartcase											" Do smart case matching
"set incsearch										" Incremental search
"set autowrite										" Automatically save before commands like :next and :make
"set hidden												" Hide buffers when they are abandoned
set ttymouse=xterm2               " tty mouse xterm
set mouse=a												" Enable mouse usage (all modes) in terminals
set backspace=indent,eol,start		" :help i_backsp and :h 'backspace' for more info
set tabstop=2											" Number of spaces for the tabstop
set shiftwidth=2									" (Auto)indent uses 2 characters
set expandtab											" spaces instead of tabs
set autoindent										" guess indentation
set hlsearch                      " highlight the searchterms
set textwidth=0                   " don't wrap words
set ruler                         " show ruler
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%04.8b]\ [HEX=\%04.4B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set laststatus=2

" disable expand tabs for makefiles
au FileType make setlocal noexpandtab

" Marcar espacios al final
set list listchars=tab:->,trail:.,extends:> 
"highlight WhitespaceEOL ctermbg=red guibg=red
"match WhitespaceEOL /\s\+$\| \+\ze\t/

if &term == "screen"
   exec "set t_kN=\<ESC>[6;*~"
   exec "set t_kP=\<ESC>[5;*~"
endif


function! CheckForUpdates( autoload )

  " Save the current default register
  let saveB = @"
  let msg   = "\n"

  " Check to see if the checkforupdates autocommand exists
  redir @"
  silent! exec 'au CheckForUpdates'.bufnr('%')
  redir END

  if @" =~ 'E216'
    if a:autoload == 1
      let msg = msg . 'AutoRead enabled - '
      setlocal autoread
    endif

    silent! exec 'augroup CheckForUpdates'.bufnr('%')
    exec "au Cursorhold " . expand("%:p") . " :checktime"
    augroup END
    let msg = msg . 'Now checking for updates...'
  else
    if a:autoload == 1
      let msg = msg . 'AutoRead disabled - '
      setlocal noautoread
    endif
    " Using a autogroup allows us to remove it easily with the following
    " command.  If we do not use an autogroup, we cannot remove this
    " single :checktime command
    " augroup! checkforupdates
    silent! exec 'au! CheckForUpdates'.bufnr('%')
    silent! exec 'augroup! CheckForUpdates'.bufnr('%')
    let msg = msg . 'No longer checking for updates.'
  endif

  echo msg
  let @"=saveB
endfunction
command! -bang CheckForUpdates :call CheckForUpdates(<bang>0) 

" Vim + Py == The ultimate IDE for Py
if has('python')

endif
  echo "WARNING: Some parts of the config require vim compiled with +python"
if has('python')
python << EOF
import os
import sys
import vim
for p in sys.path:
  if os.path.isdir(p):
    vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))
EOF
endif

" Need to execute $ ctags -R -f ~/.vim/tags/python.ctags /usr/lib/python2.5/
set tags+=$HOME/.vim/tags/python.ctags

autocmd FileType python set omnifunc=pythoncomplete#Complete

inoremap <Nul> <C-x><C-o>

autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

if has('python')
python << EOL
import vim
def EvaluateCurrentRange():
  eval(compile('\n'.join(vim.current.range),'','exec'),globals())
EOL
map <C-h> :py EvaluateCurrentRange()
endif

" vimrc file for following the coding standards specified in PEP 7 & 8.
"
" To use this file, source it in your own personal .vimrc file (``source
" <filename>``) or, if you don't have a .vimrc file, you can just symlink to it
" (``ln -s <this file> ~/.vimrc``).  All options are protected by autocmds
" (read below for an explanation of the command) so blind sourcing of this file
" is safe and will not affect your settings for non-Python or non-C files.
"
"
" All setting are protected by 'au' ('autocmd') statements.  Only files ending
" in .py or .pyw will trigger the Python settings while files ending in *.c or
" *.h will trigger the C settings.  This makes the file "safe" in terms of only
" adjusting settings for Python and C files.
"
" Only basic settings needed to enforce the style guidelines are set.
" Some suggested options are listed but commented out at the end of this file.


" Number of spaces to use for an indent.
" This will affect Ctrl-T and 'autoindent'.
" Python: 4 spaces
" ReST: 4 spaces
" C: 8 spaces (pre-existing files) or 4 spaces (new files)
au BufRead,BufNewFile *.py,*pyw set shiftwidth=4
au BufRead,BufNewFile *.rst set shiftwidth=4
au BufRead *.c,*.h set shiftwidth=8
au BufNewFile *.c,*.h set shiftwidth=4

" Number of spaces that a pre-existing tab is equal to.
" For the amount of space used for a new tab use shiftwidth.
" Python: 8
" C: 8
au BufRead,BufNewFile *py,*pyw,*.c,*.h set tabstop=4
au BufRead,BufNewFile *.rst set tabstop=4

" Replace tabs with the equivalent number of spaces.
" Also have an autocmd for Makefiles since they require hard tabs.
" Python: yes
" C: no
" Makefile: no
au BufRead,BufNewFile *.py,*.pyw set expandtab
au BufRead,BufNewFile *.c,*.h set noexpandtab
au BufRead,BufNewFile Makefile* set noexpandtab

" Use the below highlight group when displaying bad whitespace is desired
highlight BadWhitespace ctermbg=red guibg=red

" Display tabs at the beginning of a line in Python mode as bad.
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
" Make trailing whitespace be flagged as bad.
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" Wrap text after a certain number of characters
" Python: 79
" C: 79
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h set textwidth=79

" Turn off settings in 'formatoptions' relating to comment formatting.
" - c : do not automatically insert the comment leader when wrapping based on
"    'textwidth'
" - o : do not insert the comment leader when using 'o' or 'O' from command mode
" - r : do not insert the comment leader when hitting <Enter> in insert mode
" Python: not needed
" C: prevents insertion of '*' at the beginning of every line in a comment
au BufRead,BufNewFile *.c,*.h set formatoptions-=c formatoptions-=o formatoptions-=r

" Use UNIX (\n) line endings.
" Only used for new files so as to not force existing files to change their
" line endings.
" Python: yes
" C: yes
au BufNewFile *.py,*.pyw,*.c,*.h set fileformat=unix


" ----------------------------------------------------------------------------
" The following section contains suggested settings.  While in no way required
" to meet coding standards, they are helpful.

" Set the default file encoding to UTF-8: ``set encoding=utf-8``

" Puts a marker at the beginning of the file to differentiate between UTF and
" UCS encoding (WARNING: can trick shells into thinking a text file is actually
" a binary file when executing the text file): ``set bomb``

" For full syntax highlighting:
"``let python_highlight_all=1``
"``syntax on``

" Automatically indent based on file type: ``filetype indent on``
" Keep indentation level from previous line: ``set autoindent``

" Folding based on indentation: ``set foldmethod=indent``
