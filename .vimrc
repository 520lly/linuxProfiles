"==========================================
" Author: Jaycee 
" Version: 1.0
" Last_modify: Wed Nov  9 11:40:24 CST 2016
" Sections:
"        General Settings 基础设置
"        Display Settings 展示/排版等界面格式设置
"        FileEncode Settings 文件编码设置
"        Others 其它配置
"        HotKey Settings  自定义快捷键
"        FileType Settings  针对文件类型的设置
"        Theme Settings  主题设置
"        Initial Plugin 加载插件
"
"        插件配置和具体设置在vimrc.bundles中
"==========================================


"==========================================
"        HotKey Settings  自定义快捷键
"==========================================

" 修改Leader键
let mapleader = ',' "替换\作为全局的map Leader
let maplocalleader = ','
let g:mapleader = ','

"Reselect visual block after indent/outdent.调整缩进后自动选中，方便再次操作
vnoremap < <gv
vnoremap > >gv

" remove highlight
noremap <Silent><Leader>/ :nohls<CR>

map <Leader>h :help 
map <silent><Leader>ss :source ~/.vimrc<CR>
"map <silent> <Leader>ss :source ~/%<CR>
cnoremap <Leader>cw <C-R>=expand('<cword>')<CR>
cnoremap <Leader>ce <C-R>=expand('%:e')<CR>
"输入模式下退出当前模式进入普通模式
inoremap <Leader><Leader><space> <Esc>
inoremap jk <Esc>
"vnoremap jk <Esc>
vnoremap <space><space> <Esc><CR>

" save
cmap w!! w !sudo tee >/dev/null %

"Map ; to : and save a million keystrokes
" ex mode commands made easy 用于快速进入命令行
nnoremap ; :
"map <Leader>gsf :execute ! find ./ -type f -name \| grep -E . expand('<cword>')

" 插入模式下用绝对行号, 普通模式下用相对
autocmd InsertEnter * :set norelativenumber number
autocmd InsertLeave * :set relativenumber

" 有一个或以上大写字母时仍大小写敏感
set smartcase



"==========================================
" FileType Settings  针对文件类型的设置
"==========================================
" 检测文件类型
filetype on
" 针对不同的文件类型采用不同的缩进格式
filetype indent on
" 允许插件
filetype plugin on
" 启动自动补全
filetype plugin indent on

autocmd FileType python set tabstop=4 shiftwidth=4 expandtab ai
autocmd FileType ruby set tabstop=2 shiftwidth=2 softtabstop=2 expandtab ai
"autocmd BufRead,BufNew *.md,*.mkd,*.markdown  set filetype=markdown.mkd
autocmd BufRead,BufNew CMakeLists.txt set filetype=cmake
au BufRead,BufNewFile *.fidl set filetype=fidl

"==========================================
" General Settings 基础设置
"==========================================

" 开启语法高亮
syntax enable
syntax on

" 设置当文件被改动时自动载入
set autoread
set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示  

" 突出显示当前列
set cursorcolumn
" 突出显示当前行
set cursorline

" 设置 退出vim后，内容显示在终端屏幕, 可以用于查看和复制, 不需要可以去掉
" 好处：误删什么的，如果以前屏幕打开，可以找回
"set t_ti= t_te=

set mouse=v
" 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set mouse-=a
"set selection=exclusive
set selection=inclusive
set selectmode=mouse,key


set sw=4
set ts=4
set et
set smarttab
set smartindent
set lbr
set fo+=mB
set sm
set wildmenu
set mousemodel=popup

" syntastic
execute pathogen#infect()
set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"set statusline=[%F%m%r%h%w]\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [BUFNUM=%n]\ [ASCII=\%03.3b]\ [HEX=0x\%02.2B]\ POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%Y\ -\ %H:%M\")}   "状态行显示的内容  
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_python_checkers=['pylint']
let g:syntastic_sh_checkers=['checkbashisms', 'sh']
let g:syntastic_c_checkers=['checkpatch', 'gcc', 'make', 'sparse', 'splint', 'ycm']
let g:syntastic_c_checkers=['cpplint', 'gcc', 'ycm']
"let g:syntastic_php_checkers=['php', 'phpcs', 'phpmd']
" golang
" Processing... % (ctrl+c to stop)
let g:fencview_autodetect=0
set rtp+=$GOROOT/misc/vim



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set cul " 高亮光标所在行
set cuc
set go=             " 不要图形按钮  
"color automation    " 设置背景主题  
color dracula    " 设置背景主题  
"color ron     " 设置背景主题  
"color torte     " 设置背景主题  
"set guifont=Courier_New:h10:cANSI   " 设置字体  
"autocmd InsertLeave * se nocul  " 用浅色高亮当前行  
autocmd InsertEnter * se cul    " 用浅色高亮当前行  
set ruler           " 显示标尺  
set showcmd         " 输入的命令显示出来，看的清楚些  
" 左下角显示当前vim模式
set showmode
"set whichwrap+=<,>,h,l   " 允许backspace和光标键跨越行边界(不建议)  
set scrolloff=3     " 光标移动到buffer的顶部和底部时保持3行距离  
hi User1 term=inverse,bold cterm=inverse,bold ctermfg=red
set laststatus=2    " 启动显示状态行(1),总是显示状态行(2)  

set foldenable      " 允许折叠  
" 折叠方法
" manual    手工折叠
" indent    使用缩进表示折叠
" expr      使用表达式定义折叠
" syntax    使用语法定义折叠
" diff      对没有更改的文本进行折叠
" marker    使用标记进行折叠, 默认标记是 {{{ 和 }}}
"set foldmethod=manual   " 手动折叠  
set foldmethod=indent
set foldlevel=99
" 代码折叠自定义快捷键 <Leader>zz
let g:FoldMethod = 0
map <Leader>zz :call ToggleFold()<cr>
fun! ToggleFold()
    if g:FoldMethod == 0
        exe "normal! zM"
        let g:FoldMethod = 1
    else
        exe "normal! zR"
        let g:FoldMethod = 0
    endif
endfun




set nocompatible  "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  
" 显示中文帮助
if version >= 603
    set helplang=cn
    set encoding=utf-8
endif
" 自动缩进
set autoindent
set cindent
" Tab键的宽度
set tabstop=3
" 统一缩进为3
set softtabstop=3
set shiftwidth=3
" 不要用空格代替制表符
set expandtab
" 在行和段开始处使用制表符
set smarttab
" 显示行号
set number
set relativenumber
" 历史记录数
set history=1000
"搜索逐字符高亮
set hlsearch
set incsearch
"语言设置
set langmenu=zh_CN.UTF-8
set helplang=cn
" 总是显示状态行
set cmdheight=2

" 保存全局变量
set viminfo+=!
" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-
" 字符间插入的像素行数目

"markdown配置
au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=mkd
au BufRead,BufNewFile *.{go}   set filetype=go
au BufRead,BufNewFile *.{js}   set filetype=javascript
"rkdown to HTML  
nmap md :!~/.vim/markdown.pl % > %.html <CR><CR>
nmap fi :!firefox %.html & <CR><CR>
nmap \ \cc
vmap \ \cc

"将tab替换为空格
nmap tt :%s/\t/    /g<CR>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.hpp,*.sh,*.rb,*.java,*.py exec ":call SetTitle()" 
""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1,"\#!/bin/bash") 
        call setline(2,"# encoding: utf-8")
        call setline(3,"\# Name  : ".expand("%")) 
        call setline(4,"\# Descp : used for ") 
        call setline(5,"\# Author: jaycee") 
        call setline(6,"\# Date  : ".strftime("%d/%m/%y %H:%M:%S %z")) 
        call setline(7,"__version__=0.1") 
        call setline(8, "") 
        call setline(9, "set -x                     \#print every excution log") 
        call setline(10, "set -e                     \#exit when error hanppens") 
    elseif &filetype == 'python'
        call setline(1,"#!/usr/bin/env python")
        call setline(2,"# encoding: utf-8")
        call setline(3,"\# Name  : ".expand("%")) 
        call setline(4,"\# Descp : used for ") 
        call setline(5,"\# Author: jaycee") 
        call setline(6,"\# Date  : ".strftime("%d/%m/%y %H:%M:%S %z")) 
        call setline(7,"__version__=0.1") 
        call setline(8, "") 
    elseif &filetype == 'perl'
        call setline(1,"#!/usr/bin/perl -w")
        call setline(2,"# encoding: utf-8")
        call setline(3,"use 5.18.2")
        call setline(3,"\# Name  : ".expand("%")) 
        call setline(4,"\# Descp : used for ") 
        call setline(5,"\# Author: jaycee") 
        call setline(6,"\# Date  : ".strftime("%d/%m/%y %H:%M:%S %z")) 
        call setline(7,"__version__=0.1") 
        call setline(8, "") 
    elseif &filetype == 'javascript'
        call setline(1,"//".expand("%"))
        call setline(2, "") 

    elseif &filetype == 'ruby'
        call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),"# encoding: utf-8")
        call setline(6,"\# Date  : ".strftime("%d/%m/%y %H:%M:%S %z")) 
        call append(line(".")+1, "")

        "    elseif &filetype == 'mkd'
        "        call setline(1,"<head><meta charset=\"UTF-8\"></head>")
    else 
        call setline(1, "/*************************************************************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: jaycee") 
        call append(line(".")+2, "    > Mail: jaycee_wjq@163.com") 
        call append(line(".")+3, "    > Date: ".strftime("%d/%m/%y %H:%M:%S %z")) 
        call append(line(".")+4, " ************************************************************************/") 
        call append(line(".")+5, "")
    endif
    if expand("%:e") == 'cpp'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif
    if expand("%:e") == 'hpp'
        call append(line(".")+6, "#ifndef _".toupper(expand("%:r"))."_HPP")
        call append(line(".")+7, "#define _".toupper(expand("%:r"))."_HPP")
        call append(line(".")+8, "#endif")
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "")
    endif
    if expand("%:e") == 'h'
        call append(line(".")+5, "#ifndef _".toupper(expand("%:r"))."_H")
        call append(line(".")+7, "#define _".toupper(expand("%:r"))."_H")
        call append(line(".")+8, "#endif")
    endif
    if &filetype == 'java'
        call append(line(".")+6,"public class ".expand("%:r"))
        call append(line(".")+7,"")
    endif
endfunc 
"新建文件后，自动定位到文件末尾
autocmd BufNewFile * normal G



"定义FormartSrc()
func FormartSrc()
    exec "w"
    if &filetype == 'c'
        exec "!astyle --style=ansi -a --suffix=none %"
    elseif &filetype == 'cpp' || &filetype == 'hpp'
        exec "r !astyle --style=ansi --one-line=keep-statements -a --suffix=none %> /dev/null 2>&1"
    elseif &filetype == 'perl'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'py'||&filetype == 'python'
        exec "r !autopep8 -i --aggressive %"
    elseif &filetype == 'java'
        exec "!astyle --style=java --suffix=none %"
    elseif &filetype == 'jsp'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'xml'
        exec "!astyle --style=gnu --suffix=none %"
    else
        exec "normal gg=G"
        return
    endif
    exec "e! %"
endfunc
"结束定义FormartSrc





""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
    autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$") |
                \   exe "normal g`\"" |
                \ endif
endif
"当打开vim且没有文件时自动打开NERDTree
autocmd vimenter * 
         \ if !argc() | 
         \ NERDTreeToggle | 
         \ set number | 
         \ endif
"autocmd vimenter * if !argc() | NERDTree | set number | endif
"autocmd vimenter * if exists("b:NERDTreeType") | set number | endif
" 只剩 NERDTree时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


" quickfix模式
autocmd FileType c,cpp map <buffer> <Leader><space> :w<cr>:make<cr>
"代码补全 
set completeopt=preview,menu 
"允许插件  
"filetype plugin on
"共享剪贴板  
"set clipboard+=unnamed 
"自动保存
set autowrite
"set ruler                   " 打开状态栏标尺
"set cursorline              " 突出显示当前行
set magic                   " 设置魔术
set guioptions-=T           " 隐藏工具栏
set guioptions-=m           " 隐藏菜单栏
""set foldcolumn=0
""set foldmethod=indent 
""set foldlevel=3 
" 不要使用vi的键盘模式，而是vim自己的
set nocompatible
" 去掉输入错误的提示声音
set noeb
" 在处理未保存或只读文件的时候，弹出确认
set confirm
"禁止生成临时文件
set nobackup
" 关闭交换文件
set noswapfile
"搜索忽略大小写
set ignorecase


set linespace=0
" 增强模式中的命令行自动完成操作
set wildmenu
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l

" 通过使用: commands命令，告诉我们文件的哪一行被改变过
set report=0
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 为C程序提供自动缩进
"自动补全
"":inoremap ( ()<ESC>i
"":inoremap ) <c-r>=ClosePair(')')<CR>
":inoremap { {<CR>}<ESC>O
":inoremap } <c-r>=ClosePair('}')<CR>
"":inoremap [ []<ESC>i
"":inoremap ] <c-r>=ClosePair(']')<CR>
"":inoremap " ""<ESC>i
"":inoremap ' ''<ESC>i
""function! ClosePair(char)
""    if getline('.')[col('.') - 1] == a:char
""        return "\<Right>"
""    else
""        return a:char
""    endif
""endfunction
filetype plugin indent on 
"打开文件类型检测, 加了这句才可以用智能补全
set completeopt=longest,menu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags的设定  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Sort_Type = "name"    " 按照名称排序  
let Tlist_Use_Right_Window = 1  " 在右侧显示窗口  
let Tlist_Compart_Format = 1    " 压缩方式  
let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer  
""let Tlist_File_Fold_Auto_Close = 0  " 不要关闭其他文件的tags  
""let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树  
"let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的
"设置tags  
"set tags=tags  
"set autochdir 
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"其他东东
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"默认打开Taglist 
let Tlist_Auto_Open=0 
"""""""""""""""""""""""""""""" 
" Tag list (ctags) 
"""""""""""""""""""""""""""""""" 
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags' 
let Tlist_Show_One_File = 1 "不同时显示多个文件的tag，只显示当前文件的 
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim 
let Tlist_Use_Right_Window = 1 "在右侧窗口中显示taglist窗口
" minibufexpl插件的一般设置
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1  

"python补全
let g:pydiction_location = '~/.vim/after/complete-dict'
let g:pydiction_menu_height = 20
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1


set iskeyword+=.
set termencoding=utf-8
set encoding=utf-8
set fileencodings=utf-8,ucs-bom,gbk,cp936,gb2312,gb18030
"set encoding=prc
set fileformat=unix

autocmd FileType python set omnifunc=pythoncomplete#Complete

"==========================================
" Initial Plugin 加载插件
"==========================================


"set nocompatible               " be iMproved
"filetype off                   " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

" My Bundles here:
"
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'Yggdroot/indentLine'
let g:indentLine_char = '┊'
"ndle 'tpope/vim-rails.git'
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
" non github repos
"Bundle 'git://github.com/wincent/command-t.git'
Bundle 'Auto-Pairs'
Bundle 'python-imports.vim'
Bundle 'CaptureClipboard'
Bundle 'ctrlp-modified.vim'
"Bundle 'last_edit_marker.vim'
"Bundle 'synmark.vim'
Bundle 'Python-mode-klen'
"Bundle 'SQLComplete.vim'
"Bundle 'Javascript-OmniCompletion-with-YUI-and-j'
"Bundle 'JavaScript-Indent'
"Bundle 'Better-Javascript-Indentation'
"Bundle 'jslint.vim'
"Bundle "pangloss/vim-javascript"
Bundle 'Vim-Script-Updater'
Bundle 'ctrlp.vim'
Bundle 'tacahiroy/ctrlp-funky'
"Bundle 'jsbeautify'
Bundle 'The-NERD-Commenter'

"django 加密
"Bundle 'django_templates.vim'
"Bundle 'Django-Projects'

"Bundle 'FredKSchott/CoVim'
"Bundle 'djangojump'
Bundle 'vim-powerline' 

let g:Powerline_symbols = 'unicode'
let g:Powerline_symbols = 'fancy'
set t_Co=256
set encoding=utf-8
set laststatus=2
set fillchars+=stl:\ ,stlnc:\
"let Powerline_symbols = 'compatible'
"set -g default-terminal "screen-256color"

"Bundle 'git@github.com:520lly/vim-grepper.git'
Bundle '520lly/vim-grepper'

nnoremap <Leader>g :Grepper -tool git<cr>
nnoremap <Leader>G :Grepper -tool ag<cr>
nnoremap <Leader>gc :Grepper -tool ag -cword -noprompt<cr>

nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)

" Optional. The default behaviour should work for most users.
let g:grepper               = {}
let g:grepper.tools         = ['git', 'ag', 'rg']
let g:grepper.jump          = 0
let g:grepper.next_tool     = '<Leader>g'
let g:grepper.simple_prompt = 1
let g:grepper.quickfix      = 0

Bundle '520lly/vim-dict'

let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

"Bundle '520lly/Visual-Mark'
Plugin 'vim-airline/vim-airline'
Plugin 'dracula/vim'
Plugin 'majutsushi/tagbar'

nmap <F7> :TagbarToggle<CR>
nmap tb :TagbarToggle<CR>


filetype plugin indent on     " required!

"set the ignored files with special tail 
let NERDTreeIgnore=['\.pyc','\.out','tags', '\.files']


"use vim-dict plugin instade
"au FileType php setlocal dict+=~/.vim/bundle/vim/dict/php_funclist.dict
"au FileType css setlocal dict+=~/.vim/bundle/vim/dict/css.dict
"au FileType c setlocal dict+=~/.vim/bundle/vim/dict/c.dict
"au FileType cpp setlocal dict+=~/.vim/bundle/vim/dict/cpp.dict
""au FileType scale setlocal dict+=~/.vim/bundle/vim/dict/scale.dict
"au FileType javascript setlocal dict+=~/.vim/bundle/vim/dict/javascript.dict
"au FileType html setlocal dict+=~/.vim/bundle/vim/dict/javascript.dict
"au FileType html setlocal dict+=~/.vim/bundle/vim/dict/css.dict
"au FileType cmake setlocal dict+=~/.vim/bundle/vim/dic/cmake.dict
"Bundle 'Valloric/YouCompleteMe'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope setting
" """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=1
    set cst
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        "cs add cscope.out
    endif
    set csverb
endif
"add current directory cscope.out file to database -R indicate include all sub
"directory
cnoremap csci !cscope -Rbq
"add current directory cscope.out file to database
cnoremap csca !cscope -dq
"add tags file in current directory to database
cnoremap tagi !ctags -R

map <F12> :call Do_CsTag()<CR>
nmap <Leader>scs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>scg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>scc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>sct :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>sce :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <Leader>scf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <Leader>sci :cs find i ^<C-R>=expand("<cfile>")<CR><CR>
nmap <Leader>scd :cs find d <C-R>=expand("<cword>")<CR><CR>
function Do_CsTag()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif
    if has("cscope")
        silent! execute "cs kill -1"
    endif
    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif
    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif
    if(executable('ctags'))
        "silent!
        "execute
        ""!ctags
        -R --c-types=+p --fields=+S *"
        silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
    endif
    if(executable('cscope') && has("cscope") )
        if(g:iswindows!=1)
            silent! execute "!find `pwd` -name '*.h' -o -name '*.c' -o -name '*.cpp' -o -name '*.java' -o -name '*.cs' > cscope.files"
        else
            silent! execute "!dir /s/b *.c,*.cpp,*.h,*.java,*.cs >> cscope.files"
        endif
        silent! execute "!ctags -R"
        silent! execute "!cscope -bqR"
        execute "normal :"
        if filereadable("cscope.out")
            execute "cs add cscope.out"
            set csverb
        endif
    endif
endfunction
"au BufWritePost *.py,*.c,*.cpp,*.h silent! !eval 'ctags -R; cscope -vqRb' &




"=====================================================================
" map defination
"字 符 模 式 ~ 
"<Space> 普通、可视、选择和操作符等待 
"n 普通 
"v 可视和选择 
"s 选择 
"x 可视 
"o 操作符等待 
"! 插入和命令行 
"i 插入 
"l 插入、命令行和 Lang-Arg 模式的 ":lmap" 映射 
"c 命令行
"键表 |key-notation| 
"<k0> - <k9> 小键盘 0 到 9 *keypad-0* *keypad-9* 
"<S-...> Shift＋键 *shift* *<S-* 
"<C-...> Control＋键 *control* *ctrl* *<C-* 
"<M-...> Alt＋键 或 meta＋键 *meta* *alt* *<M-* 
"<A-...> 同 <m-...> *<A-* 
"<t_xx> termcap 里的 "xx" 入口键 
"特殊参数： 
"1. <buffer> 映射将只局限于当前缓冲区（也就是你此时正编辑的文件）内
"2. <silent> 是指执行键绑定时不在命令行上回显
"3. <special>一般用于定义特殊键怕有副作用的场合
"4. <script>  
"5. <expr>    如果定义新映射的第一个参数是<expr>，那么参数会作为表达式来进行计算，结果使用实际使用的<rhs>
"6. <unique>  一般用于定义新的键映射或者缩写命令的同时检查是否该键已经被映射，如果该映射或者缩写已经存在，则该命令会失败
"=====================================================================

"比较文件  
"nnoremap <C-F2> :vert diffsplit 
"打开帮助
"noremap <C-F2> :help <CR>
"去空行  
nnoremap <F2> :g/^\s*$/d<CR> 
"列出当前目录文件  
"map <F3> :NERDTreeToggle<CR>
map <F3> :call NerdTreeToggle()<CR>
func! NerdTreeToggle()
    NERDTreeToggle
    set number
    set relativenumber
endfunc
"输入模式下实现一次点击F3和Esc键打开文件目录
imap <F3> <ESC> :NERDTreeToggle<CR> 
"打开树状文件目录  
"map <C-F3> \be  

:autocmd BufRead,BufNewFile *.dot map <F5> :w<CR>:!dot -Tjpg -o %<.jpg % && eog %<.jpg  <CR><CR> && exec "redr!"
"C，C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %< -g"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %< -g "
        exec "!time ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        "        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!~/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    endif
endfunc

"代码格式优化化
map <F6> :call FormartSrc()<CR><CR>
"C,C++的调试
map <F8> :call Rungdb()<CR>
func! Rungdb()
    exec "w"
    exec "!g++ % -g -o %<"
    exec "!gdb ./%<"
endfunc

nmap tl :Tlist<cr>
nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>
nmap <Leader>qq :q!<CR>
nmap <Leader>wq :wq<CR>
":nmap <silent> <F9> <ESC>:Tlist<RETURN>
"map <F12> gg=G


" shift tab pages
map <S-Left> :tabp<CR>
map <S-h> :tabp<CR>
map <S-Right> :tabn<CR>
map <S-l> :tabn<CR>
"创建新的的窗口并打开当前目录
noremap tn :tabnew .<CR>
cnoremap to :tabonly<cr>
cnoremap tc :tabclose<cr>
cnoremap tm :tabmove
nmap tg :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q *<CR>:set tags+=./tags<CR>:!cscope -Rbq<CR>:cs add ./cscope.out .<CR>

map! <C-Z> <Esc>zzi
map! <C-O> <C-Y>,
"全选
map <C-A> ggVG$
"可视模式下复制
vnoremap <C-c> "+y
"Ctrl+w实现窗口跳转
"map <C-w> <C-w>w
"imap <C-k> <C-y>,
"插入tab
imap <C-t> <C-q><TAB>
"imap <C-j> <ESC>
"cmap <C-j> <ESC>
"vmap <C-j> <ESC>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"Max out the height of the current split
"ctrl + w _
"
""Max out the width of the current split
"ctrl + w |

"Normalize all split sizes, which is very handy when resizing terminal
"ctrl + w =
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'benmills/vimux'



"nnoremap <Leader>gyw "+yw


" 选中状态下 Ctrl+c 复制
"map <C-v> "+pa
imap <C-v> <Esc>"*pa
imap <C-a> <Esc>^
imap <C-e> <Esc>$

"快速进入命令模式
nnoremap <Leader><Leader> :
"快速进入命令模式
vnoremap <Leader><Leader> :
"快速进入命令模式
inoremap <Leader><Leader>e <Esc>:
"快速进入命令模式
cnoremap <Leader><Leader>e <Esc><CR>

"set clipboard=unnamed
"
"ctrlp设置 当前文件函数搜索插件
"
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.png,*.jpg,*.gif     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.pyc,*.png,*.jpg,*.gif  " Windows
let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux
"let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'  " Windows
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = '\v\.(exe|so|dll)$'
let g:ctrlp_funky_syntax_highlight = 1
let g:ctrlp_extensions = ['funky']
nnoremap <Leader>fu :CtrlPFunky<CR>
nnoremap <Leader>fU :execute 'CtrlPFunky ' . expand('<cword>')<CR>
"nnoremap <Leader>fg :! find <C-R>=getcwd()<CR> -type f -name "*.cpp" -o -name
            "\ "*.c" -o -name "*.h" -o -name "*.py" \| xargs grep -nE "<C-R>=expand('<cword>')<CR>" --color=auto
nnoremap <Leader>fg :! find <C-R>=getcwd()<CR> -type f \| grep -vE 
            \ "(tags\|*.out\|*.js\|*.html\|*.files)" \| xargs grep -nE "<C-R>=expand('<cword>')<CR>" --color=auto
nnoremap <Leader>gr :! grep -rnE "<C-R>=expand('<cword>')<CR>" --color=auto
nnoremap <Leader>fgn :! find <C-R>=getcwd()<CR> -type f \| xargs grep -nE "<C-R>=expand('<cword>')<CR>" --color=auto -C 5
nnoremap <Leader>grn :! grep -rnE "<C-R>=expand('<cword>')<CR>" --color=auto -C 5
nnoremap <Leader>cwd :<C-R>=getcwd()<CR>
"nnoremap <C-n> :CtrlPFunky<Cr>
"mark and visualmark
inoremap <Leader><Leader>ms <Esc>:marks<CR>
nnoremap <Leader>ms :marks<CR>
"nnoremap vm :Marks<CR>
"disable Marks
"nnoremap vmd :Mark<CR>
"恢复上一次保存的Mark
"nnoremap vml :MarkLoad<CR>
":set viminfo+=!
"保存上一次保存的Mark
"nnoremap vms :MarkSave<CR>

"Sat Dec 31 10:18:11 CST 2016
"delete duplications
func Rmduplication(opt)
    exec ":sort"
    else if &a:opt == 1
        exec ":g/^.*$\n\1$/d"
    else if &a:opt == 2
        exec "sor ur /^/"
    else if &a:opt == 3
        exec "%s/^.*\n\1\+$/\1/"
    else
        exec "g/\%(^\1$\n\)\@<=.*$/d)"
    endif
endfunc

nnoremap <Leader>rmd :call Rmduplication(1)<CR><CR>

"add quote to current word
nnoremap <Leader>aw( i(<Esc>ea)<Esc><C-l>
nnoremap <Leader>aw{ i{<Esc>ea}<Esc><C-l>
nnoremap <Leader>aw< i<<Esc>ea><Esc><C-l>
nnoremap <Leader>aw[ i[<Esc>ea]<Esc><C-l>
nnoremap <Leader>aw' i'<Esc>ea'<Esc><C-l>
nnoremap <Leader>aw" i"<Esc>ea"<Esc><C-l>
nnoremap <Leader>aw` i`<Esc>ea``<Esc><C-l>

"add quote to current line 
nnoremap <Leader>al( i(<Esc>$a)<Esc><C-l>
nnoremap <Leader>al{ i{<Esc>$a}<Esc><C-l>
nnoremap <Leader>al< i<<Esc>$a><Esc><C-l>
nnoremap <Leader>al[ i[<Esc>$a]<Esc><C-l>
nnoremap <Leader>al' i'<Esc>$a'<Esc><C-l>
nnoremap <Leader>al" i"<Esc>$a"<Esc><C-l>
nnoremap <Leader>al` i`<Esc>$a`<Esc><C-l>

"Tue Jan  3 13:37:32 CST 2017
nnoremap <Leader>rd :<UP><CR>

"Bundle 'Shougo/neocomplete.vim'

Bundle '520lly/bufexplorer'
"Bundle 'git@github.com:520lly/bufexplorer.git'
"Bundle 'git@github.com:520lly/lookupfile.git'

let g:neocomplete#enable_at_startup = 1
"ColorSchemeExpler favorite settings
"current is automation.vim
"vibrantink.vim pmurphy.vim industry.vim wuye.vim BusyBee.vim adaryn.vim adobe.vim asu1dark.vim
"understated.vim redstring.vim ps_color.vim
"torte.vim tabula.vim turbo.vim symfony.vim

""""""""""""""""""""""""""""""
" vimgdb setting
""""""""""""""""""""""""""""""
"Bundle 'git@github.com:520lly/gdb-from-vim'
let g:vimgdb_debug_file = ""
run macros/gdb_mappings.vim
let g:gdb_from_vim_path = '/usr/bin/gdb'


Bundle "jlanzarotta/colorSchemeExplorer"
Bundle "mhinz/vim-startify"

let g:NERDTreeWinSize=50
"当打开vim且没有文件时自动打开NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
"只剩 NERDTree时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif


""""""""""""""""""""""""""""""
" DoxygenToolkit setting
""""""""""""""""""""""""""""""
Bundle 'vim-scripts/DoxygenToolkit.vim'
let g:doxygentoolkit_brieftag_funcname = "yes"
let g:DoxygenToolkit_compactOneLineDoc = "yes"
"let g:DoxygenToolkit_commentType = "C++"
let g:DoxygenToolkit_briefTag_pre="@brief  "
let g:DoxygenToolkit_paramTag_pre="@param "
let g:DoxygenToolkit_returnTag="@returns   "
"let g:DoxygenToolkit_blockHeader="--------------------------------------------------------------------------"
"let g:DoxygenToolkit_blockFooter="----------------------------------------------------------------------------"
let g:DoxygenToolkit_authorName="jianqing.wang"
let g:DoxygenToolkit_licenseTag="My own license\"   <-- !!! Does not end with \"\<enter>"

nnoremap <Leader>d :Dox
nnoremap <Leader>da :DoxAuthor<CR>
nnoremap <Leader>db :DoxBlock<CR>
nnoremap <Leader>dl :DoxLic<CR>
nnoremap <Leader>du :DoxUndoc<CR>

""""""""""""""""""""""""""""""
"some settings for a.vim
""""""""""""""""""""""""""""""
Bundle "vim-scripts/a.vim"

""""""""""""""""""""""""""""""
"some settings for coding beautify tool uncrustify
""""""""""""""""""""""""""""""
Bundle "cofyc/vim-uncrustify"
autocmd FileType c noremap <buffer> <Leader> <c-f> :call Uncrustify('c')<CR>
autocmd FileType c vnoremap <buffer> <Leader> <c-f> :call RangeUncrustify('c')<CR>
autocmd FileType cpp noremap <buffer> <Leader> <c-f> :call Uncrustify('cpp')<CR>
autocmd FileType cpp vnoremap <buffer> <Leader> <c-f> :call RangeUncrustify('cpp')<CR>


""""""""""""""""""""""""""""""
" snippet setting
""""""""""""""""""""""""""""""
Bundle 'honza/vim-snippets'
"let g:snipMate = get(g:, 'snipMate', {}) " Allow for vimrc re-sourcing
"au FileType c let g:snipMate.scope_aliases['c'] = 'c'
Bundle 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger="<Leader><tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"cnoremap <Leader>csapi <C-R>cs add home/user/jpcc/code/mib3/dev/src/communication/cscope.out<CR>
"在visual模式下选中的文字前后分别加上<b>和</b>
vmap sb \"zdi<b><C-R>z</b><ESC>  
"译释：nmap 是绑定一个在normal模式下的快捷键
nmap ,s :source ~/.vimrc <CR>


""""""""""""""""""""""""""""""
" vim json supportsetting
""""""""""""""""""""""""""""""
"Bundle 'axiaoxin/vim-json-line-format'
"don't lost selection when shifting sidewords
xnoremap <  <gv
xnoremap >  >gv



""""""""""""""""""""""""""""""
"settings for mib3
"""""""""""""""""""""""""""""
"abbrevation for MIB3
abbrev communication<leader> cs add /home/user/jpcc/code/mib3/dev/src/communication/cscope.out
abbrev common<leader> cs add /home/user/jpcc/code/mib3/dev/src/system/tsd-common/1/workspace/cscope.out
abbrev basic<leader> cs add /home/user/jpcc/code/mib3/dev/src/basic-services/cscope.out
abbrev threadmsg<leader> cs add /home/user/jpcc/code/mib3/dev/src/system/tsd-threadmessages/1/workspace/tsd.threadmessages/cscope.out
abbrev daemon<leader> cs add /home/user/jpcc/code/mib3/dev/src/system/tsd-common-daemon/1/workspace/tsd.common.daemon/cscope.out
abbrev commgr<leader> cs add /home/user/jpcc/code/mib3/dev/src/communication/tsd-communication-runtime/1/workspace/tsd.communication.runtime/cscope.out
abbrev comtype<leader> cs add /home/user/jpcc/code/mib3/dev/src/communication/tsd-communication/1/workspace/tsd.communication/cscope.out
abbrev systype<leader> cs add /home/user/jpcc/code/mib3/dev/src/system/tsd-common-types/1/workspace/tsd.common.types/cscope.out
abbrev systemstate<leader> cs add /home/user/jpcc/code/mib3-target/dev/src/system/system-lifecycle/cscope.out
abbrev hmi<leader> cs add /home/user/jpcc/code/mib3-target/dev/src/hmi/cscope.out
abbrev dataformats<leader> cs add /home/user/jpcc/code/mib3/dev/src/system/tsd-dataformats/1/workspace/tsd.dataformats/cscope.out
abbrev rsicommon<leader> cs add /home/user/jpcc/code/cns3/dev/src/basic-services/rsi-library/tsd-rsi-common/1/workspace/tsd.rsi.common/cscope.out
abbrev cinemo<leader> cs add /home/user/jpcc/code/mib34Sal/dev/src/media/libraries/cscope.out
abbrev usb<leader> cs add /home/user/jpcc/code/mib34Sal/dev/src/connectivity/cscope.out
abbrev ph<leader> cs add /home/user/jpcc/code/mib34Sal/dev/src/phone/cscope.out
abbrev find %s/<C-R>=expand('<cword>')<CR>//gn


"add date time
map <Leader>dt a<C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR><Esc>
abbrev au, Jack Wang
 
abbrev warn<Leader> #warning [Jack WANG][a<C-R>=strftime('%Y-%m-%d %H:%M:%S')<CR>] [TODO]


"cheat.sh settings
"call vundle#begin()
"Bundle 'gmarik/vundle'
"Bundle 'scrooloose/syntastic'
Bundle 'dbeniamine/cheat.sh-vim'
"call vundle#end()
let g:syntastic_python_checkers = ['pylint']
let g:syntastic_shell_checkers = ['shellcheck']
" Vim command used to open new buffer
let g:CheatSheetReaderCmd='new"'
" Cheat sheet file type
let g:CheatSheetFt='markdown'
" Program used to retrieve cheat sheet with its arguments
let g:CheatSheetUrlGetter='curl --silent'
" Flag to add cookie file to the query
let g:CheatSheetUrlGetterIdFlag='-b'
" cheat sheet base url
let g:CheatSheetBaseUrl='https://cht.sh'
" cheat sheet settings do not include style settings neiter comments, 
" see other options below
let g:CheatSheetUrlSettings='q'
" cheat sheet pager
let g:CheatPager='less -R'
" pygmentize theme used for pager output, see :CheatPager :styles-demo
"let g:CheatSheetPagerStyle=rrt
" Show comments in answers by default
" (setting this to 0 means giving ?Q to the server)
let g:CheatSheetShowCommentsByDefault=1
" cheat sheet buffer name
let g:CheatSheetBufferName="_cheat"
" Default selection in normal mode (line for whole line, word for word under cursor)
let g:CheatSheetDefaultSelection="line"
" Default query mode
" 0 => buffer
" 1 => replace (do not use or you might loose some lines of code)
" 2 => pager
" 3 => paste after query
" 4 => paste before query
let g:CheatSheetDefaultMode=0
"Path to cheat sheet cookie
let g:CheatSheetIdPath=expand('~/.cht.sh/id')
"To disable the replacement of man by cheat sheets :
let g:CheatDoNotReplaceKeywordPrg=1
"You can also disable the mappings (see plugin/cheat.vim to redo the mappings manually)
let g:CheatSheetDoNotMap=0
"Currently errors are search from the quickfix, then from syntastic errors. To change this order
let g:CheatSheetProviders = ['syntastic', 'quickfix']
