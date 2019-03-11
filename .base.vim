"----------------------------------基本配置------------------------------
"关闭兼容模式
set nocompatible

"文件类型检测，可以针对不同类型的文件加载不同的插件
filetype on
"根据侦测的文件类型，加载相应的插件
filetype plugin on

"vim 自身命令行 模式自动补全
set wildmenu

"设置语法高亮
if has("syntax")
    syntax on
endif

"高亮光标所在列
" set cursorcolumn
" hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white


"高亮光标所在的行
set cul

"用浅色高亮当前行
autocmd InsertEnter * se cul

"设置行间隔
set linespace=0

"设置退格键可用
set backspace=2

"设置匹配模式，显示匹配的括号
set showmatch

"整词换行
set linebreak

"设置光标可以从行首或行末换到另一行去
set whichwrap=b,s,<,>,[,]

"设置使用鼠标
"set mouse=a

"显示行号
set number

"设置历史记录条数
set history=50

"设置自动写回文件
"自动把内容写回文件: 如文件被修改过，在每个 :next、:rewind、:last、:first、:previous、:stop、:suspend、
":tag、:!、:make、CTRL-]" 和 CTRL-^命令时进行；
"用 :buffer、CTRL-O、CTRL-I、'{A-Z0-9} 或 `{A-Z0-9}  命令转到别的文件时亦然。
set autowrite

"---------------------------------配色方案------------------------------
syntax enable
syntax on

"设置背景色
set background=dark

"vim 配色方案
"colorscheme solarized
"colorscheme desert
colorscheme molokai_dark

set t_Co=256

"设置字体
set guifont=Consolas:h11


"---------------------------------设置宽度（tab等）----
"设置tab宽度
set tabstop=4

"设置软tab宽度，软tab，用空格代替tab
set softtabstop=4

"自动缩进的宽度
set shiftwidth=4

"----------------------------------设置对齐和缩进--------
"设置自动对齐，（和上一行）
set autoindent

"智能对齐
"set smartindent

"使用c/c++语言的自动缩进方式
set cindent

"设置c/c++语言的具体缩进方式
set cinoptions={0,1s,t0,n-2,p2s,(03s,=.5s,>1s,=1s,:1s

"不要用空格代替制表符
set expandtab

"在行和段开始处使用制表符
set smarttab
