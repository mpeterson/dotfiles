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
