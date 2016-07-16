command! -nargs=? -complete=file WinExp	call system#WinExp_{util#MySys()}(<q-args>)
command! -nargs=* -complete=file Shell  call system#Shell_{util#MySys()}(<q-args>)
command! -nargs=1 -complete=file File	call system#GNU_file_CheckAndOpen(<q-args>)

command! -nargs=* -complete=file ShellHere  call system#Shell_{util#MySys()}(escape(fnamemodify(bufname('%'), ":p:h"), ' ()[]'))
command! -nargs=? -complete=file WinHere	call system#WinExp_{util#MySys()}(escape(fnamemodify(bufname('%'), ":p:h"), ' ()[]'))

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"== 2011-05-04 ==================================================================
command! -nargs=+ -complete=file S7z	execute "call system#Shell_{util#MySys()}('7za ".<q-args>." && pause')"
command! -nargs=+ 		 Wget	execute "call system#Shell_{util#MySys()}('wget ".<q-args>." && pause')"
command! -nargs=+ -complete=file ZipMove  execute "call system#Shell_{util#MySys()}('zip -m ".<q-args>." && pause')"
command! -nargs=+ 		 WgetAll  execute "call system#Shell_{util#MySys()}('wget_all ".<q-args>." && pause')"

" Sarrow: 2011-11-28
nnoremap <leader>www :call system#OnlineDoc()<CR>
" End: 2011-11-28
