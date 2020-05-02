" Enable vim only features.
set nocompatible

" Enables loading plugin files for specific file types.
filetype plugin on

source ~/_vimrc_plugins
source ~/_vimrc_functions
source ~/_vimrc_settings
source ~/_vimrc_maps
source ~/_vimrc_transient

" Notes:
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

