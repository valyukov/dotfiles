if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

if has('nvim')
  autocmd! BufWritePost * Neomake
endif

set nocompatible

" Leader
let mapleader = " "
set inccommand=nosplit
set hidden
set laststatus=2          " last window always has a statusline
set nohlsearch            " Don't continue to highlight searched phrases.
set ignorecase            " Make searches case-insensitive.
set nowrap                " don't wrap text
set backspace=2           " Backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
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
set mouse=""              " Disable mouse

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
  autocmd FileType gitcommit setlocal textwidth=90
  autocmd FileType gitcommit setlocal spell spelllang=ru_yo,en_us

  " Ruby idention
  autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
  autocmd FileType ruby compiler ruby

  " vim-ruby completions
  autocmd BufNewFile,BufRead *.jbuilder set filetype=ruby
  autocmd User Rails                    silent! Rlcd

  " Yaml spellchecking
  autocmd FileType yaml setlocal spell spelllang=ru_yo,en_us

  " Open help at vertical split
  autocmd BufRead,BufEnter */doc/* wincmd L

  autocmd TermOpen * setlocal statusline=%{b:term_title}
  autocmd TermOpen * setlocal number
  autocmd TermOpen * setlocal relativenumber
  autocmd BufEnter term://* stopinsert
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
colorscheme solarized     " set colorscheme
set background=light
set showtabline=2
set cursorline

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=1200

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·,extends:❯,precedes:❮

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

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
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gB :Gbrowse<cr>

" airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#exclude_preview = 1
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#tagbar#enabled = 0

" Commandline navigation mapping
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

nnoremap <silent> <Leader><enter> :call fzf#run({ 'source': 'ag -g ""', 'sink': 'e', 'window': 'rightbelow new'}) <CR>

if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

nnoremap <C-k> :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" Erlang
let g:erlang_highlight_special_atoms = 1
set runtimepath^=~/.vim/plugged/vim-erlang-runtime
set runtimepath^=~/.vim/plugged/vim-erlang-tags

" VimTest
nnoremap <silent> ,rt :TestSuite<cr>
nnoremap <silent> ,rf :TestFile<cr>
nnoremap <silent> ,rn :TestNearest<cr>
nnoremap <silent> ,rr ::TestLast<cr>

let test#strategy = "neovim"

" Deoplete
let g:deoplete#enable_at_startup = 1

" Enable credo and mix compilefor elixir files
let g:neomake_elixir_enabled_makers = ['elixir', 'credo']

let g:neomake_elixir_elixir_exe="mix"
let g:neomake_elixir_elixir_args=['compile ', '%:p']

let g:alchemist#elixir_erlang_src="~/Development"
