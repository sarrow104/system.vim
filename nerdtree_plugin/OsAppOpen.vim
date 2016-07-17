if exists("g:loaded_nerdtree_WinOpenDir")
    finish
endif

let g:loaded_nerdtree_WinOpenDir = 1

call NERDTreeAddKeyMap({
       \ 'key': '<CR>',
       \ 'callback': 'OsAppOpen',
       \ 'quickhelpText': "open Directory or File\n\"    with OS application",
       \ 'scope': 'Node' })

function! OsAppOpen(node)
    if a:node.path.isDirectory
        call system#WinExp_{util#MySys()}(a:node.path.str())
    else
        call system#GNU_file_CheckAndOpen_{util#MySys()}(a:node.path.str())
    endif
endfunction

