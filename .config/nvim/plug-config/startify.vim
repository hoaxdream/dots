" Startify custom header 1 cow
let g:startify_custom_header = 'startify#pad(startify#fortune#cowsay())'

" Sartify custom header Neovim
"let g:startify_custom_header = [
"            \ '   _____   __                 _____            ',
"            \ '   ___  | / /_____________   ____(_)______ ___ ',
"            \ '   __   |/ /_  _ \  __ \_ | / /_  /__  __ `__ \',
"            \ '   _  /|  / /  __/ /_/ /_ |/ /_  / _  / / / / /',
"            \ '   /_/ |_/  \___/\____/_____/ /_/  /_/ /_/ /_/ ',
"            \]

let g:startify_lists = [
            \ { 'type': 'files',     'header': ['   Files']            },
            \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
            \ { 'type': 'sessions',  'header': ['   Sessions']       },
            \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
            \ ]

let g:startify_bookmarks = [
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'c': '~/.config' },
            \ { 'b': '~/.local/bin' },
            \ { 'd': '~/.local/dl' },
            \ { 'D': '~/.config/dl/notes' },
            \ ]

" Session dir
let g:startify_session_dir = '~/.config/nvim/cache/session'

" Let Startify take care of buffers
let g:startify_session_delete_buffers = 1

" Similar to Vim-rooter
let g:startify_change_to_vcs_root = 0

" Autoload Session.vim
let g:startify_session_autoload = 1

" Automaticly update session
let g:startify_session_persistence = 1

" Get rid of empy buffer and quit
let g:startify_enable_special = 0


