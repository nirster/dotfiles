" {{{ Vundle plugins"{{{
set nocompatible
filetype off
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'tpope/vim-surround'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-easytags'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'SirVer/ultisnips'
Bundle 'Valloric/YouCompleteMe'
Bundle 'altercation/vim-colors-solarized'
Bundle 'Lokaltog/vim-distinguished'
Bundle 'majutsushi/tagbar'
Bundle 'tomasr/molokai'
Bundle 'godlygeek/tabular'
Bundle 'w0ng/vim-hybrid'
Bundle 'kien/ctrlp.vim'
Bundle 'majutsushi/tagbar'
Bundle 'tkztmk/vim-vala'
" }}}"}}}
" {{{ Settings
filetype plugin indent on
syntax on
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set ruler
set spelllang=en_us
set laststatus=2
set tabstop=4
set shiftwidth=4
set autoindent 
set smartindent
set textwidth=120
set expandtab
set smarttab
set softtabstop=4
set showcmd 
set number
set numberwidth=4
set showmatch
set mat=1
set hlsearch
set incsearch
set ignorecase
set wrapscan
set smartcase
set backspace=indent,eol,start
set mouse=a
set hidden
set formatoptions=c,q,r,t
set comments=sl:/*,mb:\ *,elx:\ */ 
set history=1000
set undolevels=1000
set title
set noerrorbells
set ttyfast
set showbreak=↪
set splitbelow
set splitright
set clipboard=unnamed
set foldmethod=marker
set foldignore=
set foldlevelstart=99
set t_vb=
set scrolloff=8
set noshowmode " not needed with powerline
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮
set lazyredraw
set linebreak
set complete=.,w,b,u,t
set completeopt=longest,menuone
au VimResized * :wincmd =
set wildmenu
set wildmode=longest:full,full
set wildignore+=*.swp,*.bak,*.pyc,*.class
set wildignore+=.hg,.git,.svn
set wildignore+=*.aux,*.out,*.toc
set wildignore+=*.jpg,*.bmp,*.git,*.png,*.jpeg
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest 
set wildignore+=*.spl                            
set wildignore+=*.sw?                             
set wildignore+=*.DS_Store 
" }}}
"  {{{ Backup 
set undodir=~/.vimbackup/undo//
set backupdir=~/.vimbackup/backup//
set directory=~/.vimbackup/swap//
set backup
set noswapfile
set backupskip=/tmp/*
" }}}
" {{{  Themes and colors 
"set t_ut=
set t_Co=256
let g:hybrid_use_Xresources = 1
colorscheme hybrid
" }}}
" {{{  GUI font
if has ('gui_running')
    set guifont=Terminus\ (TTF)\ 14
    set guioptions-=m               " remove menu
    set guioptions-=T               " remove toolbar
    set guioptions-=r               " remove right scrollbar
    set guioptions-=b               " remove bottom scrollbar
    set guioptions-=L               " remove left scrollbar
    set guicursor+=a:block-blinkon0 " always use block cursor, no cursor blinking
    " Paste from PRIMARY and CLIPBOARD
    inoremap <silent> <M-v> <Esc>"+p`]a
    inoremap <silent> <S-Insert> <Esc>"*p`]a
endif
" }}}
" {{{ Window managment shortcuts
let mapleader = ','
" Toggle spellcheck
nnoremap <leader>s :set spell!<CR>
nnoremap <Leader>ev :vsplit $MYVIMRC<CR>
nnoremap <Leader>ez :vsplit ~/.zshrc<CR>
nnoremap <Leader>et :vsplit ~/.tmux.conf<CR>
nnoremap <Leader>ec :vsplit ~/work/code<CR>
nnoremap <Leader>oo :only<CR>
nnoremap <Leader><TAB> :b#<CR>
nnoremap <Leader>D :diffoff!<CR>
" Shortcut for Tabularize
nnoremap <leader>t :Tabularize /
vnoremap <leader>t :Tabularize /
" Ctrlp settings
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>f :CtrlP<CR>
nnoremap <leader>r :CtrlPMRUFiles<CR>
set pastetoggle=<F2>
nnoremap <F3> :call ToggleColours()<CR>
" }}}
" {{{ Buffers/windows shortcuts
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR> 
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
" Window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" }}}
" {{{ More shortcuts
" vimdiff
if &diff
  set diffopt=filler,foldcolumn:0
endif
" clear highlight
nnoremap <Leader><leader> :nohlsearch<CR>
" Switch header/source
map <F2> :e %:p:s,.h$,.X123X,:s,.c$,.h,:s,.X123X$,.c,<CR>
" save as root
cmap w!! w !sudo tee % > /dev/null
" disable ex mode
nnoremap Q <nop>
" Exit insert mode
inoremap jj <esc>
" Dont move on *
nnoremap * *<C-o>
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap D d$
nnoremap <Space> za
vnoremap <Space> za
" emacs bindings in command line mode
cnoremap <C-a> <home>
cnoremap <C-e> <end>
" copy to xclip
vmap <F6> :!xclip -f -sel clip<CR>
map <F7> mz:-1r !xclip -o -sel clip<CR>`z
" }}}
" {{{ NERDTree
let NERDTreeHighlightCursorLine = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeChristmasTree = 1
let NERDTreeChDirMode = 2
nmap <F11> :NERDTreeToggle<CR>
imap <F11> <ESC> :NERDTreeToggle<CR>
" }}}
" {{{ Tagbar options
nmap <F12> :TagbarToggle<CR>
imap <F12> <ESC> :TagbarToggle<CR>
" }}}
" {{{ Syntastic
let g:syntasic_enable_signs = 1
let g:syntastic_quiet_warnings=1
let g:syntastic_check_on_open = 0
let g:syntastic_stl_format = '[%E{%e Errors}%B{, }%W{%w Warnings}]'
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'
let g:syntatic_auto_loc_list = 1
let g:synastic_always_populate_loc_list = 1
let g:syntastic_check_on_wq = 0
nmap <F5> :SyntasticToggleMode<CR>
imap <F5> <ESC> :SyntasticToggleMode<CR>
nmap <F4> :SyntasticCheck<CR>
imap <F4> <ESC> :SyntasticCheck<CR>
" }}} 
" {{{ UltiSnip
let g:UltiSnipsExpandTrigger="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsListSnippets="<c-s-tab>"
" }}}
" {{{ IndentLines
let g:indentLine_color_term = 88
let g:indentLine_char = '¦'
" }}}
" {{{ EasyTags
let g:easytags_updatetime_min = 4000
let g:easytags_include_members = 1
set tags=./tags
let g:easytags_dynamic_files = 1
let g:easytags_updatetime_warn = 0
" }}}
" {{{ ListToggle
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>f'
let g:lt_height = 5
" }}}
" {{{ YouCompleteMe

let g:ycm_min_num_of_chars_for_completion = 5
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>' ]
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_global_ycm_extra_conf = '/home/nir/work/code/.ycm_extra_config.py'
let g:ycm_confirm_extra_conf = 0
let g:ycm_collect_identifiers_from_tags_files = 0
let g:ycm_add_preview_to_completeopt = 0
let g:ycm_seed_identifiers_with_syntax = 1
" }}}
" {{{ Relative numbers
function! NumberToggle()
        if(&relativenumber == 1)
                set number
        else
                set relativenumber
        endif
endfunc
nnoremap <C-n> :call NumberToggle()<cr>
au FocusLost * :set number
au FocusGained * :set relativenumber
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
" }}}
" {{{ CtrlP settings
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.git$\|\.hg$\|\.svn$\|__pycache__$',
      \ 'file': '\.pyc$\|\.so$\|\.swp$',
      \ }
" }}}
" {{{ Powerline
let g:Powerline_symbols = 'fancy'
" }}}
" {{{ Auto commands
autocmd FileType c setlocal noet ts=8 sw=8 sts=8
autocmd FileType c,cpp setlocal foldmethod=syntax
autocmd FileType cpp,python setlocal ts=4 sw=4 sts=4
autocmd BufEnter * silent! lcd %:p:h
" }}}
" {{{ Functions
function! ToggleColours()
if g:colors_name == 'hybrid'
  colorscheme hybrid-light
else
  colorscheme hybrid
endif
endfunction
" }}}
