if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

set nocompatible

" Leader
let mapleader = " "

set hidden
set laststatus=2          " last window always has a statusline
set nohlsearch            " Don't continue to highlight searched phrases.
set ignorecase            " Make searches case-insensitive.
set nowrap                " don't wrap text
set backspace=2           " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler                 " show the cursor position all the time
set showcmd               " display incomplete commands
set incsearch             " do incremental searching
set laststatus=2          " Always display the status line
set autowrite             " Automatically :write before running commands
set lazyredraw            " Improve big file opening performance
set wildignorecase        " Case-insensitive cmd autocomplete
set fileignorecase        " Case-insensitive cmd autocomplete
set relativenumber        " Relative number
set number                " Show number on current line
set exrc                  " Enable project specific vimrc files
set secure                " Disable unsafe commands for proejct specific files
set mouse=""              " Disable mouse

" Terminal title
set title
autocmd BufEnter * let &titlestring = "vim (" . expand("%:t") . ")"

" Idention
filetype plugin indent on

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
        \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=120
  autocmd FileType gitcommit setlocal spell spelllang=ru_ru,en_us

  " Ruby idention
  autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
  autocmd FileType ruby compiler ruby

  " vim-ruby completions
  autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
  autocmd BufNewFile,BufRead *.rabl     set filetype=ruby
  autocmd User Rails                    silent! Rlcd
  autocmd User Rails                    silent! Rvm

  " Vim idention
  autocmd FileType vim setlocal ts=2 sts=2 sw=2

  " Yaml spellchecking
  autocmd FileType yaml setlocal spell spelllang=ru_ru,en_us

  " Open help at vertical split
  autocmd BufRead,BufEnter */doc/* wincmd L

  " Relative numeration only on focused window
  autocmd FocusLost *   set number
  autocmd FocusGained * set relativenumber
augroup END


" Idention
set autoindent            " auto-indent
set tabstop=2             " tab spacing
set softtabstop=2         " unify
set shiftwidth=2          " indent/outdent by 4 columns
set shiftround            " always indent/outdent to the nearest tabstop
set expandtab             " use spaces instead of tabs
set smarttab              " use tabs at the start of a line, spaces elsewhere

" Text widht
set textwidth=120
set colorcolumn=+1

" GUI
set t_Co=256              " enable 256-color mode.
syntax enable             " enable syntax highlighting (previously syntax on).
colorscheme zenburn       " set colorscheme
set showtabline=2
set cursorline

" Improve vim's scrolling speed
set ttyfast

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=1200

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·,extends:❯,precedes:❮

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Auto-reload buffers when files are changed on disk
set autoread

" Open all folds by default
set nofoldenable

set undofile                    " Save undo's after file closes
set undodir=~/.vim/undo         " where to save undo histories
set undolevels=1000             " How many undos
set undoreload=10000            " number of lines to save for undo

set tagbsearch " use binary searching for tags

" Text-Object
runtime macros/matchit.vim

" reselect blocks after indenting/dedenting
vnoremap < <gv
vnoremap > >gv

" nightmare mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Switch between the last two files
nnoremap <leader><leader> <c-^>

" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-n>"
  endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-p>

" force vimdiff open at vertical spleets
set diffopt+=vertical

" Fugitive show on github mapping
nnoremap <leader>gb :<c-r>=line('.')<cr>Gbrowse<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>

" Rvm integration
set shell=/bin/zsh

" airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#show_close_button = 0

" delete buffer
nnoremap <C-c> :bnext\|bdelete #<cr>

" Setup vroom
let g:vroom_use_colors = 1
let g:vroom_use_vimux = 1
let g:vroom_write_all = 1
let g:vroom_map_keys = 0
let g:vroom_use_spring = 0
let g:vroom_use_binstubs = 0

map  <leader>a :VroomRunTestFile<cr>
map  <leader>t :VroomRunNearestTest<cr>
map  <leader>l :VroomRunLastTest<cr>

" Vimux
map <leader>c :VimuxCloseRunner<cr>
map <leader>i :VimuxInspectRunner<cr>
map <leader>z :VimuxZoomRunner<cr>

" NerdTree
map <leader>n :NERDTreeToggle<cr>

" Commandline navigation mapping
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" JSX
let javascript_enable_domhtmlcss=1

set rtp+=/usr/local/Cellar/fzf/HEAD

map <leader><enter> :FZF<cr>

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Tagbar
nmap <leader>m :TagbarToggle<cr>
let g:tagbar_left=1
