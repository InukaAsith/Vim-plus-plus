" Basic settings
"


let g:asyncomplete_enable = 0
let g:asyncomplete_auto_popup = 0
let g:loaded_asyncomplete = 1

let g:minimap_width = 10
let g:minimap_auto_start = 0
let g:minimap_auto_start_win_enter = 0

" Disable built-in completion
" set infercase
" inoremap <C-n> <Nop>
" inoremap <C-p> <Nop>
" inoremap <C-x><C-o> <Nop>
" inoremap <C-x><C-n> <Nop>
" inoremap <C-x><C-p> <Nop>
" inoremap <C-x><C-l> <Nop>
" inoremap <C-x><C-f> <Nop>




set clipboard=unnamedplus       " Use system clipboard
set showmatch                  " Show matching brackets

" Search settings
set ignorecase                 " Case-insensitive search...
set smartcase                  " ...unless uppercase used
set incsearch                  " Show matches while typing
set hlsearch                   " Highlight search matches

" Undo/backup
set undofile                   " Enable persistent undo

" Line numbers and display
set number                     " Absolute line numbers
set relativenumber             " Relative line numbers
set termguicolors              " True color support
set background=dark            " Dark background for themes
syntax on                      " Enable syntax highlighting
filetype plugin indent on      " Filetype detection and indent

" Tabs and indentation
set tabstop=4
set shiftwidth=4
set expandtab                  " Use spaces instead of tabs
set smartindent                " Smart autoindent
set nowrap                     " No line wrap
set scrolloff=4                " Keep 4 lines visible above/below cursor

" Clipboard mappings
nmap <leader>y "+y
vmap <leader>y "+y
nmap <leader>p "+p
vmap <leader>p "+p

" Leader key
let mapleader = " "

" Lightline statusline
set laststatus=2
set noshowmode
let g:lightline = { 'colorscheme': 'wombat' }

" NERDTree for file explorer
nnoremap <C-n> :NERDTreeToggle<CR>

" Easier terminal <-> normal mode switch
tnoremap <Esc> <C-\><C-n>

" Startup optimization
autocmd VimEnter * ++nested syntax enable

" Plugins via vim-plug
call plug#begin('~/.vim/plugged')
  " LSP client only (without auto-installer to prevent prompts)
  Plug 'prabirshrestha/vim-lsp'
  " Remove this line: Plug 'mattn/vim-lsp-settings'

  " Fuzzy finder
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

  " Git integration
  Plug 'tpope/vim-fugitive'

  " Comment toggling
  Plug 'preservim/nerdcommenter'

  " Surroundings
  Plug 'tpope/vim-surround'

  " Polyglot language packs
  Plug 'sheerun/vim-polyglot'

  " Theme: Catppuccin
  Plug 'catppuccin/vim', { 'as': 'catppuccin' }

  " Lightline plugin
  Plug 'itchyny/lightline.vim'

  " VSCode-style tabs
  Plug 'ap/vim-buftabline'

  " Terminal plugin
  Plug 'kassio/neoterm'

  " Enhanced completion framework
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  Plug 'prabirshrestha/asyncomplete-file.vim'

  " Optional: Better bracket handling
  Plug 'jiangmiao/auto-pairs'

  Plug 'wfxr/minimap.vim'
  Plug 'preservim/nerdtree'

call plug#end()

" Theme settings
colorscheme catppuccin_mocha

" ============================
"     TAB CONFIGURATION
" ============================
" Show tabs at the top (VSCode-style)
set showtabline=2              " Always show tabline
let g:buftabline_show = 2      " Always show buftabline
let g:buftabline_numbers = 1   " Show buffer numbers in tabs
let g:buftabline_indicators = 1 " Show modified indicator

" ============================
"     TERMINAL CONFIGURATION  
" ============================
" Neoterm settings for bottom terminal
let g:neoterm_default_mod = 'belowright'      " Terminal at bottom
let g:neoterm_size = 12                       " Terminal height
let g:neoterm_autoscroll = 1                  " Auto scroll terminal
let g:neoterm_keep_term_open = 1              " Keep terminal open

" ============================
"     CLEAN MODE TOGGLE
" ============================
let g:clean_mode_file = expand('~/.vim/clean_mode')

" Load Clean Mode preference on startup
function! LoadCleanModePreference()
  if filereadable(g:clean_mode_file)
    let g:clean_mode = 1
    call ApplyCleanMode()
    echo "CLEAN MODE: Restored from last session. Use <Leader>z to toggle"
  else
    let g:clean_mode = 0
    call ApplyFullMode()
  endif
endfunction

" Save Clean Mode preference
function! SaveCleanModePreference()
  if g:clean_mode
    call writefile(['1'], g:clean_mode_file)
  else
    if filereadable(g:clean_mode_file)
      call delete(g:clean_mode_file)
    endif
  endif
endfunction

function! ToggleCleanMode()
  if g:clean_mode
    " Exit Clean Mode - Restore everything
    let g:clean_mode = 0
    call ApplyFullMode()
    call SaveCleanModePreference()
    echom "FULL MODE: All features enabled.\nUse <Leader>z for clean mode, <Leader>l for LSP, f8 for minimap, <leader>t for terminal"
  else
    " Enter Clean Mode - Minimal Vim
    let g:clean_mode = 1
    call ApplyCleanMode()
    call SaveCleanModePreference()
    echom "CLEAN MODE: Minimal Vim active. Use <Leader>z to restore full features"
  endif
endfunction

function! ApplyFullMode()
  " Restore visual enhancements
  set number
  set relativenumber
  set termguicolors
  syntax on
  colorscheme catppuccin_mocha
  set mouse=a                    " Enable mouse in all modes

  " Restore tabs and statusline
  set showtabline=2
  let g:buftabline_show = 2
  call LoadLightline()
  set laststatus=2
  set noshowmode
  let g:lightline = { 'colorscheme': 'wombat' }

  " Force lightline refresh
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
  
  " Re-enable all custom mappings
  call RestoreCustomMappings()
endfunction

function! ApplyCleanMode()
  " Disable visual enhancements but keep basic syntax
  set nonumber
  set norelativenumber
  set notermguicolors
  set mouse=                    " Enable mouse in all modes

  " Hide tabs in clean mode
  set showtabline=0
  let g:buftabline_show = 0
  
  " Use default colorscheme but keep syntax highlighting
  colorscheme default
  set background=dark
  syntax on
  
  " Minimal statusline
  call UnloadLightline()
  
  " Clear all custom mappings except the toggle
  " Disable completion in clean mode
  let g:asyncomplete_auto_popup = 0

  call ClearCustomMappings()

  " Keep only essential mappings
  nnoremap <Leader>z :call ToggleCleanMode()<CR>
endfunction

function! ClearCustomMappings()
  " Clear LSP mappings
  silent! nunmap <Leader>l
  silent! nunmap <Leader>ls
  silent! nunmap <Leader>li
  
  " Clear file navigation (fzf)
  silent! nunmap <Leader>ff
  silent! nunmap <Leader>fg
  silent! nunmap <Leader>fb
  silent! nunmap <Leader>fl
  silent! nunmap <Leader>fw
  
  " Clear bookmarks (harpoon-like)
  silent! nunmap <Leader>ma
  silent! nunmap <Leader>ja
  silent! nunmap <Leader>aa
  silent! nunmap <Leader>an
  silent! nunmap <Leader>ap
  silent! nunmap <Leader>al
  
  " Clear git mappings
  silent! nunmap <Leader>gs
  silent! nunmap <Leader>gd
  silent! nunmap <Leader>gc
  
  " Clear tab mappings
  silent! nunmap <C-t>
  silent! nunmap <C-w>
  silent! nunmap <Leader><Tab>
  silent! nunmap <Leader><S-Tab>
  silent! nunmap <Leader>1
  silent! nunmap <Leader>2
  silent! nunmap <Leader>3
  silent! nunmap <Leader>4
  silent! nunmap <Leader>5
  silent! nunmap <Leader>6
  silent! nunmap <Leader>7
  silent! nunmap <Leader>8
  silent! nunmap <Leader>9
  silent! nunmap H
  silent! nunmap L
  silent! nunmap <Leader>wo
  silent! nunmap <Leader>wa
  
  " Clear terminal mappings
  silent! nunmap <Leader>t
  silent! nunmap <C-`>
  silent! tnoremap <C-`>
  
  " Clear other mappings
  silent! nunmap <Leader>c
  silent! nunmap <C-n>
  silent! nunmap <F8>
  silent! nunmap <C-s>
  silent! iunmap <C-s>
  silent! vunmap <C-s>

  " Clear workspace mappings
  silent! nunmap <Leader>wo
  silent! nunmap <Leader>wr
  silent! nunmap <Leader>ws
  silent! nunmap <Leader>wl
  silent! nunmap <Leader>nf
  silent! nunmap <Leader>nr
  silent! nunmap <Leader>tn
  silent! nunmap <Leader>tp
  silent! nunmap <Leader>tc
  silent! nunmap <Leader>td
  silent! nunmap <Leader>t1
  silent! nunmap <Leader>t2
  silent! nunmap <Leader>t3
  silent! nunmap <Leader>t4
  silent! nunmap <Leader>t5
  silent! nunmap <Leader>ll
  silent! nunmap <Leader>of

  let g:asyncomplete_auto_popup = 0
endfunction

function! RestoreCustomMappings()
  " LSP mappings
  nnoremap <Leader>l :call ToggleLSP()<CR>
  nnoremap <Leader>ls :LspStatus<CR>
  nnoremap <Leader>li :echo "LSP Status: " . (g:lsp_enabled ? "ON" : "OFF")<CR>
  
  " File navigation (fzf)
  nnoremap <Leader>ff :Files<CR>
  nnoremap <Leader>fg :GFiles<CR>
  nnoremap <Leader>fb :Buffers<CR>
  nnoremap <Leader>fl :Lines<CR>
  nnoremap <Leader>fw :Rg<CR>
  
  " Harpoon-like bookmarks
  nnoremap <Leader>ma :let @a=expand('%')<CR>:echo "Marked file in register a"<CR>
  nnoremap <Leader>ja :e @a<CR>
  nnoremap <Leader>aa :argadd %<CR>
  nnoremap <Leader>an :next<CR>
  nnoremap <Leader>ap :prev<CR>
  nnoremap <Leader>al :args<CR>
  
  " Git mappings
  nnoremap <Leader>gs :G<CR>
  nnoremap <Leader>gd :Gdiffsplit<CR>
  nnoremap <Leader>gc :Git commit<CR>
  
  " Tab navigation mappings (MacBook-friendly)
  nnoremap <C-t> :tabnew<CR>
  nnoremap <C-w> :bd<CR>
  nnoremap <Leader><Tab> :bn<CR>
  nnoremap <Leader><S-Tab> :bp<CR>
  nnoremap <Leader>1 :b1<CR>
  nnoremap <Leader>2 :b2<CR>
  nnoremap <Leader>3 :b3<CR>
  nnoremap <Leader>4 :b4<CR>
  nnoremap <Leader>5 :b5<CR>
  nnoremap <Leader>6 :b6<CR>
  nnoremap <Leader>7 :b7<CR>
  nnoremap <Leader>8 :b8<CR>
  nnoremap <Leader>9 :b9<CR>
  
  " Alternative tab switching (H/L for previous/next like browser tabs)
  nnoremap H :bp<CR>
  nnoremap L :bn<CR>
  
  " Close other tabs
  nnoremap <Leader>wo :only<CR>
  nnoremap <Leader>wa :%bd\|e#<CR>
  
  " Terminal mappings
  nnoremap <Leader>t :Ttoggle<CR>
  nnoremap <C-`> :Ttoggle<CR>
  tnoremap <C-`> <C-\><C-n>:Ttoggle<CR>
  
  " Other mappings
  nnoremap <Leader>c <Plug>NERDCommenterToggle
  nnoremap <C-n> :NERDTreeToggle<CR>
  nnoremap <silent> <F8> :call MinimapSmartToggle()<CR>
  
  " Save mappings
  nmap <C-s> :w<CR>
  imap <C-s> <Esc>:w<CR>a
  vmap <C-s> <Esc>:w<CR>gv

  " Workspace management
  nnoremap <Leader>wo :call OpenProjectFolder()<CR>
  nnoremap <Leader>wr :call InitializeWorkspace(getcwd())<CR>
  nnoremap <Leader>ws :call SaveWorkspaceSession()<CR>
  nnoremap <Leader>wl :call LoadWorkspaceSession()<CR>
  
  " NERDTree enhancements
  nnoremap <Leader>nf :NERDTreeFind<CR>
  nnoremap <Leader>nr :NERDTreeRefresh<CR>
  
  " Terminal tab navigation
  nnoremap <Leader>tn :call NextTerminalTab()<CR>
  nnoremap <Leader>tp :call PrevTerminalTab()<CR>
  nnoremap <Leader>tc :call CreateNewTerminalTab()<CR>
  nnoremap <Leader>td :call CloseTerminalTab(g:current_terminal_tab)<CR>
  
  " Terminal tab direct access
  nnoremap <Leader>t1 :call OpenTerminalTab(1)<CR>
  nnoremap <Leader>t2 :call OpenTerminalTab(2)<CR>
  nnoremap <Leader>t3 :call OpenTerminalTab(3)<CR>
  nnoremap <Leader>t4 :call OpenTerminalTab(4)<CR>
  nnoremap <Leader>t5 :call OpenTerminalTab(5)<CR>
  
  " Quick layout toggle
  nnoremap <Leader>ll :call SetupWorkspaceLayout()<CR>
  
  " Enhanced file operations
  nnoremap <Leader>of :call SmartFileOpen(input("Open file: ", "", "file"), 1)<CR>

  if g:lsp_enabled
    let g:asyncomplete_auto_popup = 1
  else
    let g:asyncomplete_auto_popup = 0
  endif
endfunction

" Map <Leader>z to toggle Clean Mode (easy to remember: z for zen/minimal)
nnoremap <Leader>z :call ToggleCleanMode()<CR>

" Load Clean Mode preference on Vim startup
autocmd VimEnter * call LoadCleanModePreference()

" NERDCommenter settings
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlign = 'left'
let g:NERDCommentEmptyLines = 1

" " Minimap function
" function! MinimapSmartToggle()
"   let min_width = 100

"   if &columns < min_width
"     if exists(':MinimapClose')
"       execute 'MinimapClose'
"     endif
"     echo "Minimap hidden: window too narrow"
"     return
"   endif

"   " Toggle minimap if available
"   if exists(':MinimapToggle')
"     execute 'MinimapToggle'
"     " Refresh only if minimap is now active
"     execute 'MinimapRefresh'
"     call LoadCleanModePreference()
"   endif
" endfunction

" Minimap integration - Fixed minimap toggle
function! MinimapSmartToggle()
  let min_width = 100
  if &columns < min_width
    if exists(':MinimapClose')
      execute 'MinimapClose'
    endif
    echo "Minimap hidden: window too narrow"
    return
  endif
  
  " Store current window before toggling minimap
  let current_win = winnr()
  let main_win = FindMainEditorWindow()
  
  " Toggle minimap if available
  if exists(':MinimapToggle')
    execute 'MinimapToggle'
    execute 'MinimapRefresh'
    " if exists('*LoadCleanModePreference')
    call LoadCleanModePreference()
    " endif
    
    " Return to main editor window after minimap operations
    if main_win > 0
      execute main_win . 'wincmd w'
    endif
    
  endif
endfunction

function! UnloadLightline()
  " Turn OFF lightline
  let g:loaded_lightline = 0
  set statusline=%f\ %y\ %m\ %r\ %=Ln:%l\ Col:%c
  set laststatus=2
  highlight clear StatusLine
  highlight clear StatusLineNC
  highlight StatusLine   ctermfg=white ctermbg=black guifg=white guibg=black
  highlight StatusLineNC ctermfg=grey  ctermbg=black guifg=grey  guibg=black
  
endfunction

function! LoadLightline()
  " Turn ON lightline
  let g:loaded_lightline = 1
  " Clear custom statusline so lightline can take over
  set statusline=2
  runtime plugin/lightline.vim
  call lightline#init()
  let g:lightline = {
    \ 'colorscheme': 'wombat',
    \ }
    call lightline#colorscheme()
    call lightline#update()
endfunction


  " ============================
"     LSP CONFIGURATION
" ============================

" Completely disable LSP by default
let g:lsp_auto_enable = 0
let g:lsp_diagnostics_enabled = 0
let g:lsp_document_highlight_enabled = 0
let g:lsp_signs_enabled = 0
let g:lsp_signature_help_enabled = 0
let g:lsp_completion_enabled = 0

" Clean LSP styling - red text for errors, yellow for warnings
let g:lsp_diagnostics_highlights_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 1
let g:lsp_diagnostics_virtual_text_prefix = " ● "
let g:lsp_diagnostics_virtual_text_align = "after"

" Clean styling for LSP diagnostics - errors in red, warnings in yellow
highlight LspDiagnosticsDefaultError ctermfg=red guifg=#ff5555
highlight LspDiagnosticsDefaultWarning ctermfg=yellow guifg=#ffb86c
highlight LspDiagnosticsDefaultInformation ctermfg=cyan guifg=#8be9fd
highlight LspDiagnosticsDefaultHint ctermfg=green guifg=#50fa7b

" Ensure virtual text uses the same colors
highlight LspDiagnosticsVirtualTextError ctermfg=red guifg=#ff5555
highlight LspDiagnosticsVirtualTextWarning ctermfg=yellow guifg=#ffb86c
highlight LspDiagnosticsVirtualTextInformation ctermfg=cyan guifg=#8be9fd
highlight LspDiagnosticsVirtualTextHint ctermfg=green guifg=#50fa7b

" Remove ugly underlines and backgrounds
highlight LspDiagnosticsUnderlineError cterm=NONE gui=NONE
highlight LspDiagnosticsUnderlineWarning cterm=NONE gui=NONE
highlight LspDiagnosticsUnderlineInformation cterm=NONE gui=NONE
highlight LspDiagnosticsUnderlineHint cterm=NONE gui=NONE

" ===========================
"     ENHANCED COMPLETION SETUP
" ============================
" Better completion settings
set completeopt=menu,menuone,noselect,preview
set pumheight=10
set shortmess+=c

" Configure asyncomplete (but start disabled)
let g:asyncomplete_auto_popup = 0
let g:asyncomplete_popup_delay = 200
let g:asyncomplete_min_chars = 1

" Register completion sources
function! SetupAsyncomplete()
  " Buffer completion
  call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'allowlist': ['*'],
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {'max_buffer_size': 5000000},
      \ }))

  " File path completion
  call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'allowlist': ['*'],
      \ 'priority': 10,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))
endfunction

autocmd VimEnter * call SetupAsyncomplete()

" ============================
"     ENHANCED LSP FUNCTIONS
" ============================
function! RegisterLSPServers()
  " Python LSP Server with enhanced completion
  if executable('pylsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ 'config': {
        \   'pylsp': {
        \     'plugins': {
        \       'jedi_completion': {'enabled': v:true, 'include_params': v:true},
        \       'jedi_hover': {'enabled': v:true},
        \       'jedi_references': {'enabled': v:true},
        \       'jedi_signature_help': {'enabled': v:true},
        \       'pycodestyle': {'enabled': v:true, 'maxLineLength': 100},
        \       'pyflakes': {'enabled': v:true}
        \     }
        \   }
        \ }
        \ })
  endif
  
  " Clangd for C/C++ with better completion
  if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd', '--background-index', '--completion-style=detailed']},
        \ 'allowlist': ['c', 'cpp'],
        \ })
  endif
  
  " TypeScript Language Server with enhanced features
  if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->['typescript-language-server', '--stdio']},
        \ 'allowlist': ['typescript', 'javascript', 'javascriptreact', 'typescriptreact'],
        \ })
  endif
endfunction

" Disable LSP on startup completely
autocmd VimEnter * let g:lsp_auto_enable = 0

" LSP keybindings (only work when LSP is enabled)
function! SetupLSPKeybindings()
  nnoremap <buffer><silent> gd <Plug>(lsp-definition)
  nnoremap <buffer><silent> gr <Plug>(lsp-references)
  nnoremap <buffer><silent> K  <Plug>(lsp-hover)
  nnoremap <buffer><silent> <leader>rn <Plug>(lsp-rename)
  nnoremap <buffer><silent> <leader>f  <Plug>(lsp-document-format)
  nnoremap <buffer><silent> <leader>e  <Plug>(lsp-document-diagnostics)
  nnoremap <buffer><silent> <leader>ca <Plug>(lsp-code-action)
  
  " Enhanced completion bindings (only active when LSP is on)
  inoremap <buffer><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <buffer><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <buffer><expr> <CR>    pumvisible() ? asyncomplete#close_popup() . "\<CR>" : "\<CR>"
  inoremap <buffer><expr> <C-Space> asyncomplete#force_refresh()
  
  " Enable completion
  setlocal omnifunc=lsp#complete
  setlocal completefunc=lsp#complete
endfunction

function! RemoveLSPKeybindings()
  silent! nunmap <buffer> gd
  silent! nunmap <buffer> gr
  silent! nunmap <buffer> K
  silent! nunmap <buffer> <leader>rn
  silent! nunmap <buffer> <leader>f
  silent! nunmap <buffer> <leader>e
  silent! nunmap <buffer> <leader>ca
  
  " Remove enhanced completion bindings
  silent! iunmap <buffer> <Tab>
  silent! iunmap <buffer> <S-Tab>
  silent! iunmap <buffer> <CR>
  silent! iunmap <buffer> <C-Space>
  
  " Disable completion
  setlocal omnifunc=
  setlocal completefunc=
endfunction

" ============================
"     LSP TOGGLE SETUP
" ============================

let g:lsp_enabled = 0

function! ToggleLSP()
  if g:lsp_enabled
    " Disable LSP
    let g:lsp_enabled = 0
    let g:lsp_auto_enable = 0
    let g:lsp_diagnostics_enabled = 0
    let g:lsp_document_highlight_enabled = 0
    let g:lsp_signs_enabled = 0
    let g:lsp_signature_help_enabled = 0
    let g:lsp_completion_enabled = 0
    let g:lsp_diagnostics_virtual_text_enabled = 0
    
    let g:asyncomplete_auto_popup = 0
    let g:asyncomplete_enabled = 0
    set completeopt=
    set complete=
    
    " Stop all LSP servers
    for server_name in lsp#get_server_names()
      call lsp#stop_server(server_name)
    endfor
    
    " Remove keybindings from current buffer
    call RemoveLSPKeybindings()
    
    " Clear signs and diagnostics
    sign unplace *
    
    echo "LSP OFF"
  else
    " Enable LSP
    let g:lsp_enabled = 1
    let g:lsp_auto_enable = 1
    let g:lsp_diagnostics_enabled = 1
    let g:lsp_document_highlight_enabled = 0
    let g:lsp_signs_enabled = 0
    let g:lsp_signature_help_enabled = 1
    let g:lsp_completion_enabled = 1
    let g:lsp_diagnostics_virtual_text_enabled = 1
    set completeopt=menu,menuone,noselect,preview
    set complete=.,w,b,u,t,i    
    
    " Register LSP servers
    call RegisterLSPServers()
    
    " Enable LSP for current buffer
    call lsp#enable()
    
    " Setup keybindings for current buffer
    call SetupLSPKeybindings()
    let g:asyncomplete_auto_popup = 1
    let g:asyncomplete_enabled = 1
    echo "LSP ON - Clean red/yellow text diagnostics enabled"
  endif
endfunction

" Manual LSP server installation commands
" Install these manually on your system:
" Python: pip3 install 'python-lsp-server[all]'
" C/C++: brew install llvm (for clangd) or apt install clangd
" TypeScript: npm install -g typescript typescript-language-server
" Bash: npm install -g bash-language-server
" HTML: npm install -g vscode-langservers-extracted
" CSS: npm install -g vscode-langservers-extracted

  
  " function! ToggleLightline()
  "   if exists('g:loaded_lightline') && g:loaded_lightline == 1
  "     " Turn OFF lightline
  "     let g:loaded_lightline = 0
  "     set statusline=%f\ %y\ %m\ %r\ %=Ln:%l\ Col:%c
  "     set laststatus=2
  "     highlight clear StatusLine
  "     highlight clear StatusLineNC
  "     highlight StatusLine   ctermfg=white ctermbg=black guifg=white guibg=black
  "     highlight StatusLineNC ctermfg=grey  ctermbg=black guifg=grey  guibg=black
  
  "     echom "Default statusline enabled"
  "   else
  "     " Turn ON lightline
  "     let g:loaded_lightline = 1
  "     " Clear custom statusline so lightline can take over
  "     set statusline=2
  "     runtime plugin/lightline.vim
  "     call lightline#init()
  "     let g:lightline = {
  "       \ 'colorscheme': 'wombat',
  "       \ }
  "     call lightline#colorscheme()
  "     call lightline#update()
  "     echom "Lightline enabled"
  "   endif
  " endfunction
  
  " command! ToggleLightline call ToggleLightline()









" ============================
"     VSCODE-LIKE WORKSPACE
" ============================

" Workspace state variables
let g:workspace_initialized = 0
let g:workspace_root = ''
let g:terminal_tabs = {}
let g:current_terminal_tab = 1
let g:max_terminal_tabs = 5

" Initialize workspace (like opening a folder in VSCode)
function! InitializeWorkspace(path)
  let g:workspace_root = fnamemodify(a:path, ':p')
  let g:workspace_initialized = 1
  
  " Set working directory
  execute 'cd ' . fnameescape(g:workspace_root)
  
  " Setup the layout
  call SetupWorkspaceLayout()
  
  echo "Workspace initialized: " . g:workspace_root
endfunction

" Setup VSCode-like layout
function! SetupWorkspaceLayout()
  " Clear current layout
  only
  
  " Open NERDTree on the left (sidebar)
  NERDTree
  vertical resize 30
  
  " Move to main window
  wincmd l
  
  " Open a welcome buffer or the current file
  if argc() > 0
    edit
  else
    enew
  endif
  
  " Initialize terminal at bottom
  call OpenTerminalTab(1)
  
  " Return focus to main editor
  wincmd k
endfunction

" Terminal tab management
function! OpenTerminalTab(tab_number)
  let g:current_terminal_tab = a:tab_number
  
  " Go to bottom and create/switch terminal
  wincmd j
  
  if !exists('g:terminal_tabs[a:tab_number]') || !bufexists(g:terminal_tabs[a:tab_number]['buffer'])
    " Create new terminal tab
    execute 'belowright 12split'
    execute 'terminal'
    let g:terminal_tabs[a:tab_number] = {
      \ 'buffer': bufnr('%'),
      \ 'name': 'Terminal ' . a:tab_number,
      \ 'cwd': getcwd()
      \ }
  else
    " Switch to existing terminal tab
    let term_buf = g:terminal_tabs[a:tab_number]['buffer']
    execute 'belowright 12split'
    execute 'buffer ' . term_buf
  endif
  
  call UpdateTerminalStatusLine()
endfunction

function! OpenTerminalInDirectory(path)
  let old_cwd = getcwd()
  execute 'cd ' . fnameescape(a:path)
  call OpenTerminalTab(g:current_terminal_tab)
  execute 'cd ' . fnameescape(old_cwd)
endfunction

function! NextTerminalTab()
  let next_tab = g:current_terminal_tab + 1
  if next_tab > g:max_terminal_tabs
    let next_tab = 1
  endif
  call OpenTerminalTab(next_tab)
endfunction

function! PrevTerminalTab()
  let prev_tab = g:current_terminal_tab - 1
  if prev_tab < 1
    let prev_tab = g:max_terminal_tabs
  endif
  call OpenTerminalTab(prev_tab)
endfunction

function! CreateNewTerminalTab()
  let new_tab = 1
  while new_tab <= g:max_terminal_tabs && exists('g:terminal_tabs[new_tab]')
    let new_tab += 1
  endwhile
  
  if new_tab <= g:max_terminal_tabs
    call OpenTerminalTab(new_tab)
  else
    echo "Maximum terminal tabs reached (" . g:max_terminal_tabs . ")"
  endif
endfunction

function! CloseTerminalTab(tab_number)
  if exists('g:terminal_tabs[a:tab_number]')
    let term_buf = g:terminal_tabs[a:tab_number]['buffer']
    if bufexists(term_buf)
      execute 'bdelete! ' . term_buf
    endif
    unlet g:terminal_tabs[a:tab_number]
    
    " Switch to tab 1 if current tab was closed
    if g:current_terminal_tab == a:tab_number
      call OpenTerminalTab(1)
    endif
  endif
endfunction

function! UpdateTerminalStatusLine()
  if exists('g:terminal_tabs[g:current_terminal_tab]')
    let tab_info = "Terminal " . g:current_terminal_tab . "/" . g:max_terminal_tabs
    let cwd_info = " | " . fnamemodify(getcwd(), ':~')
    echo tab_info . cwd_info
  endif
endfunction

" Smart file opening (like VSCode behavior) - Fixed for minimap compatibility
function! SmartFileOpen(filename, ...)
  let force_tab = a:0 > 0 ? a:1 : 0
  let full_path = fnamemodify(a:filename, ':p')
  
  " If workspace is initialized and file is outside workspace, ask user
  if g:workspace_initialized && !force_tab
    let workspace_path = g:workspace_root
    if stridx(full_path, workspace_path) != 0
      let choice = confirm("File is outside workspace. Open anyway?", "&Yes\n&No", 2)
      if choice != 1
        return
      endif
    endif
  endif
  
  " Find the main editor window (not NERDTree, not terminal, not minimap)
  let main_win = FindMainEditorWindow()
  if main_win > 0
    execute main_win . 'wincmd w'
  endif
  
  " Open file in new tab if workspace is active or forced
  if g:workspace_initialized || force_tab
    execute 'tabedit ' . fnameescape(full_path)
  else
    execute 'edit ' . fnameescape(full_path)
  endif
endfunction

" Find the main editor window (avoiding NERDTree, terminal, minimap)
function! FindMainEditorWindow()
  let current_win = winnr()
  let main_win = 0
  
  " Try each window
  for win_num in range(1, winnr('$'))
    execute win_num . 'wincmd w'
    
    " Skip NERDTree
    if &filetype == 'nerdtree'
      continue
    endif
    
    " Skip terminal
    if &buftype == 'terminal'
      continue
    endif
    
    " Skip minimap (if it has specific filetype or name pattern)
    if &filetype == 'minimap' || bufname('%') =~ '__Minimap__'
      continue
    endif
    
    " This looks like a main editor window
    let main_win = win_num
    break
  endfor
  
  " Return to original window if no main window found
  if main_win == 0
    execute current_win . 'wincmd w'
    let main_win = current_win
  endif
  
  return main_win
endfunction

" Project management functions
function! OpenProjectFolder()
  let folder = input("Select project folder: ", getcwd(), "dir")
  if !empty(folder) && isdirectory(folder)
    call InitializeWorkspace(folder)
  endif
endfunction

function! SaveWorkspaceSession()
  if !g:workspace_initialized
    echo "No workspace active"
    return
  endif
  
  let session_file = g:workspace_root . '/.vim_session'
  execute 'mksession! ' . fnameescape(session_file)
  echo "Workspace session saved to " . session_file
endfunction

function! LoadWorkspaceSession()
  let session_file = input("Session file: ", getcwd() . "/.vim_session", "file")
  if filereadable(session_file)
    execute 'source ' . fnameescape(session_file)
    let g:workspace_root = fnamemodify(session_file, ':h')
    let g:workspace_initialized = 1
    echo "Workspace session loaded"
  else
    echo "Session file not found"
  endif
endfunction

" Custom vim command that opens files in new tabs when in workspace
function! WorkspaceVimCommand(pattern)
  let files = split(glob(a:pattern), '\n')
  if empty(files)
    echo "No files found matching: " . a:pattern
    return
  endif
  
  for file in files
    call SmartFileOpen(file, 1)  " Force tab opening
  endfor
  
  echo "Opened " . len(files) . " file(s) in new tabs"
endfunction




" Auto-commands for workspace behavior
autocmd BufRead,BufNewFile * if !g:workspace_initialized && argc() > 0 | call InitializeWorkspace(expand('%:p:h')) | endif

" Enhanced terminal behavior - Custom vim command in terminal
autocmd TerminalOpen * call UpdateTerminalStatusLine()

" Override vim command to work with workspace tabs
command! -nargs=+ -complete=file Vim call WorkspaceVimCommand(<q-args>)

" Command-line commands for easy access
command! -nargs=1 -complete=dir OpenWorkspace call InitializeWorkspace(<q-args>)
command! SaveSession call SaveWorkspaceSession()
command! LoadSession call LoadWorkspaceSession()
command! WorkspaceLayout call SetupWorkspaceLayout()

" Integration with existing vim command
autocmd VimEnter * if argc() > 0 | call SmartFileOpen(argv(0)) | endif