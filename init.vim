call plug#begin('~/.vim/plugged')
" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'easymotion/vim-easymotion'
Plug 'fatih/vim-go', { 'tag': '*' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'josa42/coc-go', { 'tag': '*' }
Plug 'neoclide/coc-yank'
Plug 'neoclide/coc-snippets'
Plug 'jamespwilliams/bat.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
Plug 'honza/vim-snippets'
Plug 'preservim/nerdtree'
Plug 'ruanyl/vim-gh-line'
Plug 'tpope/vim-fugitive'
Plug 'stephpy/vim-yaml'
Plug 'sebdah/vim-delve'
Plug 'benmills/vimux'
Plug 'altercation/vim-colors-solarized'
Plug 'rakr/vim-one'
call plug#end()

let g:gh_line_map = '<leader>hh'
let mapleader = " "
set termguicolors
set autoindent
set ignorecase
set number

map M `

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
" colorscheme desert
" colorscheme bat
" colorscheme solarized
set bg=light
" set bg=dark
let g:one_allow_italics = 1 " I love italic for comments
colorscheme one

map n nzz

nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]
nnoremap <silent> [fzf-p]p     :<C-u>FzfPreviewFromResources project_mru git<CR>
nnoremap <C-p> :FzfPreviewFromResources project_mru git<CR>


nmap <C-n> :NERDTreeToggle<cr>
nmap rr :source ~/.config/nvim/init.vim<cr>

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
	\: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

highlight Pmenu ctermbg=gray guibg=gray
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)
" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)
" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'
" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'
" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? coc#_select_confirm() :
"       \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
let g:delve_use_vimux = 1
map <C-k> :GoDeclsDir<cr>
nmap gf :GoFillStruct<cr>
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 0
nmap <leader>i :GoInfo<cr>
nmap <C-i> :GoInfo<cr>
let g:go_metalinter_autosave = 0
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 0 
let g:go_highlight_extra_types = 0
" autocmd BufWritePost *.go :GoErrCheck!

nmap s <Plug>(easymotion-s)
nnoremap <leader>gr :<C-u>CocCommand fzf-preview.ProjectGrep<Space>

au BufNewFile,BufRead *.yaml.gotmpl set filetype=yaml
au BufNewFile,BufRead Jenkinsfile set filetype=groovy



let g:coc_global_extensions = ["coc-go", "coc-prettier", "coc-eslint", "coc-tsserver", "coc-json", "coc-git"]

function! s:GoToDefinition()
  if CocAction('jumpDefinition')
    return v:true
  endif

  let ret = execute("silent! normal \<C-]>")
  if ret =~ "Error" || ret =~ "错误"
    call searchdecl(expand('<cword>'))
  endif
endfunction

nmap <silent> gd :call <SID>GoToDefinition()<CR>
