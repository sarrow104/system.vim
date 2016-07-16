if exists("g:loaded_nerdtree_WinOpenDir")
    finish
endif

let g:loaded_nerdtree_WinOpenDir = 1

call NERDTreeAddKeyMap({
       \ 'key': '<CR>',
       \ 'callback': 'WinOpenDir',
       \ 'quickhelpText': 'echo full path of current node',
       \ 'scope': 'DirNode' })

function! WinOpenDir(dirnode)
    call system#WinExp_{util#MySys()}(a:dirnode.path.str())
endfunction

call NERDTreeAddKeyMap({
       \ 'key': '<CR>',
       \ 'callback': 'SysOpenFile',
       \ 'quickhelpText': 'echo full path of current node',
       \ 'scope': 'FileNode' })

function! SysOpenFile(filenode)
    call system#GNU_file_CheckAndOpen_{util#MySys()}(a:filenode.path.str())
endfunction

