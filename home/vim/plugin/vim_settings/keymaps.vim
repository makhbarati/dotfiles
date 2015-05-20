" ---------------------- Overrides ------------------------

" CR: turn off highlighting by pressing enter
nnoremap <silent><CR> :noh<CR><CR>

" K: Grep for the word under the cursor, open results in quickfix pane
set grepprg=ag\ --nogroup\ --nocolor
nnoremap K :grep! "\b<C-R><C-A>\b"<CR>:cw<CR>
vnoremap K y:grep! "<C-R>0"<CR>:cw<CR>

" \: (backward slash) to grep-with-ag-to-quickfix shortcut
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>


" -------------- Leader key mappings (ctrl) -----------------

" C-r: reload vimrc
nnoremap <silent><leader><C-r> :source ~/.vimrc<CR>:redraw<CR>:echo 'reloaded'<CR>

" C-]: Open ctag in a vertical split
map <leader><C-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" C-\: Switch between the previous two files
nnoremap <C-\> <c-^>

" <C-w> t: Open a new tab
nnoremap <silent> <C-w>t :tabnew<CR>


" ------------- Leader key mappings (shift) -----------------

" S-r: Reload all open buffers
nnoremap <silent><leader>ra :call ReloadAllBuffers()<CR>


" ------------------- Leader key mappings ---------------------

" -: zoom the current vim pane
nnoremap <leader>- :wincmd _<CR>:wincmd \|<CR>

" =: re-balance vim pane sizes
nnoremap <leader>= :wincmd =<CR>

" bp: insert a binding.pry
nmap <leader>bp orequire 'pry'; binding.pry<ESC>

" c: copy visual selection to system clipboard
vnoremap <leader>c "*y

" e: open netrw explore buffer
nnoremap <silent><leader>e :Explore<CR>

" f: Invoke fzf
nnoremap <silent><leader>f :FZF<CR>

" ga: Git add current buffer
nnoremap <silent><leader>ga :Git add %<CR>

" gc: Git commit
nnoremap <silent><leader>gc :Gcommit<CR>

" gg: Git
nnoremap <leader>gg :Git<space>

" kw: kill trailing whitespace
nnoremap <silent><leader>kw :StripWhitespace<CR>

" n: toggle relative numbering
nnoremap <silent><leader>n :call NumberToggle()<CR>

" r: From visual mode, leader+r populates command line for search and replace
vnoremap <silent> <leader>r :call SearchAndReplace()<CR>

" R: redraw the screen
nnoremap <leader>R :redraw!<CR>

" os: Open Session
nnoremap <leader>os :OpenSession<space>

" sa: visual select all text in file
nnoremap <leader>sa ggVG

" ss: Save Session
nnoremap <leader>ss :SaveSession<space>

" w: Save the current buffer
nnoremap <leader>w :w<CR>

" W: Save all buffers
nnoremap <leader>W :wa<CR>

" x: cut visual selection to system clipboard
vnoremap <leader>x "*d

" v: paste from system clipboard
nnoremap <leader>v :set paste<CR>i<ESC>"*p:set nopaste<CR>
vnoremap <leader>v d:set paste<CR>i<ESC>"*p:set nopaste<CR>