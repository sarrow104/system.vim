" command! -nargs=? -complete=file WinExp	call system#WinExp_{util#MySys()}(<f-args>)
" command! -nargs=* -complete=file Shell  call system#Shell_{util#MySys()}(<f-args>)
"
" Sarrow: 2011-03-11
" 把当前的，调用外部程序，打开对应路径甚至解释命令行的操作，都可以交由外部程序
" 处理(可以是一个exe，也可以是一个dll文件)
" 以便共享功能，少些一些脚本。
" 比如html.vim中的用default-browsrer打开当前文件，就可以完全交给一个外部过程—
" —判断环境变量中是否有PortableApps.html——有，就调用对应的程序打开文件；否
" 则，就调用start-shell指令，通过OS的设定来打开文件。
" 需要进行一些简单的命令行分析——是否是可执行文件？——如果是脚本式的可执行文
" 件，是想编辑它还是运行他？(比如.bat文件如何处理？对于.py文件又如何处理？)
" End:

" basic util functions ----------------------------------- {{{1
function! system#is_absolute_path(path) " {{{2
    return a:path =~ '^\%(\w:\|\\\)\{-,1}\\'
endfunction

function! system#is_relative_path(path) " {{{2
    return a:path =~ '^\%(..\|.\|\w\+\)\%(\\\|\/\)'
endfunction

function! system#ToVimEnc(cmd) "{{{2
    if &enc!=&termencoding
	return iconv(a:cmd, &termencoding, &enc)
    else
	return a:cmd
    endif
endfunction

function! system#ToTermEnc(cmd)	"{{{2
    if &enc!=&termencoding
	"echom  iconv(a:cmd, &enc, &termencoding)
	return iconv(a:cmd, &enc, &termencoding)
    else
	return a:cmd
    endif
endfunction

function! system#is_executable(path) " {{{2
    " 注意，vim中本来就有executable()函数，但是，
    " On MS-DOS and MS-Windows it only checks if the file exists and
    " is not a directory, not if it's really executable.
    " On MS-Windows an executable in the same directory as Vim is
    " always found.  Since this directory is added to $PATH it
    " should also work to execute it |win32-PATH|.
    " The result is a Number:
    " 就是说，这个函数在win32下，基本就没用。
    if util#MySys() == "windows"
	return a:path =~ '\.\(exe\|bat\|com\|jar\)$'
    else
	return executable(a:path)
    endif
endfunction
function! s:Get_GNU_file_call_table() " get basic data {{{2
    if !exists('g:msys_file_call_table')
	let g:msys_file_call_table = {
		    \ 'application/x-rar': '7-ZipPortable\7-ZipPortable.exe',
		    \ 'application/x-gzip': '7-ZipPortable\7-ZipPortable.exe',
		    \ 'application/x-zip': '7-ZipPortable\7-ZipPortable.exe',
		    \ 'application/zip': '7-ZipPortable\7-ZipPortable.exe',
		    \ 'video/mpeg': 'mplayer\mplayer.exe',
		    \ 'video/quicktime': 'mplayer\mplayer.exe',
		    \ 'video/mp4': 'mplayer\mplayer.exe',
		    \ 'video/x-msvideo': 'mplayer\mplayer.exe',
		    \ 'video/x-flv': 'mplayer\mplayer.exe',
		    \ 'video/3gpp': 'mplayer\mplayer.exe',
		    \ 'audio/mpeg': 'CoolPlayer+Portable\CoolPlayer+Portable.exe',
		    \ 'audio/x-wav': 'CoolPlayer+Portable\CoolPlayer+Portable.exe',
		    \ 'application/vnd.rn-realmedia': 'mplayer\mplayer.exe',
		    \ 'application/pdf': 'SumatraPDFPortable\SumatraPDFPortable.exe',
		    \ 'application/octet-stream': 'mplayer\mplayer.exe',
		    \ 'image/jpeg': 'IrfanView\i_view32.exe',
		    \ 'image/gif': 'IrfanView\i_view32.exe',
		    \ 'image/png': 'IrfanView\i_view32.exe',
		    \ 'image/x-ico': 'IcoFXPortable\IcoFXPortable.exe',
		    \ 'image/x-ms-bmp': 'IrfanView\i_view32.exe',
		    \ 'application/x-dosexec': 'C:\WINDOWS\explorer.exe',
		    \ 'text/plain': 'vim\gvim.exe',
		    \ 'text/x-c': 'vim\gvim.exe',
		    \ 'text/x-makefile': 'vim\gvim.exe',
		    \ 'text/x-msdos-batch': 'vim\gvim.exe',
		    \ 'text/html': 'Opera\opera.exe',
		    \ 'application/msword': 'WPS_Office\wps.exe',
		    \ 'application/vnd.ms-excel': 'WPS_Office\wet.exe',
		    \ 'application/vnd.ms-office': 'WPS_Office\wps.exe',
		    \ 'application/vnd.oasis.opendocument.text': 'OpenOfficePortable\OpenOfficePortable.exe',
		    \ 'application/ppt': 'OpenOfficePortable\OpenOfficePortable.exe',
		    \ 'application/odp': 'OpenOfficePortable\OpenOfficePortable.exe',
		    \ 'application/xls': 'OpenOfficePortable\OpenOfficePortable.exe',
		    \ 'application/ods': 'OpenOfficePortable\OpenOfficePortable.exe'}

    endif
    "\'\%(video\|ISO Media\|Microsoft ASF\|RealMedia\|MPEG\)': porttable_root . 'mplayer\mplayer.exe',
    "\'image': porttable_root. 'IrfanView\i_view32.exe'}
    return g:msys_file_call_table
endfunction

" Os spcific functions ----------------------------------- {{{1
function! system#WinExp_windows(args) " open url or file with system defined setting {{{2
    if a:args =~ '^\s*$'
	let str = '.'
    else
	let str = a:args
    endif
    "call system#Gui_execut_this(str)
    execute 'silent !start explorer "' . escape(str, '%&') . '"'
endfunction

function! system#WinExp_linux(args)	"{{{2
    if a:args =~ '^\s*$'
	let str='.'
    else
	let str=a:args
    endif
    "execute 'silent !nautilus ' . str
    "echom 'system#WinExp_linux('''.a:args.''')'
    "echom 'silent !gnome-open ' . escape(str, ' ''%&') . ' &'
    "execute 'silent !gnome-open ' . escape(str, ' %&') . ' &'
    execute 'silent !gnome-open "' . str . '" &'
endfunction

function! system#Shell_windows(args) " executing command-line under shell cmd or terminal {{{2
    call msg#DebugMsg(a:args)
    " 注意 对于<q-args>的处理问题！ 
    " vim对带有
    " - 没有参数的时候，直接在工作目录下开启一个终端
    " - 有参数的时候，开启一个立即终止的终端此时，若需要查看结果，缀上“&& pause”
    if a:args =~ '^\s*$'
	silent execute '!start cmd /K'
    else
	" FIXME
	" 由于是在vim中的 "!" 方式调用的系统命令，而 "!" 是vim命令行的特殊字符
	" ，就是说，a:args中，不能出现！需要先escape一下！
	" NOTE: 2011-03-14
	" 不能使用shellescape()函数-- 他会额外escape添加一些东西——比如双引号
	" 。
	" 比如命令
	" unzip "xx - y.zip"
	" 被escape成了：
	" "unzip ""xx - y.zip"""
	" 这还能够运行吗？
	echom a:args
	silent execute '!start cmd /C '. system#ToTermEnc(escape(a:args, '!'))
	"silent execute '!start cmd /C '. system#ToTermEnc(substitute(a:args, '!', '\!', 'g'))
    endif
endfunction

function! system#Shell_linux(args)	"{{{2
    let g:sys_shell = '!gnome-terminal '. a:args
    if a:args =~ '^\s*$'
	silent execute g:sys_shell . ' &'
    else
	silent execute g:sys_shell.' --working-directory='.system#ToTermEnc(escape(a:args,' |%&[]')).' &'
    endif
endfunction

function! system#GNU_file_CheckAndOpen_linux(path) " check file mime type, then open file {{{2
    " Sarrow: 2011-11-27
    " xdg-open 是一个命令行工具，使用在桌面会话中，用使用者偏好的程序打开uri
    "目标对象。
    execute 'silent !xdg-open ' . escape(a:path, ' |%&[]') . ' &'
    " End: 2011-11-27
endfunction

function! system#GNU_file_CheckAndOpen_windows(path) " {{{2
    "echomsg 'I do'
    if !executable('file')
	" Sarrow: 2011-03-07
	call msg#ErrorMsg('GNU.file not found! please check your envirment-varable setting! or reinstall GNU.file!')
	return
    endif
    " Sarrow: 2011-02-28 
    " TODO
    " 使用 msys.file的功能，然后调用 "注册" 的外部程序，来读取文件。
    "if len($PortableApp) == 0
    "endif
    if a:path =~ '^\(\\\|/\)'
	let path = getcwd()[0:1] . a:path
    elseif a:path =~ '^\%(\w:\|\\\\\)'
	let path = a:path
    else
	let path = getcwd() .'\'. a:path
    endif
    let porttable_drive = expand('$VIM')[0:1]
    let porttable_root = porttable_drive .'\PortableApps\'
    if filereadable(path)
	if system#is_executable(path)
	    call msg#WarningMsg(path.': win32 executable file.')
	    execute 'silent !start "'.system#ToTermEnc(path).'"'
	    return
	endif
	" file "-b" , for brief message
	"let file_check_res = system(porttable_drive.'\Program\MSYS\bin\file.exe -b "'. path. '"')[0:-2]
	let file_check_res = system('file.exe -b --mime-type "'. system#ToTermEnc(path). '"')[0:-2]

	let tool_name = expand('$SystemRoot') . '\explorer.exe'
	let gnu_file_call_table = s:Get_GNU_file_call_table()
	for Mark in keys(gnu_file_call_table)
	    if file_check_res =~ Mark
		let tool_name =  gnu_file_call_table[Mark]
		break
	    endif
	endfor
	if tool_name[1] != ':'
	    let tool_name = porttable_root . tool_name
	endif
	call msg#WarningMsg(path.': '.file_check_res)
	execute 'silent !start ' . tool_name . ' "'.system#ToTermEnc(escape(path, '#')).'"'
    else
	call msg#WarningMsg('`'.path.'` is not a readable file!')
    endif
endfunction

" Syntax sugar functions --------------------------------- {{{1
" Sarrow: 2011-11-28
" inspired by
" http://forum.ubuntu.org.cn/viewtopic.php?f=68&t=355303
function! system#OS_open_url_windows(file)	"{{{2
    "if system#is_absolute_path(a:file)
    "    " absolute path!
    "    let file = a:file
    "else
    "    " relative path!
    "    let file = expand('%:p:h').'\'.a:file
    "endif
    execute 'silent !start RunDll32.exe shell32.dll,ShellExec_RunDLL "'. system#ToTermEnc(a:file) . '"'
    "execute 'silent !start "'. system#ToTermEnc(a:file) . '"'
endfunction

function! system#OS_open_url_linux(file)	"{{{2
    " Sarrow: 2012-02-13
    execute 'silent !xdg-open ' . escape(a:file, ' |#%&[]') . ' &'
    " http://dl.pcgames.com.cn/download/50927.html#downloadAddress
    " 得到：
    " http://dl.pcgames.com.cn/download/50927.html/Files/swap.txtdownloadAddress
    " NOTE: 原始文件是/Files/swap.txt
    " 将escape方案，添加"#"
endfunction

" Sarrow: 2011-12-02
" 关于linux系统下，利用外部程序，打开文件的设定。
" 打开外部文件，始终得利用到shell。
" 文件名，可以用两种方式传递给应用程序：
" 1. 无引号——但部分字符，需要用'\'进行转义。
"    左方括号；左右圆括符；空格等等
" 2. 双引号——无需转义
" 另外，filereadable 函数，的参数好像只支持不带转义字符。
" 而且，直接在vim中，进行文件名补全，不会，进行转义！
" End:
function! system#Gui_execut_this(_cmd_)	"{{{2
    call msg#DebugMsg(a:_cmd_)
    " FIXME 2010年12月31日
    " 当a:_cmd_含有空格时，在用外部调用的时候，还需要加上括号。
    " TODO 2011年01月05日
    " 因为用户传进来的可能只是一个文件名(不含路径)，因此，需要先判断一下字符串参
    " 数指代的类型——先假设是一个地址，再分别看是属于相对还是绝对路径？是unc还
    " 是url？
    " 如果都不是，才放进shell里面。。。
    " shell执行时，还有特例——
    " 如：
    " ps c:\sarrow\blue\my_ps_works\x.psd
    " 应该先利用vim自带的:!命令行补全功能，找到:
    " ps.lnk
    " 再...
    " NOTE: 2011年01月12日 22:31:19
    " 好像不需要这样了。
    " NOTE: 2011-03-07
    " 现在希望用 "绿色" 法：
    " 用PortableApp系列软件，来打开所有的文件。
    " function s:GetOpenWithList_ExtRule()
    "     if !exists('s:open_with_list_ext_rule')
    "         let s:open_with_list_ext_rule = {
    "     endif
    "     return s:open_with_list_ext_rule
    " endfunction
    " - 先用gnu.file分析一下文件类型，然后再调用相关文件——类File.vim
    " - 只是分析文件后缀名，然后决定用什么工具打开。
    let _pattern_ = '^\("\?\)\zs.\{-}\ze\1$'
    " 去括号
    let _no_quote_cmd_ = matchstr(a:_cmd_, _pattern_)

    " 2014-01-28
    " FIXME linux 下，会转义路径字符串里面的空格；' ' => '\ '
    " 而 vim 下的字符串分为两种，一种是保持原意的，single-quoted string；一种
    " 是支持转义字符的double-quoted string；
    if util#MySys() == 'linux'
       exec 'let _no_quote_cmd_="'._no_quote_cmd_.'"'
    endif

    if _no_quote_cmd_ == ''
	let _no_quote_cmd_ = '.'
    endif

    if isdirectory(_no_quote_cmd_)
	call msg#DebugMsg('OS open dire `'._no_quote_cmd_.'`')
	echomsg 'OS open dire `'._no_quote_cmd_.'`'
	call system#WinExp_{util#MySys()}(system#ToTermEnc(_no_quote_cmd_))
	"execute 'silent !start explorer '. system#ToTermEnc(_no_quote_cmd_)
    elseif filereadable(_no_quote_cmd_)
	echomsg 'OS open file `'._no_quote_cmd_.'`'
	call system#GNU_file_CheckAndOpen_{util#MySys()}(_no_quote_cmd_)
    elseif filereadable(expand('%:p:h')._no_quote_cmd_)
	echomsg 'OS open file `'._no_quote_cmd_.'`'
	let _no_quote_cmd_ = expand('%:p:h')._no_quote_cmd_
	call system#GNU_file_CheckAndOpen_{util#MySys()}(_no_quote_cmd_)
    else " treat it as a command-line script
	call msg#DebugMsg('silent !'. a:_cmd_)
	echomsg 'Exectuting terminal cmd: `'.a:_cmd_.'`'
	execute 'silent !'. system#ToTermEnc(a:_cmd_)
    endif
endfunction

function! system#Gui_execut_this_use_pattern(pattern, cmd) " for user defined pattern, like ^!... cmd {{{2
    if a:cmd =~ a:pattern
	call system#Gui_execut_this(a:cmd)
    endif
endfunction

function! system#OnlineDoc() " open Online Documentation or search in google {{{2
   let wordUnderCursor = expand("<cword>")
   if wordUnderCursor =~ '\<https\?\>'
       " 奇怪的问题：[]里面，\s 不能用？
       " let url = matchstr (getline("."), 'https\?[^''"\s]*')
       let url = matchstr(getline("."), 'https\?://[^''" ]*')
   else
       if &ft == "cpp" || &ft == "c"
	   let url = "http://www.google.com/codesearch?q=" . wordUnderCursor . "+lang:" . &ft
       elseif &ft == "vim"
	   let url = "http://www.google.com/codesearch?q=" . wordUnderCursor
       else
	   let url = 'http://www.google.com/search?q=' . wordUnderCursor . '&sourceid=opera&ie=utf-8&oe=utf-8&channel=suggest'
       endif
   endif
   call system#OS_open_url_{util#MySys()}(url)
endfunction
" End: 2011-11-28

" msys/bin/file.exe -- informations	"{{{1
" mpeg	: ISO Media, MPEG v4 system, version 1
" 3gp	: ISO Media, MPEG v4 system, 3GPP
