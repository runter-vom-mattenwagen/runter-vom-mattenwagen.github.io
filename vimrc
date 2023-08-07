filetype plugin on

syntax on
set mouse=

" Vertikale Trennlinie
hi VertSplit ctermfg=Black ctermbg=DarkGrey
set fillchars=vert:\│

" Pluginkonfiguration

" Terraform
let g:terraform_align=1
let g:terraform_fold_section=1
let g:terraform_fmt_on_save=1

" Tagbar
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3',
        \ 'l:Heading_L4'
    \ ]
\ }

" Supertab
set completeopt=menuone,preview
let g:SuperTabDefaultCompletionType = "<c-n>"
highlight Pmenu ctermbg=gray
highlight PmenuSel ctermbg=darkblue ctermfg=white

" Standard-Settings {{{
set nocompatible
set background=dark
set tabstop=8 softtabstop=4 expandtab shiftwidth=4 smarttab smartindent
set splitbelow splitright
set mouse=
set modeline
set magic
set backupdir=~/.vimtmp
set directory=~/.vimtmp
set autochdir
" }}}

" Blanks als Punkte anzeigen waehrend Tippen
set list listchars=tab:→.,trail:•,extends:»,nbsp:.

" Kommentare in kursiv
" "highlight Comment cterm=Italic ctermfg=Grey
" highlight Comment ctermfg=Grey

" Remapping {{{

noremap <Left>  :tabprevious<CR>
noremap <Right> :tabnext<CR>
nnoremap <TAB>   <C-w>w
noremap H       :tabprevious<CR>
noremap L       :tabnext<CR>
nnoremap <C-n>  :tabe .<CR>

" Terminal
nnoremap <C-d> :term<CR>
inoremap <C-d> <ESC>:term<CR>

nnoremap <F6>   :vnew\|read!./%<CR> " Scriptausgabe in Split
nnoremap <F7>   :vnew\|r!  " z.B. 'grep -n foo #'

" Quoting in V-Mode
vnoremap q c""<ESC>hp       " quote Selection
nnoremap Q Da""<ESC>hp      " quote bis Zeilenende
nnoremap " 0f:wDa""<ESC>hp  " quote von Wort nach ":" bis $

" Speichern und Ausfuehren
nnoremap <F9>   :w<cr>:! clear;echo -e "File: %\n";./%<CR>
inoremap <F9>   <ESC>:w<cr>:! clear;echo -e "File: %\n";./%<CR>

nnoremap <F8>   :vnew ~/.vim/note.md<CR>
nmap     <F10>  <Plug>VimwikiTabIndex

" You must be root...
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Edit und sourcen .vimrc (LEADER)
nmap <leader>ev :tabe $MYVIMRC<CR>               " .vimrc editieren

nmap <leader>cs :!curl cheat.sh/
nmap <leader>pb :!ansible-playbook ./% -CD

" Autoclose Klammern etc
ino " ""<left>
ino ' ''<left>
ino ( ()<left>
ino [ []<left>
ino { {}<left>
ino {<CR> {<CR>}<ESC>O
ino ;do<CR> ; do<CR><ESC>0idone<ESC>O<TAB>
"}}}

" Zeilennummern absetzen
hi LineNr ctermbg=234 ctermfg=Grey

hi CursorLine   cterm=NONE ctermbg=236 ctermfg=NONE
hi CursorColumn cterm=NONE ctermbg=236 ctermfg=NONE
set cursorline

au InsertLeave * set nopaste

" Templates für verschieden Filetypen {{{
au BufRead *.sh,*.py
    \ setlocal nu ruler |
    \ setlocal foldmethod=indent |
    \ setlocal softtabstop=4 shiftwidth=4 |
    \ nnoremap <F7>   :TagbarToggle<cr> |
    \ nnoremap <F5>   :vnew\|r!python3 -m pycodestyle # |
    \ let python_highlight_all = 1 |
    \ TagbarOpen

" chmod +x wenn Shebang in erster Zeile
au BufWritePost *
    \ if getline(1) =~ "^#.*/bin/" |
    \   silent execute "!chmod +x %" |
    \ endif

au BufNewFile *.html
    \ 0read ~/.vim/skeleton/_skel_html.tpl |
    \ execute "normal 7ji     "

au BufNewFile *.py
    \ 0read ~/.vim/skeleton/_skel_py.tpl |
    \ execute "normal Go"

au BufNewFile *.sh
    \ 0read ~/.vim/skeleton/_skel_bash.tpl |
    \ setlocal nu |
    \ execute "1," . 10 . "g/<Creation Date>.*/s//Creation Date: " .strftime("%d.%m.%Y") |
    \ execute "1," . 10 . "g/<Scriptname>.*/s//File: " .expand("%") |
    \ execute "normal jjll"

au BufNewFile,BufRead *.service :set ft=gitconfig

au FileType yaml,yml
    \ setlocal tabstop=2 shiftwidth=2 expandtab cursorcolumn

au BufNewFile,BufRead pb_*.yml
    \ setlocal statusline+=%2*%m |
    \ nnoremap <F6> :!ansible-playbook ./% -CD

au BufNewFile,BufRead *.md
    \ nnoremap ,1 0:s!^#* !!ge <bar> <Esc>i#<space><esc>   |
    \ nnoremap ,2 0:s!^#* !!ge <bar> <Esc>i##<space><esc>  |
    \ nnoremap ,3 0:s!^#* !!ge <bar> <Esc>i###<space><esc> |
    \ nnoremap ,4 0:s!^#* !!ge <bar> <Esc>i####<space><esc>|
    \ vnoremap <C-i> c__<ESC>hp       |
    \ vnoremap <C-b> c____<ESC>hhp    |
    \ nnoremap ,m bve |
    \ nnoremap <F6> :!pandoc -f markdown -t html ./% -o %.html <bar> firefox ./%.html<CR>
    " \ TagbarOpen

au BufRead,BufEnter  *note.md
    \ nmap <F8> :x<CR> |
    \ nmap q :q!<CR> |
    \ ino  <F8> <ESC>:x<CR> |
    \ setlocal statusline=%1*\%=###\ Notiz\ ### |
    \ setlocal statusline+=%2*%m |
    \ setlocal ft=markdown paste

au BufLeave note.md
    \ nmap <F8> :vnew ~/.vim/note.md<CR> |
    \ ino  <F8> <NOP>

au BufWritePost $MYVIMRC so $MYVIMRC

au FileType netrw
    \ setlocal statusline=### |
    \ setlocal nolist |
    \ nnoremap <nowait> q <NOP>

" }}}

" Tabline {{{
set showtabline=2
hi TabLineFill ctermfg=7          ctermbg=7
hi TabLine     ctermfg=15         ctermbg=238
hi TabLineSel  ctermfg=232        ctermbg=14
" }}}

" Statuszeile {{{
set laststatus=2
hi User1 ctermbg=yellow    ctermfg=black
hi User2 ctermbg=cyan      ctermfg=black
hi User3 ctermbg=green     ctermfg=black
hi User4 ctermbg=yellow    ctermfg=black
hi User5 ctermbg=grey      ctermfg=black

set statusline=
set statusline+=%1*\[%<%F]\                                     "File+path
set statusline+=%3*\ %y\                                        "FileType
set statusline+=%2*\ [ENC:%{''.(&fenc!=''?&fenc:&enc).''}]\     "Encoding
set statusline+=%2*\[FORMAT:%{&ff}]\                            "FileFormat (dos/unix..) 
set statusline+=%5*\ \|\ [F8]:\ Notiz
set statusline+=%5*\ \|\ [F10]:\ VimWiki\ \| 
set statusline+=%5*\%=[ROW:%l/%L\                               "Rownumber/total (%)
set statusline+=%5*\COL:%03c]\                                  "Colnr
set statusline+=%1*%m%r%w%*                                     "Modified? Readonly? Top/bot."
" }}}

" Schnipsel {{{
nnoremap ,ansible :-1read $HOME/.vim/skeleton/_skel_ansible.tpl<CR>5jA
nnoremap ,html :-1read $HOME/.vim/skeleton/_skel_html.tpl<CR>4jwf>a
nnoremap ,bash :-1read $HOME/.vim/skeleton/_skel_bash.tpl<CR>
" }}}

" netrw {{{
" nmap e :E<CR>
nmap e :Lexp<CR>
let g:netrw_banner=0
let g:netrw_liststyle=3     " Tree
let g:netrw_browse_split=0  " 3 neuer Tab, 4, previously used Window
let g:netrw_winsize=18
let g:netrw_preview=1
let g:netrw_alto=0
let g:netrw_altv=1
let g:netrw_hide=1
"}}}

" vim:foldmethod=marker:se nu:se paste
