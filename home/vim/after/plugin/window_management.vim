" -------------- Navigation / Window Management ------------------------ "
" Open new split panes to right and bottom
set splitbelow
set splitright

" --- window resizing ---
nnoremap <Left>  <C-w><
nnoremap <Right> <C-w>>
nnoremap <Down>  <C-w>+
nnoremap <Up>    <C-w>-

" --- buffer navigation ---
" C-e: Scroll window up by 5 lines
nnoremap <C-e> 5<C-e>

" C-y: Scroll window down by 5 lines
nnoremap <C-y> 5<C-y>

" --- tab navigation ---
" S-h: previous tab
nnoremap <S-h> gT

" S-l: next tab
nnoremap <S-l> gt

" "  --- pane navigation ---
" " C-j: move to the pane on below
" nnoremap <C-j> <C-w>j
"
" " C-k: move to the pane above
" nnoremap <C-k> <C-w>k
"
" " C-h: move to the pane on the left
" nnoremap <C-h> <C-w>h
"
" " C-l: move to the pane on the right
" nnoremap <C-l> <C-w>l
