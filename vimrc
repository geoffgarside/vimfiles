set nocompatible                " choose no compatibility with legacy vi
set encoding=utf-8

call pathogen#infect()
call pathogen#helptags()

filetype plugin indent on       " load file type plugins + indentation

runtime macros/matchit.vim      " enables % to cycle through `if/else/endif`

syntax enable

if has('gui_running')
  set background=light
else
  set background=dark
endif
let g:solarized_termcolors=256
colorscheme solarized

"" Basic Config
set number                      " line numbers (number|nonumber)
set ruler                       " show the cursor position all the time
set cursorline                  " highlight the line of the cursor
set showcmd                     " display incomplete commands
set showmode                    " show current mode down the bottom ??

set shell=bash                  " avoids munging PATH under zsh
let g:is_bash=1                 " default shell syntax

set history=200                 " remember more Ex commands
set scrolloff=3                 " have some context around the current line always on screen

set autoread                    " reload files changed outside vim

" Allow backgrounding buffers without writing them, and remember marks/undo
" for backgrounded buffers
set hidden

"" Whitespace
set nowrap                      " don't wrap lines
set tabstop=2                   " a tab is two spaces
set shiftwidth=2                " an autoindent (with <<) is two spaces
set expandtab                   " use spaces, not tabs
set backspace=indent,eol,start  " backspace through everything in insert mode

" List chars ??
set list                        " Show invisible characters
set listchars=""                " Reset the listchars
set listchars=tab:\ \           " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.          " show trailing spaces as dots
set listchars+=extends:>        " The character to show in the last column when wrap is
                                " off and the line continues beyond the right of the screen
set listchars+=precedes:<       " The character to show in the first column when wrap is
                                " off and the line continues beyond the left of the screen

"" Searching
set hlsearch                    " highlight matches
set incsearch                   " incremental searching
set ignorecase                  " searches are case insensitive...
set smartcase                   " ... unless they contain at least one capital letter

function s:setupWrapping()
  set wrap
  set wrapmargin=2
  set textwidth=80
endfunction

if has("autocmd")
  " In Makefiles, use real tabs, not tabs expanded to spaces
  au FileType make set noexpandtab

  " Make sure all markdown files have the correct filetype set and setup wrapping
  au BufRead,BufNewFile *.{md,markdown,mdown,mkd,mkdn,txt} setf markdown | call s:setupWrapping()

  " Treat JSON files like JavaScript
  au BufNewFile,BufRead *.json set ft=javascript

  " make Python follow PEP8 ( http://www.python.org/dev/peps/pep-0008/ )
  au FileType python set softtabstop=4 tabstop=4 shiftwidth=4 textwidth=79

  " Remember last location in file, but not for commit messages.
  " see :help last-position-jump
  au BufReadPost * if &filetype !~ '^git\c' && line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif

  " mark Jekyll YAML frontmatter as comment
  au BufNewFile,BufRead *.{md,markdown,html,xml} sy match Comment /\%^---\_.\{-}---$/

  " Start with NerdTree if opened with a directory
  au vimenter * if !argc() | NERDTree | endif

  " Close vim if last buffer is NerdTree
  au bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endif

" clear the search buffer when hitting return
:nnoremap <CR> :nohlsearch<cr>

let mapleader=","

map <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
map <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
map <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
map <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
map <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
map <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
map <leader>gg :topleft 100 :split Gemfile<cr>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>

cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
" map <leader>ew :e %%
" map <leader>es :sp %%
" map <leader>ev :vsp %%
" map <leader>et :tabe %%

let g:CommandTMaxHeight=10
let g:CommandTMinHeight=4

nmap ,n :NERDTreeClose<CR>:NERDTreeToggle<CR>
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$', '\.os$', '\.dylib$', '\.a$',
            \ '\.DS_Store$', '\.bundle$', '\.gitkeep$']
let NERDTreeShowFiles=1           " Show hidden files, too
let NERDTreeShowHidden=1

" ignore Rubinius, Sass cache files
set wildignore+=tmp/**,*.rbc,.rbx,*.scssc,*.sassc

nnoremap <leader><leader> <c-^>

" find merge conflict markers
nmap <silent> <leader>cf <ESC>/\v^[<=>]{7}( .*\|$)<CR>

command! KillWhitespace :normal :%s/ *$//g<cr><c-o><cr>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Mapping ESC in insert mode and command mode to double i
imap ii <C-[>
cmap ii <C-[>

set backupdir=~/.vim/backup     " where to put backup files.
set directory=~/.vim/tmp        " where to put swap files.
set undodir=~/.vim/undos        " where to put undo files
set undofile

if has("statusline") && !&cp
  set laststatus=2  " always show the status bar

  " Start the status line
  set statusline=%f\ %m\ %r

  " Add fugitive
  set statusline+=%{fugitive#statusline()}

  " Finish the statusline
  set statusline+=Line:%l/%L[%p%%]
  set statusline+=Col:%v
  set statusline+=Buf:#%n
  set statusline+=[%b][0x%B]

  " Powerline statusline config
  let g:Powerline_symbols = 'fancy'
  let g:Powerline_theme = 'solarized256'
  let g:Powerline_colorscheme = 'solarized256'
endif
