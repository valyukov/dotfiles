" Use Vim settings, rather then Vi settings. This setting must be as early as
" possible, as it has side effects.
set nocompatible

" Leader
let mapleader = " "

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

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
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell spelllang=ru_ru,en_us

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

  " Automatically wrap at 72 characters and spell check git commit messages
  autocmd FileType gitcommit setlocal textwidth=120
  autocmd FileType gitcommit setlocal spell spelllang=ru_ru,en_us

  " Allow stylesheets to autocomplete hyphenated words
  autocmd FileType css,scss,sass setlocal iskeyword+=-

  " Ruby idention
  autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
  autocmd FileType ruby compiler ruby

  " vim-ruby completions
  autocmd FileType ruby,eruby           set omnifunc=rubycomplete#Complete
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
set number                " show line numbers
set showtabline=2
set cursorline

" Improve vim's scrolling speed
set ttyfast
set ttyscroll=3
set lazyredraw

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=1200

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·,extends:❯,precedes:❮

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Auto-reload buffers when files are changed on disk
set autoread

" Lines with equal indent form a fold.
set foldmethod=indent
set foldlevel=1
set foldnestmax=10

" Open all folds by default
set nofoldenable

set undofile                    " Save undo's after file closes
set undodir=~/.vim/undo         " where to save undo histories
set undolevels=1000             " How many undos
set undoreload=10000            " number of lines to save for undo

set tagbsearch " use binary searching for tags

" Text-Object
runtime macros/matchit.vim


" Unite
let g:unite_data_directory="~/.vim/.cache/unite"
let g:unite_source_rec_max_cache_files=10000
let g:unite_source_file_mru_limit = 200
let g:unite_prompt='» '

call unite#custom#profile('default', 'context', {
                        \ 'start_insert': 1,
                        \ 'winheight': 10,
                        \ 'direction': 'botright',
                        \ })

call unite#custom#source('file_rec/async:!,file_mru,buffer,file_rec/git,grep', 'matchers',
                        \['converter_relative_word',
                        \ 'matcher_hide_hidden_files',
                        \ 'matcher_project_ignore_files',
                        \ 'matcher_hide_current_file',
                        \ 'matcher_default'])

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_selecta'])
call unite#custom#default_action('grep,file_rec/async:!,file_rec/git', 'tabopen')

if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  let g:unite_source_grep_command='ag'
  let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C8'
  let g:unite_source_grep_recursive_opt=''
endif

nnoremap <leader>f :<C-u>Unite -buffer-name=files -resume       file_rec/async:!<cr>
nnoremap <leader>r :<C-u>Unite -buffer-name=mru                 file_mru<cr>
nnoremap <leader>p :<C-u>Unite -buffer-name=git -resume         file_rec/git<cr>
nnoremap <leader>o :<C-u>Unite -buffer-name=outline             outline<cr>
nnoremap <leader>e :<C-u>Unite -buffer-name=buffer              buffer<cr>
nnoremap <leader>G :<C-u>Unite -buffer-name=grep                grep<cr>
nnoremap <leader>g :<C-u>UniteWithCursorWord -buffer-name=grep  grep<cr>
nnoremap <leader>h :<C-u>UniteWithCursorWord -buffer-name=help  help<cr>
nnoremap <leader>H :<C-u>Unite -buffer-name=help                help<cr>
autocmd FileType unite call s:unite_settings()

function! s:unite_settings()
  let b:SuperTabDisabled=1
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
  imap <silent><buffer><expr> <C-x> unite#do_action('split')
  imap <silent><buffer><expr> <C-v> unite#do_action('vsplit')
  imap <silent><buffer><expr> <C-t> unite#do_action('tabopen')
  nmap <buffer> <ESC> <Plug>(unite_exit)
  nmap <buffer> <C-c> <Plug>(unite_exit)
endfunction


" Neosnippet
" Plugin key-mappings.
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \"\<Plug>(neosnippet_expand_or_jump)"
      \: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
      \"\<Plug>(neosnippet_expand_or_jump)"
      \: "\<TAB>"

" Scope aliases
let g:neosnippet#scope_aliases = {}
let g:neosnippet#scope_aliases['ruby'] = 'ruby,ruby-rails,rails'

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1


" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1

" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif

" Set async completion.
let g:monster#completion#rcodetools#backend = "async_rct_complete"

" Use neocomplete.vim
let g:neocomplete#force_omni_input_patterns = {'ruby' : '[^. *\t]\.\|\h\w*::'}

let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" Search from neocomplete, omni candidates, vim keywords.
let g:neocomplete#fallback_mappings = ["\<C-x>\<C-o>", "\<C-x>\<C-n>"]

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " For no inserting <CR> key.
  return pumvisible() ? neocomplete#close_popup() : "\<CR>"
endfunction

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()

" Ruby completions
" let g:rubycomplete_buffer_loading = 1
" let g:rubycomplete_classes_in_global = 1
" let g:rubycomplete_rails = 1

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

" set terminal title
if &term == "screen"
  set t_ts=^[k
  set t_fs=^[\
endif
if &term == "screen" || &term == "xterm" || &term == "xterm-256color"
  set title
endif


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
vnoremap <leader>gb :Gbrowse<cr>
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gp :Gpush<cr>
nnoremap <leader>gd :Gdiff<cr>


" Syntastic settings
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_ruby_rubocop_args = "-D -c ~/.rubocop.yml"


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
let g:vroom_use_spring = 1
let g:vroom_use_binstubs = 1

map  <leader>t :VroomRunTestFile<cr>
map  <leader>T :VroomRunNearestTest<cr>
map  <leader>l :VroomRunLastTest<cr>

" Vimux
map <leader>c :VimuxCloseRunner<cr>
map <leader>i :VimuxInspectRunner<cr>
map <leader>z :VimuxZoomRunner<cr>

" NerdTree
map <leader>n :NERDTreeToggle<cr>

" NeoMRU
let g:neomru#file_mru_limit = 50
