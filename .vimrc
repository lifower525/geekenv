if !exists('g:bundle_groups')
    " let g:bundle_groups=['base', 'python', 'c', 'cpp', 'golang', 'html', 'javascript', 'markdown', 'java', 'json', 'shell', 'protobuf', 'thrift']
    let g:bundle_groups=['base', 'python', 'c', 'cpp', 'markdown', 'json', 'shell', 'protobuf', 'thrift']
endif
let s:builty_vim = 1
let s:enable_ycm = 1

" 使用系统剪切板
if has('clipboard') && !empty($DISPLAY)
    let s:enable_system_clipboard = 1
else
    let s:enable_system_clipboard = 0
endif

" 检测本机系统是windows、Linux or masOS
if !exists("s:os")
    if has("win64") || has("win32") || has("win16")
        let s:os = "Windows"
    else
        let s:os = substitute(system('uname'), '\n', '', '')
    endif
endif

" 为builty_vim安装字体的函数
function! InstallAirLineFont()
    let s:usr_font_path = $HOME . '/.local/share/fonts/custom/Droid Sans Mono for Powerline Nerd Font Complete.otf'
    if s:os == "Darwin" "mac
        let s:system_font_path = '/Library/Fonts/Droid Sans Mono for Powerline Nerd Font Complete.otf'
    elseif s:os == "Linux"
        let s:system_font_path = '/usr/share/fonts/custom/Droid Sans Mono for Powerline Nerd Font Complete.otf'
        "elseif s:os == "Windows"
    endif

    if exists("s:builty_vim") && s:builty_vim == 1
                \ && !filereadable(s:usr_font_path)
        execute '!curl -fLo ' . shellescape(s:usr_font_path) . ' --create-dirs ' . 'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid\%20Sans\%20Mono\%20Nerd\%20Font\%20Complete.otf'
        if !filereadable(s:system_font_path) && filereadable(s:usr_font_path)
            execute '!sudo mkdir `dirname ' . shellescape(s:system_font_path) . '` && sudo cp ' . shellescape(s:usr_font_path) . ' ' . shellescape(s:system_font_path)
        endif
    endif
endfunction
if !exists(":InstallAirLineFont")
    command -nargs=0 InstallAirLineFont :call InstallAirLineFont()
endif

" 自动安装 Plug.vim 插件
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    call InstallAirLineFont()
endif

call InstallAirLineFont()

" 映射快捷键前缀
let mapleader="\<Space>"

"-------------------------------插件安装和管理----------------------------
call plug#begin('~/.vim/bundle')

if count(g:bundle_groups, 'base')
    Plug 'junegunn/vim-plug'
    Plug 'altercation/vim-colors-solarized'
    Plug 'flazz/vim-colorschemes'
    Plug 'easymotion/vim-easymotion'
    Plug 'scrooloose/nerdtree'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'scrooloose/nerdcommenter'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    Plug 'Yggdroot/LeaderF-marks'
    Plug 'majutsushi/tagbar'
    Plug 'shougo/echodoc'
    Plug 'yggdroot/indentline'
    Plug 'haya14busa/incsearch.vim'
    Plug 'rking/ag.vim'
    Plug 'w0rp/ale'
    Plug 'roxma/vim-paste-easy'
endif

" powerful code-completion engine
if exists("s:enable_ycm")  && s:enable_ycm == 1
    let s:is_system_clang = 0
    if s:os == "Linux"
        let s:is_libclang7_install=str2nr(system('ldconfig -p | grep "libclang-[789].so" | wc -l'))
        let s:is_libclang7_install+=str2nr(system('strings `ldconfig -p | grep "libclang.so$" | awk -F" "' . " '" . '{print $NF}'. "'" . '` | grep "version [789].[0-9].[0-9]" | wc -l'))
        if s:is_libclang7_install > 0
            let s:is_system_clang = 1
        endif
    endif
    if s:is_system_clang
        Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --system-libclang --java-completer' }
    else
        Plug 'valloric/youcompleteme', { 'do': './install.py --clang-completer --java-completer' }
    endif
endif

if count(g:bundle_groups, 'cpp')
    " cpp highlight
    Plug 'octol/vim-cpp-enhanced-highlight'
endif

" builty vim, require terminal font DroidSansMono Nerd\ Font\ 11
if exists("s:builty_vim")  && s:builty_vim == 1
    " Adds file type glyphs/icons to popular Vim plugins
    Plug 'ryanoasis/vim-devicons'
    " toc tree show file type icons
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
endif  "s:builty_vim

call plug#end()

" 引入基本配置文件
source ~/.base.vim

" ------------------Plug 'octol/vim-cpp-enhanced-highlight'----------------
"高亮类，成员函数，标准库和模板
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_concepts_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
"文件较大时使用下面的设置高亮模板速度较快，但会有一些小错误
"let g:cpp_experimental_template_highlight = 1

" --------------------Plug 'easymotion/vim-easymotion'---------------------
" let g:EasyMotion_leader_key = '\'
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
" Type Enter or Space key and jump to first match
let g:EasyMotion_enter_jump_first = 1
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
" nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f)
xmap s <Plug>(easymotion-bd-f)
omap s <Plug>(easymotion-bd-f)
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" ----------------------Plug 'scrooloose/nerdtree'--------------------------------
nmap <leader>4 :NERDTreeToggle<CR>
nmap <leader>5 :NERDTreeFind<CR>
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize=35
let g:NERDTreeWinPos = "left"
let g:NERDTreeGlyphReadOnly = "RO"
" nerdtree highlight
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeHighlightFolders = 1 " enables folder icon highlighting using exact match
let g:NERDTreeHighlightFoldersFullName = 1 " highlights the folder name
let g:NERDTreeHighlightCursorline = 0
" autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
" open a NERDTree automatically when vim starts up if no files were specified
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && winnr('$') < 2 | NERDTree | endif
" open NERDTree automatically when vim starts up on opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" -------------------Plug 'valloric/youcompleteme'----------------------------------
if exists("s:enable_ycm")  && s:enable_ycm == 1
    "if !empty(glob("~/.vim/bundle/youcompleteme/third_party/ycmd/examples"))
    "    let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/youcompleteme/third_party/ycmd/examples/.ycm_extra_conf.py"
    "endif
    let g:ycm_global_ycm_extra_conf = "~/.ycm_extra_conf.py"
    if !empty(glob(".ycm_extra_conf.py"))
        let g:ycm_global_ycm_extra_conf = ".ycm_extra_conf.py"
    endif
    " autoload .ycm_extra_conf.py, no need confirm
    let g:ycm_confirm_extra_conf=0
    let g:ycm_complete_in_comments=1  "在注释输入中也能补全
    let g:ycm_collect_identifiers_from_comments_and_strings = 0  "注释和字符串中的文字也会被收入补全
    let g:ycm_collect_identifiers_from_tags_files=1 " 开启 YCM 基于标签引擎
    let g:ycm_min_num_of_chars_for_completion=1 "从第1个键入字符就开始罗列匹配项
    let g:ycm_cache_omnifunc=0   " 禁止缓存匹配项,每次都重新生成匹配项
    " YCM's identifier completer will seed its identifier database with the keywords of the programming language
    let g:ycm_seed_identifiers_with_syntax=1   " 语法关键字补全
    " show the completion menu even when typing inside strings
    let g:ycm_complete_in_strings = 1  "在字符串输入中也能补全
    " eclim file type validate conflict with YouCompleteMe
    let g:EclimFileTypeValidate = 0
    " YCM will populate the location list automatically every time it gets new diagnostic data
    let g:ycm_always_populate_location_list = 0
    " goto next location list
    autocmd FileType c,cpp,java nmap [l :lnext<CR>
    " goto previous location list
    autocmd FileType c,cpp,java nmap ]l :lprevious<CR>
    " make YCM compatible with UltiSnips (using supertab)
    let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
    let g:ycm_max_diagnostics_to_display = 0
    let g:SuperTabDefaultCompletionType = '<C-n>'
    nmap <C-g> :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR>
endif  "s:enable_ycm

" -----------------Plug 'yggdroot/leaderf'-------------------------
let g:Lf_ShortcutF = '<C-p>'
let g:Lf_ShortcutB = '<leader>b'
" let g:Lf_DefaultMode = 'FullPath'
nmap <leader>lt :LeaderfBufTag<CR>
nmap <leader>f :LeaderfFunction<CR>
nmap <leader>ll :LeaderfLine<CR>
nmap <leader>lm :LeaderfMarks<CR>
nmap <leader>lc :LeaderfHistoryCmd<CR>
nmap <leader>ls :LeaderfHistorySearch<CR>

if exists("s:builty_vim") && s:builty_vim == 1
    set guifont=DroidSansMono\ Nerd\ Font\ 11
else
    set guifont=Bitstream\ Vera\ Sans\ Mono\ 11
endif  "s:builty_vim

" ----------------Plug 'vim-airline/vim-airline'---------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
if exists("s:builty_vim") && s:builty_vim == 1
    let g:airline_powerline_fonts = 1
endif

" ----------------Plug 'vim-airline/vim-airline-themes'----------
" let g:airline_theme='solarized8'
let g:airline_theme='badwolf'
" let g:airline_theme='violet' "match space-vim-dark

" ---------------Plug 'majutsushi/tagbar' ----------------------
" 打开/关闭符号栏
nmap <leader>8 :TagbarToggle<CR>
" 符号栏宽度
let g:tagbar_width=30
" 重映射显示完整符号的快捷键，避免和<leader>键冲突
let g:tagbar_map_showproto = "<leader><leader>"
" 打开代码文件自动打开符号栏
autocmd BufReadPost *.cpp,*.c,*.h,*.hpp,*.cc,*.cxx,*.py,*.java call tagbar#autoopen()

" ---------------Plug 'shougo/echodoc'--------------------------
" 增加命令栏高度，用于显示签名
set cmdheight=2
" 默认打开函数签名显示
let g:echodoc#enable_at_startup = 1
let g:echodoc#enable_force_overwrite = 1

" --------------Plug 'yggdroot/indentline'-------------------------
" 开启缩进线
let g:indentLine_enabled = 1
" json和markdown文件禁用缩进线，避免特殊的显示问题
let g:vim_json_syntax_conceal = 0
let g:indentLine_fileTypeExclude = ['json', 'markdown']
autocmd BufEnter *.md setlocal conceallevel=0
autocmd BufEnter *.markdown setlocal conceallevel=0
set foldmethod=indent                " 根据每行的缩进开启折叠
set foldlevel=99

" -------------Plug 'haya14busa/incsearch.vim'------------------------
" 高亮匹配字符
set incsearch

" ---------------Plug 'w0rp/ale' ---------------------------------------
" 在airline显示ale的状态
let g:airline#extensions#ale#enabled = 1
" 自动打开错误列表
let g:ale_open_list = 1
" 对YouCompleteMe插件支持较好的语言不使用
let g:ale_linters = {'c': [], 'cpp': [], 'java': []}
autocmd FileType c,cpp,java  setl fdm=syntax | setl fen
let ale_blacklist = ['c', 'cpp', 'java']
" 跳转到上一个错误
autocmd FileType * if index(ale_blacklist, &ft) < 0 | nmap <silent> [l <Plug>(ale_previous_wrap)
" 跳转到下一个错误
autocmd FileType * if index(ale_blacklist, &ft) < 0 | nmap <silent> ]l <Plug>(ale_next_wrap)

" ------------------'Plug roxma/vim-paste-easyi'------------------------------
" 不显示paste模式切换信息
let g:paste_easy_message = 0
