"Don't put spaces around the commas, a space between the arguments is needed
"even with \ , the | operator is needed to chain commands. It is possible to
"do it without the set but it looks better this way.
augroup code_style
	"clear the group's autocommands to avoid duplication if .vimrc is source more than once
	autocmd!
	au BufNewFile,BufRead *.py,*.c,*.h,*.cpp
		\ setlocal textwidth=199|
		\ setlocal expandtab|
		\ setlocal autoindent
	   " \ setlocal fileformat=unix
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
set hidden
set clipboard=unnamedplus
set ruler
set background=dark

"Clear highlighting in normal mode, and clear the command from the log"
nnoremap <space> : noh<CR><esc>:<backspace>
map <F4> : NERDTreeToggle<CR>
nmap <silent> <F8> :TlistToggle<CR>
tmap <F6> <C-\><C-n>
"split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"Ale shortcuts, <C-N> isn't used since i am using the tab completion plugin.
nnoremap <C-N> :ALEGoToDefinition<CR>
nnoremap <C-M> :ALEHover<CR>
nnoremap <C-B> :ALEFindReferences<CR>

"<silent> won't display the command to the command log, @/ is the search
"register which we want to preserve because the s/... will change it. The nohl
"directive will turn off highliting for the current search (i removed it)
"unlet will free the temporary variable we used.
nnoremap <silent> <F5> :let _s=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_s <Bar> :nohl <Bar> :unlet _s <CR>

"Prevent clipboard from being cleared on vim's exit
"This command calls the external commands through system and basically
"does echo <regs contents> | xclip -selection clipboard
augroup copy_pase
	autocmd!
	autocmd VimLeave * call system('echo ' . shellescape(getreg('+')) .
			\ ' | xclip -selection clipboard')
augroup END
" These options might not be better than the default
if &diff
	set cursorline
	hi DiffAdd    ctermfg=233 ctermbg=LightGreen guifg=#003300 guibg=#DDFFDD gui=none cterm=none
	hi DiffChange ctermbg=white  guibg=#ececec gui=none   cterm=none
	hi DiffText   ctermfg=233  ctermbg=yellow  guifg=#000033 guibg=#DDDDFF gui=none cterm=none
endif
" Ale configuration. be careful to not have code in the ftp plugin folder
" because it can override some configuration done here
let g:ale_linters = {'python': ['flake8', 'pyls']}
let g:ale_linters['c'] = ['cppcheck', 'flawfinder', 'gcc']
let g:ale_linters['vim'] = ['vint']
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_completion_enabled = 1
let g:ale_completion_delay = 50

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
