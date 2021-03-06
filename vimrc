if has('vim_starting')
  set nocompatible
  set runtimepath+=~/.vim/bundle/neobundle.vim/

  " Bootstrap: install NeoBundle if it's not already loaded
  if !isdirectory(expand('~/.vim/bundle/neobundle.vim'))
    echo "Installing NeoBundle\n"
    silent execute '!mkdir -p ~/.vim/bundle'
    silent execute '!git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim'
  endif
endif

call neobundle#begin(expand('~/.vim/bundle'))
NeoBundleFetch 'Shougo/neobundle.vim'

" Get the OS name into 'os' for use during configuration checks
let os = substitute(system('uname'), "\n", "", "")

" My Bundles:
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'tpope/vim-sensible'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'bling/vim-airline'
NeoBundle 'fatih/vim-go'
NeoBundle 'vimoutliner/vimoutliner'
NeoBundle 'SirVer/ultisnips'
NeoBundle 'honza/vim-snippets'
NeoBundle 'zhaocai/GoldenView.Vim'
if os == 'Darwin'
  " Dash only works on MacOs
  NeoBundle 'rizzatti/dash.vim'
endif

call neobundle#end()
NeoBundleCheck

filetype plugin indent on
syntax on

let mapleader=","           " use , rather than \
let g:sh_noisk=1            " avoid accidental changes to keywords
let g:netrw_liststyle=3     " use NERDTree listing style in netrw

set smartindent             " enable smartindenting
set shiftwidth=2            " 2-character indents by default
set tabstop=2               " 2-character tabs by default
set expandtab               " convert tabs to spaces by default
set textwidth=79            " wrap lines at 79 characters by default
set formatoptions+=t        " enable textwrapping by default
set hidden                  " allow unsaved buffers in background
set laststatus=2            " keep status lines across buffers
set showmatch               " show matching braces
set hlsearch                " highlight search; <C-l> to clear highligts
set ignorecase              " ignore case while searching
set smartcase               " use smartcase while searching
set scrolloff=5             " keep 5 lines of context on screen
set modeline                " Look for modelines in files
set modelines=5             " Look for modelines in first/last 5 lines
set numberwidth=5           " enough for 1000s of lines without change
set shortmess+=aT           " get rid of some "Hit enter to continue" messages
set nrformats="hex"         " leading zeros do not mean octal
set wildmode=longest,list   " use tab completion for selecting files
set nojoinspaces            " insert only on space when joinging lines
set complete-=i             " do not scan included files for completions
set nowrap                  " do not wrap long lines
set sidescroll=5            " scroll long lines 5 characters at atime
set listchars+=precedes:<,extends:>
set autochdir
set visualbell              " no visual bell flash
set t_vb=                   " no visual bell flash
set guicursor+=a:blinkon0   " disasble GUI blinking cursor
set mouse=a                 " enable mouse

if has('gui_running')
  if os == "Linux"
    set guifont=Source\ Code\ Pro\ for\ Powerline\ Medium\ 11
  else
    set guifont=Source\ Code\ Pro\ for\ Powerline:h12
  endif
  set guioptions-=T   " no toolbar
endif

" Execute a commend preserving editor context
" (cursor location, jump location, search history, etc.)
function! Preserve(command)
  " Preparation: save last search, and cursor position.
  let l:win_view = winsaveview()
  let l:last_search = getreg('/')

  " Do the business:
  execute 'keepjumps ' . a:command

  " Clean up: restore previous search history, and cursor position
  call winrestview(l:win_view)
  call setreg('/', l:last_search)
endfunction

" Strip trailing whitepsace from buffer
nmap <silent> _$ :call Preserve("%s/\\s\\+$//e")<CR>

" Reformat entire buffer
nmap <silent> _= :call Preserve("normal gg=G")<CR>

" Apply macros with Q. qq to record; q to stop; Q to execute
noremap Q @q
vnoremap @ :norm @q<cr>

" Toggle paste with ,z
set pastetoggle=<leader>z

" Align current paragraph or code block with ,a
noremap <leader>a =ip

" Shift <direction> to change tabs
noremap <S-l> gt
noremap <S-h> gT

" Control <direction> to change panes
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k

" Swap the current character with the next, without changing cursor position:
:nnoremap <silent> gc xph

" Swap the current word with the next, without changing cursor position:
:nnoremap <silent> gw "_yiw:s/\(\%#\w\+\)\(\W\+\)\(\w\+\)/\3\2\1/<CR><c-o><CR>:noh<CR>

" Swap the current word with the previous, keeping cursor on current word:
" (This feels like "pushing" the word to the left.)
:nnoremap <silent> gl "_yiw?\w\+\_W\+\%#<CR>:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>:noh<CR>

" Swap the current word with the next, keeping cursor on word current:
" (This feels like "pushing" the word to the right.)
:nnoremap <silent> gr "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><c-o>/\w\+\_W\+<CR>:noh<CR>

"
" Color theme settings
"
set background=dark
colorscheme hybrid

" Tweak line number setting after colorscheme loads
autocmd! ColorScheme * highlight! LineNr guifg=#405060

"
" vim-airline plugin configuration
"
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1

"
" UltiSnips
"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"
" Ag
"
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif

" Grep for word under cursor and show results in quickfix window
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

" grep shortcut
command! -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
nnoremap \ :Ag<SPACE>


"
" Language-specific settings
"
function! EnterGoFile()
  let g:gofmt_command="goimports"
  " Go uses tabs, not spaces for indentation
  setlocal softtabstop=4 tabstop=4 shiftwidth=4 noexpandtab
  setlocal number nolist
  " autowrap comments at 80, but not code
  setlocal wrap textwidth=79 formatoptions=caroqnblj
  setlocal foldmethod=indent foldnestmax=1 foldlevel=1
  nnoremap <silent> <leader>gb :GoBuild<CR>
endfunction

augroup filetypes
  au!
  au BufRead,BufNewFile *.markdown,*.md set filetype=markdown

  au FileType markdown setlocal softtabstop=4 tabstop=4 shiftwidth=4 noexpandtab
  au FileType make setlocal sts=4 ts=4 sw=4 noet ai com=n: fo=tcroqn2
  au BufEnter *.md exe 'noremap <F5> :!/usr/bin/google-chrome %:p<CR>'

  au BufRead,BufNewFile *.go call EnterGoFile()
  au BufRead,Bufnew $MYVIMRC,$MYGVIMRC setlocal number
  au BufWritePost $MYVIMRC nested source $MYVIMRC
  au BufWritePost $MYGVIMRC nested source $MYGVIMRC
augroup end

" Source a local configuration if it exists
if filereadable($HOME . "/.vimrc-local")
  source $HOME/.vimrc-local
endif
