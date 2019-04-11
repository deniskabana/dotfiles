" Set language to english
set langmenu=en_US
let $LANG = 'en_US'

" Change leader key from \ to ,
let mapleader=","

set showcmd                " Show (partial) command in status line
"set showmatch              " Show matching brackets
set noshowmode             " Don't show current mode
set number                 " Show the line numbers on the left side
set relativenumber         " Show relative line numbering
set hidden                 " Ability to close buffer without saving it

set textwidth=0            " Don't wrap lines when reformatting
set expandtab              " Insert spaces when TAB is pressed
set tabstop=2              " Render TABs using this many spaces
set shiftwidth=2           " Indentation amount for < and > commands
set history=2000           " Remember 1000 steps back
set undolevels=2000        " Undo a thousand times
set title                  " Change terminal title

set noerrorbells           " No beeps when reaching end of file
set nomodeline             " Disable modeline - security vulnerability
set linespace=0            " Set vertical space between lines to a minimum
set nojoinspaces           " Prevents inserting two spaces after punctuation on a join
set backupdir=~/.vim/tmp,. " Save backups (swap/ext files) to a dedicated directory (create beforehand)
set directory=~/.vim/tmp,. " Save backups (swap/ext files) to a dedicated directory (create beforehand)
set hlsearch               " Highlight search results.
set ignorecase             " Make search case insensitive
set smartcase              " ... unless the query has capital letters.
set incsearch              " Incremental search.
set gdefault               " Use 'g' flag by default with :s/foo/bar/.
set magic                  " Use 'magic' patterns (extended regular expressions).

" More natural splits
set splitbelow             " Horizontal split below current
set splitright             " Vertical split to right of current
set pastetoggle=<F2>       " Toggle paste mode to stop indentation

" Absolute line numbers in inactive splits, hybrid in splits
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END

filetype plugin indent on  " Handle correct filetype selection, specific plugins and indentation detection

" More user-friendly scrolling
if !&scrolloff
  set scrolloff=3       " Show next 3 lines while scrolling.
endif
if !&sidescrolloff
  set sidescrolloff=5   " Show next 5 columns while side-scrolling.
endif
set display+=lastline
set nostartofline       " Do not jump to first character with page commands.

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Tell Vim which characters to show for expanded TABs, trailing whitespace, and end-of-lines. VERY useful!
set listchars=tab:»\ ,trail:~,precedes:<
" Show problematic characters.
set list
" Highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$\|\t/
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Use json type with common dot files
au BufRead,BufNewFile *.babelrc setfiletype json
au BufRead,BufNewFile *.eslintrc setfiletype json
au BufRead,BufNewFile *.prettierrc setfiletype json

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<CR><C-L>
endif

" Use ; for commands (doesn't need shift pressed)
nnoremap ; :

" Disable automatic comment continuation
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Theme
syntax enable

" Update path to enable <gf> on file/module imports
" eg. 'files/tex|t' => press <gf> to open file 'files/text.*'
set path+=*

" Highlight the current cursor line
set cursorline

" Map <f10> to open vim config
nnoremap <f10> :e ~/.config/nvim/init.vim<return>

" Disable automatic comment continuation
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"
" PLUGINS
"
call plug#begin('~/.vim/plugged')
  " Basic vim tools
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " FZF plugin for vim
  Plug 'scrooloose/nerdtree' " File explorer
  Plug 'ryanoasis/vim-devicons' " Icons in NERDTree
  Plug 'Xuyuanp/nerdtree-git-plugin' " Record git changes in NERDTree
  Plug 'ap/vim-css-color/' " Highlight CSS colours (rgb, hex etc.)
  Plug 'junegunn/vim-easy-align' " Align by a symbol (e.g. =)
  Plug 'tpope/vim-fugitive' " Git wrapper for vim
  Plug 'Soares/butane.vim' " Better buffer control
  Plug 'easymotion/vim-easymotion' " Easy motion for distant words / characters
  Plug 'Yggdroot/indentLine' " Show indentation marks
  Plug 'mhinz/vim-signify' " Indicate lines that changed
  Plug 'jiangmiao/auto-pairs' " Pair quotes, parentheses etc.
  Plug 'itchyny/lightline.vim' " Status line
  Plug 'mileszs/ack.vim' " Best search engine for vim
  Plug 'tpope/vim-surround' " Advanced surround in vim
  Plug 'alvan/vim-closetag' " Close HTML tags
  Plug 'ap/vim-buftabline' " Show active buffers
  Plug 'scrooloose/nerdcommenter' " Easy commenting
  Plug 'tpope/vim-sleuth' " Automatically set file indentation
  Plug 'djoshea/vim-autoread' " Update changed files
  "Plug 'Valloric/MatchTagAlways' " Highlight matching symbol (e.g. bracket)
  Plug 'haya14busa/incsearch.vim' " Progressively show search results
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}} " VSCode's IntelliSense server in vim

  " Language specific tools
  Plug 'sheerun/vim-polyglot' " Language collection for vim
  Plug 'elzr/vim-json' " JSON file support
  Plug 'pangloss/vim-javascript' " Proper javascript support
  Plug 'mxw/vim-jsx' " JSX support

  " Color schemes
  " Plug 'joshdick/onedark.vim'
  Plug 'wmvanvliet/vim-blackboard'
  Plug 'reewr/vim-monokai-phoenix'
  Plug 'fneu/breezy'
call plug#end()
"
" END PLUGINS
"

" Theme
let $NVIM_TUI_ENABLE_TRUE_COLOR=1 
set termguicolors
set background=dark
colorscheme monokai-phoenix

" Filetypes for vim-closetag (html tag enclosing)
let g:closetag_filenames = "*.html,*.js,*.md,*.jsx,*.pug,*.php"

" NERDTree settings
let g:NERDTreeWinPos = "right" " Open NERDTree on the right side
" Auto-open NERDTree when no file open
au vimenter * if !argc() | NERDTree | endif
" Filter out swap and mac index files from NERDTree
let NERDTreeIgnore = ['\.swp$','\~', '.DS_Store', '.git'] " Don't show unnecessary files
let NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 38 " Make NERDTree wider than default
" Remap nerdtree toggle to ,kb (based on sublime's CMD+kb)
noremap <leader>kb :NERDTreeToggle<CR>

" Search inside a project (check Ack docs for precise info)
nnoremap <leader>f :Ack!

" Toggle highlighting CSS colors
nnoremap <leader>cs :call css_color#toggle()<cr>

" Butane
noremap <leader>bd :Bclose<CR>      " Close the buffer.
noremap <Tab> :bn<CR>               " Next buffer.
noremap <S-Tab> :bp<CR>             " Previous buffer.
noremap <leader>bn :bn<CR>          " Next buffer (legacy mapping).
noremap <leader>bp :bp<CR>          " Previous buffer (legacy mapping).
noremap <leader>bt :b#<CR>          " Toggle to most recently used buffer.
noremap <leader>bx :Bclose!<CR>     " Close the buffer & discard changes.

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Use ack.vim for search with ripgrep
if executable('rg')
  let g:ackprg = 'rg --vimgrep'
  let $FZF_DEFAULT_COMMAND = 'rg --files'
endif

" When FZF launches hide status line
autocmd! FileType fzf
autocmd  FileType fzf set laststatus=0
  \| autocmd BufLeave <buffer> set laststatus=2
" Open FZF by pressing <C-p>
nnoremap <C-p> :FZF<return>

" COC settings
" Add COC output to lightline, set defaults
let g:lightline = {
      \ 'colorscheme': 'breezy',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
set signcolumn=yes
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
