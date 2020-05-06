" Sane quickfix window replacement.
"   Use <leader><enter> to open in new vertical split.
"   Use <leader><space> to open in new horizontal split.
" Access to the fastest grep ever (ripgrep).
" Run external commands and capture their output on Windows.
"   Example (for parsing NLog logs): r!awk "-F|" "{print $6}" "%:p"
" "q:": Shows ex command history.
" :colder: Load last QF list. (Up to 9 stored.)
" More text objects:
"   dib: delete inside braces of any kind.
"   daa: delete current arguement in function call.
" CamelCaseMotion and snake_case as word motions.
" On negative lookaheads: "
"   Your attempt was pretty close; you need to pull the .* that allows an arbitrary distance between the match and the asserted later non-match into the negative look-ahead:
"    /abc\(.*xyz\)\@!
"   I guess this works because the non-match is attempted for all possible matches of .*, and only when all branches have been exhausted is the \@! declared as fulfilled.



"--init
" Enable vim only features.
set nocompatible



"--plugins
call plug#begin('~/vimfiles/plugged')

" Another colorscheme option.
Plug 'pbrisbin/vim-colors-off'

" Add support for .ps1 files.
Plug 'PProvost/vim-ps1'

" Adds many colorschemes.
Plug 'flazz/vim-colorschemes'

" Fast file search.
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'

" Adds toggle quickfix mapping.
Plug 'milkypostman/vim-togglelist'

" Adds much faster vimgrep.
Plug 'mileszs/ack.vim'
" rg support.
if executable('rg')
  let g:ackprg = 'rg --vimgrep --no-heading'
endif

" Sane quickfix window replacement.
Plug 'yssl/QFEnter'

" Character-wise diff.
Plug 'rickhowe/diffchar.vim'

" Let % match tags.
Plug 'adelarsq/vim-matchit'

" Add syntax support for typescript.
Plug 'leafgarland/typescript-vim'

Plug 'vim-scripts/vim-auto-save'
let g:auto_save = 0

" More text objects.
Plug 'wellle/targets.vim'

" Create own text objects.
Plug 'kana/vim-textobj-user'

" HTML text objects.
Plug 'whatyouhide/vim-textobj-xmlattr'

" Support camel case motion.
"Plug 'chaoren/vim-wordmotion'

" Add comment operator.
Plug 'tpope/vim-commentary'

" Add surround operator.
Plug 'tpope/vim-surround'

Plug 'vim-airline/vim-airline'
let g:airline_powerline_fonts=0
let g:airline_section_y='%{getcwd()}'

" Colorscheme.
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_light='hard'

" Project-wide find and replace.
Plug 'brooth/far.vim'

call plug#end()

" Enables loading plugin files for specific file types.
filetype plugin on



"--functions
" Function to open netrw in the cwd.
function! Netrw_OpenCwd()
    let cwd=getcwd()
    execute 'Vex ' . cwd
endfunction

" Function to rename the variable under the cursor.
function! Rnvar()
    set noignorecase
    let word_to_replace = expand("<cword>")
    let replacement = input("New name: ")
    execute '%s/\v<' . word_to_replace . '>/' . replacement . '/gc'
    set ignorecase
endfunction

function! Todo_Done()
    let line=getline('.')
    if line =~ "\[ \]"
        execute "normal! ^t]rx\<esc>dd}kp\<c-o>"
    endif
endfunction

function! Notes_MakeHeader()
    let padding_length = 8
    let padding = repeat(" ", padding_length)
    let header = toupper(input("Header: "))
    
    let top_length = padding_length + len(header) + padding_length
    let top = printf("   %s", repeat("_", top_length))
    
    let rest_of_line_length = 80 - top_length - 4
    let rest_of_line = repeat("_", rest_of_line_length)
    
    let line = printf("__|%s%s%s|%s", padding, header, padding, rest_of_line)
    put ="\n"
    put =top
    put =line
    execute "normal! jj"
endfunction

function! FixCursor()
    set guicursor=
    set guicursor+=n-c:ver25-Cursor-blinkon100-blinkoff100,
    set guicursor+=v-ve:block-blinkon0,
    set guicursor+=o:hor50-Cursor,
    set guicursor+=i-ci:ver25-Cursor/lCursor,
    set guicursor+=r-cr:hor20-Cursor/lCursor,
    set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175
endfunction

function! FindDef()
    let search = "(public|private|function)[\\s\\w<>]*" . expand("<cword>")
    let command = "Ack! \"" . search . "\""
    " echom command
    execute command
endfunction

function! ListProjects()
    source ~\_vimrc_transient
    let s:vimrcText = readfile(glob('~/_vimrc_transient'))
    for s:line in s:vimrcText
        let s:projectMap = matchstr(s:line, 'leader>\d\+.\{-}cd')
        if empty(s:projectMap)
        else
            echo s:line
        endif
    endfor
endfunction

function! EditPathLike()
    let line = getline('.')
    let pathToSource = matchlist(line, 'source \(.\+\)')[1]
    exec ":e " pathToSource
endfunction

function! GrepQuickFix(pat)
  let all = getqflist()
  for d in all
    if bufname(d['bufnr']) !~ a:pat && d['text'] !~ a:pat
        call remove(all, index(all,d))
    endif
  endfor
  call setqflist(all)
endfunction
command! -nargs=* GrepQF call GrepQuickFix(<q-args>)

"--settings
" Netrw.
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_liststyle = 3
let g:netrw_browse_split = 4
let g:netrw_altv = 1
let g:netrw_keepdir = 0

" Disable auto indent.
filetype indent off

" Set the default colorscheme.
"colorscheme ibmedit
"colorscheme monokai
"colorscheme adrian
"colorscheme darkslategray
colorscheme default
"colorscheme solarized

" More x-tream options.
"colorscheme C64
"colorscheme pink
"colorscheme cobalt2
"colorscheme sweetcandy
"colorscheme matrix

" From plugins.
"colorscheme gruvbox
"colorscheme off

" Some colorschemes respect this setting.
set background=light
"set background=dark

" Override highlight cursor stuff.
augroup vimrc
    autocmd!
    " For set background=light
    "autocmd ColorScheme * highlight CursorLine ctermbg=white guibg=white 
    "autocmd ColorScheme * highlight CursorColumn ctermbg=white guibg=white
    " For set background=dark
    "autocmd ColorScheme * highlight CursorLine ctermbg=black guibg=black 
    "autocmd ColorScheme * highlight CursorColumn ctermbg=black guibg=black
augroup END

" Control syntax highlighting.
" (Should come after setting the colorscheme to avoid some possible issues.)
syntax off
"syntax on

" Set case search settings.
set ignorecase

" Set tab settings.
set tabstop=2
set shiftwidth=0
set expandtab
set smartindent

" When a bracket is inserted, breifly jump to the matching one.
set showmatch
" How many tenths of a second to blink between matching brackets.
set mat=1

" Show search results as they are typed.
set incsearch

" Control search highlight.
set hlsearch

" Show current command in the lower left.
set showcmd

" Hightlight the current line with the cursor.
set cursorline

" Highlight the current column with the cursor.
"set cursorcolumn

" Control line numbers.
set nonumber

" Set how many lines of context to keep around the cursor.
set scrolloff=0
"set scrolloff=7
" Force cursor to center always.
"set scrolloff=999

" Control line wrapping.
set wrap linebreak
" Limits the length of a single line being inserted in insert mode.
set tw=0
" Extra padding which causes wrapping to start sooner than the edge of the screen.
set wrapmargin=0
" Line wrap character.
set showbreak=→

" Add lots of undo.
set history=1000
set undolevels=1000

" Status line.
set statusline=
set statusline+=\ 
set statusline+=%{getcwd()}
set statusline+=\ -\ 
set statusline+=%t
set statusline+=%=
set statusline+=%l
set statusline+=:
set statusline+=%c
set statusline+=%.m
set statusline+=\ 
set laststatus=2
"set statusline=%#Normal# 
"set laststatus=0
"set nu

" Disable any and all beeping and or flashing.
set noerrorbells visualbell t_vb=

" Set the folder for swap files.
set directory=$TEMP

" Hides abandoned buffers instead of unloading them.
set hid

" Stop the screen from updating during macros, making them much faster.
set lazyredraw

" If this many millis nothing is typed the swap file will be written to disk.
set updatetime=4000
" Disable swap files.
set noswapfile

" Wait forever for a mapped key squence or keyboard code.
set notimeout
set nottimeout

" Disable saving backup files.
set nobackup
set nowb

" Vertical diffs please.
set diffopt+=vertical

" Disable auto split resize on close.
set noea

" Enable sane fold settings.
" set foldmethod=indent
" set foldlevel=0
" set foldopen=
" set foldopen+=jump
" set foldopen+=quickfix
" set foldopen+=mark
" set foldopen+=percent

" Make the mouse cursor more precise.
set mouseshape=n:beam,v:beam

" Automatically reload file changes.
set autoread
au CursorHold * checktime

" Automatically save when navigating buffers, or before commands.
set autowrite

" Enable mouse for (a)ll modes.
set mouse=a

" Enable fancy/better tab completion.
set wildmode=longest,list,full
" Enable smart tab completion in ex.
set wildmenu

" Allow backspacing over everything.
set backspace=indent,eol,start

" Keys which move to the next/previous line when at the end of a line.
set whichwrap=
set whichwrap+=b,s " Allow backspace and space.
set whichwrap+=<,>,[,] " In this case, left and right arrow keys in both insert and normal modes.

" Set how many chars of context to keep around cursor horizontally.
set sidescroll=1

" Hide tabs and EOL chars.
set nolist

" Set default file encoding.
set encoding=utf-8

" Enable highlighting for file formats without plugins.
au BufNewFile,BufRead *.xaml set filetype=xml

" Build completion settings.
set complete=
set complete+=.     " Look in current buffer.
set complete+=w,b,u " Look in buffers from other windows, loaded and unloaded buffers.

" Build viminfo file settings.
set viminfo=      " Clear any settings.
set viminfo+='99  " Remember marks for the last 99 open files.
set viminfo+=%    " Save open buffers.
set viminfo+=/999 " Remember the last 999 searches.
set viminfo+=@999 " Save 999 lines of input line history.
set viminfo+=h    " Disable the effect of hlsearch when loading the viminfo file.

set gdefault

" Platform specific settings.
if has("win32")
    augroup global_settings
        autocmd!
        autocmd GUIEnter * set visualbell t_vb=
        autocmd BufEnter * call FixCursor()
    augroup END
    set guifont=Consolas:h12:qCLEARTYPE
else
    set guifont=Pragmata\ Pro\ 12
endif

if has("gui_running") 
    " Set default GUI size.
    set lines=90
    set columns=400

    " Disable annoying parts of gvim.
    " Remove GUI toolbar.
    set guioptions-=T
    set guioptions-=t
    set guioptions-=m
    " Hide lower scroll bar. (Not needed with word wrap.)
    set guioptions-=b
    " Hide side scroll bars.
    "set guioptions-=r
    "set guioptions-=l
    " Show side scroll bars.
    set guioptions+=r
    set guioptions+=l
endif



"--maps
" Example of buffer specific mapping:
"augroup notes_only_map
"    autocmd!
"    autocmd BufEnter Notes.txt nnoremap <silent> <c-j> :call Todo_Done()<cr>
"    autocmd BufEnter Notes.txt nnoremap <silent> <c-h> :call Notes_MakeHeader()<cr>
"augroup END
"
"augroup notes_only_unmap
"    autocmd!
"    autocmd BufLeave Notes.txt nunmap <silent> <c-j>
"    autocmd BufLeave Notes.txt nunmap <silent> <c-h>
"augroup END

" Cover the most common typo.
" Doesn't work because it remaps all of ex's Ws to w. Can't ever type the W in
" Wipe for exampe.
" cmap W w
" This works because it's a new command entirely.
command! -bang -range=% -complete=file -nargs=* W <line1>,<line2>write<bang> <args>

"let g:powershellpath = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
"nnoremap <expr> <leader>r ':!' . shellescape(fnameescape(g:powershellpath)) . ' ' . shellescape(expand("%:p"))
"
" Open file in explorer with file selected.
nnoremap <expr> <silent><leader>eo ':silent !start explorer.exe /select,' . shellescape(expand("%:p")) . '<cr>'
nnoremap <leader>en :e ~/Dropbox/Notes.txt<cr>

" Set cwd to current file's dir.
nnoremap <leader>c :cd %:p:h<cr>

" Clear all buffers.
nnoremap <silent> <leader>bd :bufdo bd!<cr>

nnoremap <leader>` :call ListProjects()<cr>

" Turn off search highlight.
nnoremap <silent><leader><space> :nohlsearch<cr>

" Edit vimrc and load vimrc mappings.
nnoremap <silent> <leader>ev :exec 'e' $MYVIMRC<cr>
nnoremap <silent> <leader>es :source %:p<cr>
nnoremap <silent> <leader>ee :call EditPathLike()<cr>

" Search for current word with Ack.
nnoremap <leader>8 :Ack! "\b<C-R><C-W>\b"<cr>

" Search for current word with Rg.
nnoremap <leader><m-8> :Rg \b<C-R><C-W>\b<cr>

"Toggle quickfix list. (Plugin defined.)
"map <leader>q 

" Easy tab management.
nnoremap <f1> :tabp<cr>
nnoremap <f2> :tabnew<cr>
nnoremap <f3> :tabn<cr>
nnoremap <f12> :call FindDef()<cr>

nnoremap <c-e> :call Rnvar()<cr>

" Select pasted text.
"nnoremap <expr> gv '`[' . getregtype()[0] . '`]'

" Highlight word under cursor.
nnoremap * *Nzz

" Tab to indent in visual mode.
vnoremap <tab> >gv
vnoremap <s-tab> <gv
nnoremap <tab> a<c-t><esc>
nnoremap <s-tab> a<c-d><esc>
inoremap <tab> <c-t>
inoremap <s-tab> <c-d>

" Sane previous/next tab maps.
nnoremap <silent>T :tabp<cr>
nnoremap <silent>Y :tabn<cr>

" Sane j/k with wrapping.
nnoremap j gj
vnoremap j gj
nnoremap k gk
vnoremap k gk

" Highlight last inserted (put/pasted) text.
nnoremap gV `[v`]

" Make window close mapping sane.
nnoremap <c-w>x <c-w>c

" Easy close window/buffer.
nnoremap <silent> <m-W> <c-w>c

" Small split.
nnoremap <silent> <m-w> :sp<cr><c-w>j<c-w>_<c-w>kzt5<c-w>+<c-w>j

" Quickfix navigation.
nnoremap <m-n> :cn<cr>
nnoremap <m-p> :cp<cr>

" Remap navigation to c-t (back) and c-y (forward).
" Because cntl-i is inrep'ed as a tab, need to override the deafalt.
nnoremap <c-t> <c-o>
nnoremap <c-y> <c-i>
nnoremap <c-o> <nop>

" System cut/copy/paste.
vnoremap <c-x> "+x
vnoremap <c-c> "+y
noremap <c-v> "+gp
cnoremap <c-v> <c-r>+
exe 'inoremap <script> <c-v> <c-g>u' . paste#paste_cmd['i']
exe 'vnoremap <script> <c-v> ' . paste#paste_cmd['v']

" Standard save.
noremap <silent><c-s> :update<cr>
vnoremap <silent><c-s> <c-c>:update<cr>
inoremap <silent><c-s> <c-o>:update<cr>

" Standard undo.
noremap <c-z> u
inoremap <c-z> <c-o>u

" Standard select all.
noremap <c-a> gggH<c-o>G
inoremap <c-a> <c-o>gg<c-o>gH<c-o>G
cnoremap <c-a> <c-c>gggH<c-o>G
onoremap <c-a> <c-c>gggH<c-o>G
noremap <c-a> <c-c>gggH<c-o>G

" Remap the increment commands as they are now partly used
" by select all.
nnoremap <a-a> <c-a>
nnoremap <a-x> <c-x>

" Better visual selection.
nnoremap <silent><m-4> v$h
nnoremap <silent><m-6> v^

nnoremap K :Rg  
nnoremap <c-p> :Files<cr> 

nnoremap <m-K> :Ack! ""<left>

nnoremap <silent><c-b> :call Netrw_OpenCwd()<cr>
nnoremap <silent><c-n> :Vex<cr>

" Experimental maps.
nnoremap V v$h
nnoremap <m-v> V
vnoremap V v$h
vnoremap <m-v> V

" VSCode savings.
nnoremap <c-\> :sp<cr>

" Project directory maps:
nnoremap <silent> <leader>0 :cd ~\Desktop\<cr>
nnoremap <silent> <leader>1 :cd ~\Desktop\AWS\InteractServer\<cr>
nnoremap <silent> <leader>2 :cd ~\Desktop\AWS\InteractServer\InteractServer\app\src\<cr>
nnoremap <silent> <leader>3 :cd ~\Desktop\AWS\Identity\<cr>
nnoremap <silent> <leader>4 :cd ~\Desktop\AWS\InteractApp\<cr>
nnoremap <silent> <leader>5 :cd ~\Desktop\Thing\<cr>
