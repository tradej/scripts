let g:Powerline_symbols = 'fancy'

nmap ,cl /%changelog<LF>:r!date +'\%a \%b \%d \%Y'' Tomas Radej <tradej@redhat.com> - ' <LF>0i* <ESC>$

" Commenting and uncommenting
nmap ,cc :s/^/#/<CR>:nohl<CR>
nmap ,cu :s/^#//<CR>
vmap ,cc :s/^/#/<CR>:nohl<CR>
vmap ,cu :s/^#//<CR>

imap ;; <Esc>

let mapleader = ","

" Search results highlighting
noremap <C-n> :nohl<CR>
vnoremap <C-n> :nohl<CR>
inoremap <C-n> :nohl<CR>

" Movement
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Easier moving between tabs
map <Leader>M <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

map <Leader>M <esc>:tabprevious<CR>
map <Leader>m <esc>:tabnext<CR>

" Indentation
vnoremap < <gv  " better indentation
vnoremap > >gv  " better indentation


" Show whitespace
" MUST be inserted BEFORE the colorscheme command
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()


" Color scheme
" mkdir -p ~/.vim/colors && cd ~/.vim/colors
" wget -O wombat256mod.vim http://www.vim.org/scripts/download_script.php?src_id=13400
set t_Co=256
"" color wombat256mod


" Enable syntax highlighting
" You need to reload this file for the change to apply
filetype off
filetype plugin indent on
syntax on

set laststatus=2

" Showing line numbers and length
set number  " show line numbers
set tw=79   " width of document (used by gd)
set nowrap  " don't automatically wrap on load
set fo-=t   " don't automatically wrap text when typing
set colorcolumn=80
highlight ColorColumn ctermbg=LightGray


" easier formatting of paragraphs
vmap Q gq
nmap Q gqap


" Useful settings
set history=700
set undolevels=700


" Real programmers don't use TABs but spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab


" Make search case insensitive
set hlsearch
set incsearch
set ignorecase
set smartcase


" Disable stupid backup and swap files - they trigger too many events
" for file system watchers
"" set nobackup
"" set nowritebackup
" Hiding Nerdtree
nmap <Leader>v :NERDTreeToggle<CR>
vmap <Leader>v :NERDTreeToggle<CR>
imap <Leader>v :NERDTreeToggle<CR>

