"Don't put spaces around the commas. However a space between the arguments is NEEDED
"\<Space> is required. The | operator is needed to chain commands.
"It is possible to do it without the multiple set but it looks better this way.
augroup code_style
    "clear the group's autocommands to avoid duplication if .vimrc is sourced more than once
    autocmd!

    au FileType c,python
        \ setlocal textwidth=120|
        \ setlocal autoindent
       " \ setlocal fileformat=unix

    au FileType make
      \ setlocal noexpandtab
augroup END

syntax on
set fileencoding=utf8
set encoding=utf8
set tabstop=4
set number
set nowrap
set backspace=indent,eol,start
set foldmethod=indent
set shiftwidth=4
set cmdheight=2
set nostartofline "don't go to the start of line when switching buffers
set hlsearch
set wildmenu
" Get confirmation for 1 or 2 lines yanked/deleted (default is 2)
set report=0
" Under default settings, making changes and then opening a new file will display:
" E37: No write since last change (add ! to override)
" set hidden will change this behaviour.
set hidden
" Portray a tab as a ° followed by the required number of ° (a different character could have been used)
" until the next tabstop.
set list listchars=tab:°°
" Default value of tab policy is to use space only
set expandtab
" The alternative is to copy the fzf.vim file inside /.fzf/plugin to .vim/plugin
" However this approach allows the versioning of the file to stay independent.
" The following line implies fzf is cloned to ~/.fzf
set rtp+=~/.fzf

" Showd number of lines selected in visual mode, or size of block
set showcmd
set background=dark

if has('unnamedplus')
    set clipboard=unnamedplus
else
    set clipboard=unnamed
endif


"Clear highlighting in normal mode, and clear the command from the log"
nnoremap <space> :noh<CR>:<backspace>
nnoremap <F4> :NERDTreeToggle<CR>
nnoremap <F3> :ALEToggle<CR>
nmap <silent> <F8> :TlistToggle<CR>
tmap <F6> <C-\><C-n>
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"Ale shortcuts, <C-N> isn't used since i am using the tab completion plugin.

" nmap must be used with the named plugs like <Plug>(ale_hover)
" nnoremap doesn't work because since it will not remap <Plug>(ale_hover) to the actual command.
nnoremap <C-N> :ALEGoToDefinition<CR>
" <C-M> is for vim the same as <CR> so i should avoid using it.
" verbose  nmap <CR> can check where the <CR> was remapped for normal mode.
nnoremap K :ALEHover<CR>
nnoremap <C-B> :ALEFindReferences<CR>

"<silent> won't display the command to the command log, @/ is the search
"register which we want to preserve because the s/... will change it. The nohl
"directive will turn off highliting for the current search (i removed it)
"unlet will free the temporary variable we used.
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>
"Check for lines with a length longer than 120 and highlight them.
nnoremap <silent> <F10> /\%>120v.\+<CR>

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"Prevent clipboard from being cleared on vim's exit
"This command calls the external commands through system and basically
"does echo <regs contents> | xclip -selection clipboard
augroup copy_pase
    autocmd!
    autocmd VimLeave * call system('echo ' . shellescape(getreg('+')) .
            \ ' | xclip -selection clipboard')
augroup END

" Ale configuration. be careful to not have code in the ftp plugin folder
" because it can override some configuration done here
let g:ale_linters = {'python': ['flake8', 'pyls']}
let g:ale_linters['c'] = ['cppcheck', 'flawfinder', 'gcc','clang','cquery']
let g:ale_linters['vim'] = ['vint']
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_completion_enabled = 0
let g:ale_completion_delay = 50
let g:ale_enabled = 0

"Show trailing whitespaces
augroup trailing_whitespace
    autocmd!
    highlight ExtraWhitespace ctermbg=red guibg=red
    match ExtraWhitespace /\s\+$/
    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    autocmd BufWinLeave * call clearmatches()
augroup END

function! UpdatePyPaths()
    let package_paths = split(globpath('.','*env/**/site-packages'))
    for path in package_paths
        let  $PYTHONPATH .= ':'.fnamemodify(path, ':p')
    endfor

    "$PYTHONPATH can only be a string so another variable needs to be used to carry list operations
    let py_paths = split($PYTHONPATH, ':')
    let py_paths = join(uniq(sort(py_paths)), ':')
    let $PYTHONPATH = py_paths
endfunction

if argc() == 0 && !exists("mpy_path_loaded")
    let mpy_path_loaded = 1
    call UpdatePyPaths()
endif

"This works for Bash on Windows
let s:clip = '/mnt/c/Windows/System32/clip.exe'  " default location
if executable(s:clip)
    augroup WSLYank
        autocmd!
        autocmd TextYankPost * call system('echo '.shellescape(join(v:event.regcontents, "\<CR>")).' | '.s:clip)
    augroup END
end

"MACROS"
"Single quotations do not allow escaping so " need to be used to properly use \<esc>
let @t="$50i \<esc>d50|"
