if exists("g:loaded_nerdtree_CopyPath")
    finish
endif

let g:loaded_nerdtree_CopyPath = 1

call NERDTreeAddKeyMap({
       \ 'key': 'yy',
       \ 'callback': 'CopyPath',
       \ 'quickhelpText': "Copy Node Path To clipboard",
       \ 'scope': 'Node' })

function! CopyPath(node)
    let @+=a:node.path.str()
endfunction

