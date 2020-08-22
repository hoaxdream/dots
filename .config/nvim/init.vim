" Autoinstall
if ! filereadable(system('echo -n "$XDG_CONFIG_HOME/nvim/autoload/plug.vim"'))
  echo "Downloading junegunn/vim-plug to manage plugins..."
  silent !mkdir -p $XDG_CONFIG_HOME/nvim/autoload/
  silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > $XDG_CONFIG_HOME/nvim/autoload/plug.vim
  autocmd VimEnter * PlugInstall
endif

" General settings
let mapleader=' '              " Map <space> as leader key
colorscheme gruvbox-material   " Sets colorscheme
scriptencoding utf-8           " The encoding displayed
set fileencoding=utf-8         " The encoding written to file
set hidden                     " This is recommended by coc
set nobackup                   " This is recommended by coc
set nowritebackup              " This is recommended by coc
set cmdheight=2                " More space for displaying messages
set updatetime=50              " Make it faster
set timeoutlen=500             " Time to wait for a key code sequence
set shortmess+=icw             " Avoid message and prompts
set noswapfile                 " Disable swaps
set clipboard+=unnamedplus     " Enable pasting
set mouse=a                    " Enable mouse scrolling
set termguicolors              " Needed by coc-highlight
syntax on                      " Enable syntax
set laststatus=2               " Enable statusline
set ruler                      " Show the cursor position
set noshowmode                 " Disable INSERT mode showing up
set noshowcmd                  " Disable line or column number
set showmatch                  " Show matching brackets or parenthesis
set shortmess+=icw             " Avoid message and prompts
set number relativenumber      " Show line numbers
set nowrap                     " Display long lines as just one line
set cursorline                 " Highlight current line
set cursorcolumn               " Horizontal cursor line
set scrolloff=10               " Minimal number to keep above or below the cursor
set tabstop=2                  " Insert 4 spaces for tab
set shiftwidth=2               " Change number of space characters inserted for indention
set smartindent                " Makes indenting smart
set autoindent                 " Good auto indent
set expandtab                  " Convert tabs to spaces
set splitbelow                 " Horizontal splits will automatically set below
set splitright                 " Vertical splits will automaticall set to the right
set foldcolumn=0               " Indicate folds and their nesting levels
set foldmethod=marker          " Fold stuff using {}
set hlsearch                   " Search highlight
set ignorecase                 " Ignore search case
set smartcase                  " Overrride ignorecase if typed text contain upper case
set inccommand=nosplit         " Show pattern when typing (for :s/)
set incsearch                  " While typing a search command, show where the pattern is
set wildmenu                   " Enable wildmenu
set wildmode=longest:full,full " Wildmenu style
set wildignorecase             " Ignore case by wildmenu

" Show invisibles
set list
set listchars=
set listchars+=tab:.\
set listchars+=trail:.
set listchars+=extends:»
set listchars+=precedes:«
set listchars+=nbsp:░

" Load plugins
call plug#begin('~/.config/nvim/plugged')

Plug 'sheerun/vim-polyglot'                                             " Syntax hl
Plug 'neoclide/coc.nvim', {'branch': 'release'}                         " Conquer Of Completion
Plug 'mhinz/vim-startify'                                               " Project management
Plug 'liuchengxu/vim-which-key'                                         " Shows keybindings in popup
Plug 'tpope/vim-fugitive'                                               " Git integration
Plug 'luochen1990/rainbow'                                              " Color matching pairs
Plug 'lukelbd/vim-tabline'                                              " Simple buffer tabline
Plug 'vifm/vifm.vim'                                                    " Vifm like nerdtree
Plug 'Yggdroot/indentLine'                                              " Indent guidelines
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}   " Markdown preivew

call plug#end()

" Autocmd
augroup BufferWrite
  au!
  " Reload programs when configuration is updated
  autocmd BufWritePost files,directories !shortcuts
  autocmd BufWritePost *Xresources !xrdb %
  autocmd BufWritePost dunstrc !pkill dunst; dunst &
  autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd
  autocmd BufWritePost init.vim,gruvbox-material.vim,statusline.vim source $MYVIMRC
augroup end

augroup FileTypes
  au!
  " Disables automatic commenting on newline:
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
   " Turn spellcheck on for markdown files
  autocmd FileType markdown setlocal spell
  autocmd FileType markdown setlocal complete+=kspell
augroup END

" Source and load plugins configurations
source $HOME/.config/nvim/plug-config/coc.vim
source $HOME/.config/nvim/plug-config/mdprev.vim
source $HOME/.config/nvim/plug-config/startify.vim
source $HOME/.config/nvim/plug-config/which-key.vim
source $HOME/.config/nvim/plug-config/indentlines.vim
source $HOME/.config/nvim/plug-config/rainbow.vim
source $HOME/.config/nvim/plug-config/keymaps.vim
source $HOME/.config/nvim/plug-config/statusline.vim
