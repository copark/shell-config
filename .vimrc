" Tested with Vim-7.2 (tiny, small, large, big, huge) and Vim-6.4
" 
" Plugins used:
" - CSApprox or guicolorscheme (to get proper colors in terminal).
" - taglist (to print function name in statusline)
"
" Unlet g:color_names to avoid loading color scheme several times
" when sourcing ~/.virmc a second time. Several commands would trigger
" sourcing color scheme :syntax on and :set t_Co=256 and of course
" command :colorscheme itself.
if has('eval')
  sil! unlet g:colors_name
endif

if has('multi_byte')
  scriptencoding utf-8
  set encoding=utf-8
  set fileencoding=utf-8
  set fileencodings=utf-8,cp949,unicode,ucs-bom,latin1
  set termencoding=utf-8
"  if version >= 700
"    set lcs=tab:»·,trail:·,eol:¶,extends:>,precedes:<,nbsp:×
"  else
"    set lcs=tab:»·,trail:·,eol:¶,extends:>,precedes:<
"  endif
endif

if has('syntax')
  syntax on
endif
if has('autocmd')
  filetype on
  filetype plugin on
  filetype indent on
endif

if has('gui_running')
  if has("win16") || has("win32") || has("win95") || has("win64")
    set guifont=Lucida\ Console:h10
  else
    set guifont=Monospace\ 9
  endif
  if has('toolbar')
    if     has('gui_gtk2')  || has('gui_gtk')
      \ || has('gui_motif') || has('gui_athena') || has('gui_photon')
      set tb=icons
      if has('gui_gtk2') | set tbis=tiny | endif
    endif
  endif
else
  if has('eval') | let Tlist_Inc_Winwidth=0 | endif
endif

" I don't want to use synch too often on a laptop.
if version >= 700 | set nofsync | endif

" Don't wait 1s when pressing <esc>
set timeout timeoutlen=3000 ttimeoutlen=100

set nocompatible
set history=400
set textwidth=0
""set backupdir=$HOME/.vim/backup
set nobackup
""set noswapfile
set noerrorbells

" I don't like 'set mouse=a' behavior because it changes the position of
" the cursor when clicking in a window to give it focus.  I prefer 
" 'set mouse=vic'.
if has('mouse') | set mouse=vic | endif

set wildmode=longest,list
""set wildmode=longest:full,full
set wildmenu

set splitbelow
set hidden
"set nostartofline
set startofline
set cpoptions=ces$
set backspace=indent,eol,start
""set whichwrap+=h,l,<,>,[,]
set whichwrap+=<,>,[,]
set wrap
set wildchar=<Tab>
set showbreak=:
set laststatus=2
set shiftwidth=2
set shiftround
set softtabstop=2
set tabstop=2
set autoindent
set cindent
"set cino:0
set cinoptions=:0,g0,(0,l1,t0
set smartindent
set noexpandtab
set ignorecase
set smartcase
set scrolloff=5
set sidescrolloff=5
set title
set ttyfast
set comments=sr:/*,mb:*,ex:*/
set formatoptions=tcqor
" set showfulltag
if has('netbeans_intg') || has('sun_workshop')
  set autochdir
endif

set visualbell
if has('cmdline_info')
  set ruler
  set showcmd
endif
"set nonumber
set nu
set showmatch
set showmode
if has('extra_search')
  set hlsearch
  set incsearch
endif
set nolist
set magic
set matchpairs+=<:>
set virtualedit=block
set display=lastline,uhex

"set mouse=a " 마우스 스크롤 사용

"set nowrap     " auto line change
set scs    " 똑똑한 대소문자 구별
set ic      " 검색시 대소문자 구별 안함.    ignorecase
"set nows    " 검색시 파일 끝에서 처음으로 되돌리기 안함.
set expandtab          " tab을 1칸 단위로 다 점유한다.

"set paste   " 들여쓰기에 의한 자동 칸띄우기 금지

" set thesaurus=~/mthesaur.txt
if has('cscope')
  set csprg=/usr/bin/cscope
  set csto=1
  set cst
  set nocsverb

"  if filereadable(expand("$HOME/cscope.out"))
"    cs kill -1
"    cs add ~/cscope.out
"  endif

	function SetTags(prjroot)
		let cwd=getcwd()
		let idx = match(cwd, a:prjroot)
		let tag_path=$TAG_PATH.'/'

		if isdirectory(tag_path.a:prjroot)
			if idx != -1
				let prjpath = strpart(cwd, 0, idx).a:prjroot
				let &tags=tag_path.a:prjroot.'/tags'
				if filereadable(tag_path.a:prjroot.'/cscope.out')
					exec "cs add" tag_path.a:prjroot.'/cscope.out'
				endif
				return 1
			endif
		endif
		return -1
	endfunction

	if filereadable("./cscope.out") || filereadable("./tags")
		if filereadable("./cscope.out")
			cs add cscope.out
		endif
		if filereadable("./tags")
			let &tags='./tags'
		endif
	else
		let cwd=getcwd()
		let prjList = ['kernel', 'android', 'AMSS']
		for prj in prjList
			let res = SetTags(prj)
			if res != -1
				break
			endif
		endfor
	endif

  set cscopeverbose
  " Put output of cscope in quickfix window (use :copen)
  set cscopequickfix=s-,c-,d-,i-,t-,e-,g-


  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " CSCOPE settings for vim           
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  "
  " This file contains some boilerplate settings for vim's cscope interface,
  " plus some keyboard mappings that I've found useful.
  "
  " USAGE: 
  " -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
  "               'plugin' directory in some other directory that is in your
  "               'runtimepath'.
  "
  " -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
  "               your ~/.vimrc file (or cut and paste it into your .vimrc).
  "
  " NOTE: 
  " These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
  " keeps timing you out before you can complete them, try changing your timeout
  " settings, as explained below.
  "
  " Happy cscoping,
  "
  " Jason Duell       jduell@alumni.princeton.edu     2002/3/7
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


  """    """"""""""""" Standard cscope/vim boilerplate
  """
  """    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
  """    set cscopetag
  """
  """    " check cscope for definition of a symbol before checking ctags: set to 1
  """    " if you want the reverse search order.
  """    set csto=0
  """
  """    " add any cscope database in current directory
  """    if filereadable("cscope.out")
  """        cs add cscope.out  
  """    " else add the database pointed to by environment variable 
  """    elseif $CSCOPE_DB != ""
  """        cs add $CSCOPE_DB
  """    endif
  """
  """    " show msg when any other cscope db added
  """    set cscopeverbose  


      """"""""""""" My cscope/vim key mappings
      "
      " The following maps all invoke one of the following cscope search types:
      "
      "   's'   symbol: find all references to the token under cursor
      "   'g'   global: find global definition(s) of the token under cursor
      "   'c'   calls:  find all calls to the function name under cursor
      "   't'   text:   find all instances of the text under cursor
      "   'e'   egrep:  egrep search for the word under cursor
      "   'f'   file:   open the filename under cursor
      "   'i'   includes: find files that include the filename under cursor
      "   'd'   called: find functions that function under cursor calls
      "
      " Below are three sets of the maps: one set that just jumps to your
      " search result, one that splits the existing vim window horizontally and
      " diplays your search result in the new window, and one that does the same
      " thing, but does a vertical split instead (vim 6 only).
      "
      " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
      " unlikely that you need their default mappings (CTRL-\'s default use is
      " as part of CTRL-\ CTRL-N typemap, which basically just does the same
      " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
      " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
      " of these maps to use other keys.  One likely candidate is 'CTRL-_'
      " (which also maps to CTRL-/, which is easier to type).  By default it is
      " used to switch between Hebrew and English keyboard mode.
      "
      " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
      " that searches over '#include <time.h>" return only references to
      " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
      " files that contain 'time.h' as part of their name).


      " To do the first type of search, hit 'CTRL-\', followed by one of the
      " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
      " search will be displayed in the current window.  You can use CTRL-T to
      " go back to where you were before the search.  
      "

      nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
      nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
      nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


      " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
      " makes the vim window split horizontally, with search result displayed in
      " the new window.
      "
      " (Note: earlier versions of vim may not have the :scs command, but it
      " can be simulated roughly via:
      "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

      nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
      nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
      nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
      nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


      " Hitting CTRL-space *twice* before the search type does a vertical 
      " split instead of a horizontal one (vim 6 and up only)
      "
      " (Note: you may wish to put a 'set splitright' in your .vimrc
      " if you prefer the new window on the right instead of the left

      nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
      nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
      nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
      nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
      nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
      nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
      nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
      nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


      """"""""""""" key map timeouts
      "
      " By default Vim will only wait 1 second for each keystroke in a mapping.
      " You may find that too short with the above typemaps.  If so, you should
      " either turn off mapping timeouts via 'notimeout'.
      "
      "set notimeout 
      "
      " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
      " with your own personal favorite value (in milliseconds):
      "
      "set timeoutlen=4000
      "
      " Either way, since mapping timeout settings by default also set the
      " timeouts for multicharacter 'keys codes' (like <F1>), you should also
      " set ttimeout and ttimeoutlen: otherwise, you will experience strange
      " delays as vim waits for a keystroke after you hit ESC (it will be
      " waiting to see if the ESC is actually part of a key code like <F1>).
      "
      "set ttimeout 
      "
      " personally, I find a tenth of a second to work well for key code
      " timeouts. If you experience problems and have a slow terminal or network
      " connection, set it higher.  If you don't set ttimeoutlen, the value for
      " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
      "
      "set ttimeoutlen=100


endif

set makeprg=make\ VERBOSE=\ DEBUG=yes

if has('eval')
  let g:load_doxygen_syntax=1
  let g:is_posix=1
  let g:c_gnu=1
  let g:netrw_special_syntax=1
  let g:netrw_liststyle=3
  let g:netrw_browse_split=4

  " Required to see the current function name in the status bar.
  let Tlist_Process_File_Always = 1

  " Configure HTML output with :TOhtml
  " let html_number_lines=1
  let html_use_css=1
  let html_use_xhtml=1
  let html_dynamic_folds = 1
endif

" This mapping allows to stay in visual mode when indenting with < and >
vnoremap > >gv
vnoremap < <gv

noremap <c-]> g<c-]>
noremap <c-g> g<c-g>

" These mappings are useful in long wrapped lines when pressing <down> or <up>
" Use j or k to get the default behavior.
noremap <down> g<down>
noremap <up>   g<up>

 map <F2>      :set paste!<CR>:set paste?<CR>
imap <F2> <C-O>:set paste<CR>:set paste?<CR>
 map <F3>      :set number!<CR>:set number?<CR>
imap <F3> <C-O>:set number!<CR><C-O>:set number?<CR>
" map <F4>      :set hlsearch!<CR>:set hlsearch?<CR>
"imap <F4> <C-O>:set hlsearch!<CR><C-O>:set hlsearch?<CR>
" map <F5>      :set list!<CR>:set list?<CR>
"imap <F5> <C-O>:set list!<CR><C-O>:set list?<CR>
"nnoremap <silent> <F6> :TlistToggle<CR>

"  For Korea Input Method
inoremap <ESC> <ESC>:set imdisable<CR>
nnoremap i :set noimd<CR>i
nnoremap I :set noimd<CR>I
nnoremap a :set noimd<CR>a
nnoremap A :set noimd<CR>A
nnoremap o :set noimd<CR>o
nnoremap O :set noimd<CR>O

if 0
if has('spell')
  set spell

  if has('eval')
    " Change language of spelling checker.
    let g:myLang = 0
    let g:myLangList = [ "en_us", "eo", "fr", "it", "br" ]
    let g:lingvoj= [ "language:", "lingvo:", "langue :", "lingua:", "yezh:" ]
    function! MySpellLang()
      let g:myLang = g:myLang + 1
      if g:myLang >= len(g:myLangList) | let g:myLang = 0 | endif

      if g:myLang == 0 | setlocal spell spelllang=en_us | endif
      if g:myLang == 1 | setlocal spell spelllang=eo    | endif
      if g:myLang == 2 | setlocal spell spelllang=fr    | endif
      if g:myLang == 3 | setlocal spell spelllang=it    | endif
      if g:myLang == 4 | setlocal spell spelllang=br    | endif

      echo g:lingvoj[g:myLang] g:myLangList[g:myLang]
    endf

    map  <F7>      :call MySpellLang()<CR>
    imap <F7> <C-o>:call MySpellLang()<CR>
  endif
  map  <F8> :set spell!<CR>
endif
endif

" Tip #750: http://vim.wikia.com/wiki/VimTip750
" Underline the current line.
" nnoremap <F9> yyp<c-v>$r-
" inoremap <F9> <esc>yyp<c-v>$r-A

" Tip #99: display syntax group under the cursor.
"map  <F10> :echo "hi<"
"\ . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
"\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
"\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name")
"\ . ">"<CR>


" Following mappings allow to cut undo to reduce granularity of
" undos. See also:
"   http://vim.wikia.com/wiki/Modified_undo_behavior
inoremap <c-u>   <c-g>u<c-u>
inoremap <c-w>   <c-g>u<c-w>
inoremap <bs>    <c-g>u<bs>
inoremap <del>   <c-g>u<del>
inoremap <tab>   <tab><c-g>u
"imap     <space> <space><c-g>u

let maplocalleader=','

" tabs
" (LocalLeader is ",")
" create a new tab
map <LocalLeader>to :tabnew %<cr>
" close a tab
map <LocalLeader>tc :tabclose<cr>
" next tab
map <LocalLeader>tn :tabnext<cr>
" previous tab
map <LocalLeader>tp :tabprev<cr>
" move a tab to a new location
map <LocalLeader>tm :tabmove

" some useful mappings
" Y yanks from cursor to $
map Y y$
" toggle list mode
nmap <LocalLeader>tl :set list!<cr>
" toggle paste mode
nmap <LocalLeader>pp :set paste!<cr>
" change directory to that of current file
nmap <LocalLeader>cd :cd%:p:h<cr>
" change local directory to that of current file
nmap <LocalLeader>lcd :lcd%:p:h<cr>
" save and build
nmap <LocalLeader>wm :w<cr>:make<cr>
" open all folds
nmap <LocalLeader>fo :%foldopen!<cr>
" close all folds
nmap <LocalLeader>fc :%foldclose!<cr>
" ,tt will toggle taglist on and off
nmap <LocalLeader>tt :Tlist<cr>
" When I'm pretty sure that the first suggestion is correct
map <LocalLeader>r 1z=
" togle wordwrap mode
map <LocalLeader>ww :set wrap!<cr>

" display mark line
:nnoremap <silent> <LocalLeader>k mk:exe 'match Search /<Bslash>%'.line(".").'l/'<CR>

" Increase undolevel because of above mappings.
set undolevels=3000

" Function used to display syntax group.
function! SyntaxItem()
  return synIDattr(synID(line("."),col("."),1),"name")
endfunction

" Function used to display utf-8 sequence.
fun! ShowUtf8Sequence()
  try
    let p = getpos('.')
    redir => utfseq
    sil normal! g8
    redir End
    call setpos('.', p)
    return substitute(matchstr(utfseq, '\x\+ .*\x'), '\<\x', '0x&', 'g')
  catch
    return '?'
  endtry
endfunction

"set statusline=%<%F%h%m%r%h%w%y\ %{strftime(\"%Y/%m/%d-%H:%M\")}%=\ col:%c%V\ ascii:%b\ pos:%o\ lin:%l\,%L\ %P
"set statusline=%h%F%m%r%=[%l:%c(%p%%)]
"set statusline=%-3.3n\ %f\ %r%#Error#%m%#Statusline#\ (%l/%L,\ %v)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]

if 1
if has('statusline')
  if version >= 700
    " Fancy status line.
    set statusline =
    set statusline+=%#User1#                       " highlighting
    set statusline+=%n                             " buffer number
    set statusline+=%{'/'.bufnr('$')}\             " buffer count
    set statusline+=%#User2#                       " highlighting
    set statusline+=%f                             " file name
    set statusline+=%#User1#                       " highlighting
    set statusline+=%h%m%r%w\                      " flags
    set statusline+=%{(&key==\"\"?\"\":\"encr,\")} " encrypted?
    set statusline+=%{strlen(&ft)?&ft:'none'},     " file type
    set statusline+=%{(&fenc==\"\"?&enc:&fenc)},   " encoding
    set statusline+=%{((exists(\"+bomb\")\ &&\ &bomb)?\"B,\":\"\")} " BOM
    set statusline+=%{&fileformat},                " file format
    set statusline+=%{&spelllang},                 " spell language
    set statusline+=%(%{Tlist_Get_Tagname_By_Line()}%), " Function name
    set statusline+=%{SyntaxItem()}                " syntax group under cursor
    set statusline+=%=                             " indent right
    set statusline+=%#User2#                       " highlighting
    set statusline+=%{ShowUtf8Sequence()}\         " utf-8 sequence
    set statusline+=%#User1#                       " highlighting
    set statusline+=U+%04B\                        " Unicode char under cursor
    set statusline+=%-6.(%l,%c%V%)\ %<%P           " position

    " Use different colors for statusline in current and non-current window.
    let g:Active_statusline=&g:statusline
    let g:NCstatusline=substitute(
      \                substitute(g:Active_statusline,
      \                'User1', 'User3', 'g'),
      \                'User2', 'User4', 'g')
    au! WinEnter * let&l:statusline = g:Active_statusline
    au! WinLeave * let&l:statusline = g:NCstatusline
  endif
endif
endif

iab 8< --- 8< --- cut here --- 8< --- cut here --- 8< ---
iab fori for (i = 0; i <; i++)<cr>{<cr>}<Esc>kk0f<a
iab forj for (j = 0; j <; j++)<cr>{<cr>}<Esc>kk0f<a
iab cfunc //!<cr>! \\brief<cr>!<esc>kA

if !exists(':DiffOrig')
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                 \ | wincmd p | diffthis
endif

" WinManager plugin settings
nnoremap <silent> <F4> :WMToggle<CR>
nnoremap <silent> <F5> :FirstExplorerWindow<CR>
nnoremap <silent> <F6> :BottomExplorerWindow<CR>

let winManagerWindowLayout = 'FileExplorer|BufExplorer'
let g:persistentBehaviour = 0

" taglist plugin settings
nnoremap <silent> <F9> :Tlist<CR>
nnoremap <silent> <F8> :TlistSync<CR>
nnoremap <silent> <F7> :TlistUpdate<CR>

let Tlist_Inc_Winwidth = 0
let Tlist_Auto_Open = 1
let Tlist_Process_File_Always = 0
let Tlist_Enable_Fold_Column = 0
let Tlist_Display_Tag_Scope = 0
let Tlist_Sort_Type = "name"
let Tlist_Use_Right_Window = 1
let Tlist_Display_Prototype = 0
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close = 1

" OmniCppComplete
if version >= 700
  if has('insert_expand')
    let OmniCpp_GlobalScopeSearch = 1
    let OmniCpp_NamespaceSearch = 1
    let OmniCpp_DisplayMode = 0
    let OmniCpp_ShowScopeInAbbr = 0
    let OmniCpp_ShowPrototypeInAbbr = 0
    let OmniCpp_ShowAccess = 1
    let OmniCpp_MayCompleteDot = 1
    let OmniCpp_MayCompleteArrow = 1
    let OmniCpp_SelectFirstItem = 0
    let OmniCpp_LocalSearchDecl = 0
    let OmniCpp_MayCompleteScope  = 1
    let OmniCpp_DefaultNamespaces = []

    if has('autocmd')
      " Automatically open/close the preview window.
      au! CursorMovedI,InsertLeave * if pumvisible() == 0 | sil! pclose | endif
      set completeopt=menuone,longest,preview
    endif
  endif
endif

" // The switch of the Source Explorer
nmap <F11> :SrcExplToggle<CR>

""map  <F12> :!ctags -R --c++-kinds=+p --fields=+iaSn --extra=+q .<CR>
map <F12> <C-W>w
imap <F12> <ESC><C-W>wa

" // Set the height of Source Explorer window
let g:SrcExpl_winHeight = 8

" // Set 100 ms for refreshing the Source Explorer
let g:SrcExpl_refreshTime = 100

" // Set "Enter" key to jump into the exact definition context
let g:SrcExpl_jumpKey = "<ENTER>"

" // Set "Space" key for back from the definition context
let g:SrcExpl_gobackKey = "<SPACE>"

" // In order to Avoid conflicts, the Source Explorer should know what plugins
" // are using buffers. And you need add their bufname into the list below
" // according to the command ":buffers!"
let g:SrcExpl_pluginList = [
\ "__Tag_List__",
\ "_NERD_tree_",
\ "Source_Explorer",
\ "[File List]",
\ "[Buf List]"
\ ]
" // Enable/Disable the local definition searching, and note that this is not
" // guaranteed to work, the Source Explorer doesn't check the syntax for now.
" // It only searches for a match with the keyword according to command 'gd'
let g:SrcExpl_searchLocalDef = 1

" // Let the Source Explorer update the tags file when opening
let g:SrcExpl_isUpdateTags = 1

" // Use program 'ctags' with argument '--sort=foldcase -R' to create or
" // update a tags file
let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ."

" // Set "<S-F12>" key for updating the tags file artificially
let g:SrcExpl_updateTagsKey = "<S-F12>" 

" bracket autocompletion
"inoremap ( ()<ESC>i
"inoremap [ []<ESC>i
"inoremap { {<CR>}<ESC>O
"autocmd Syntax html,vim inoremap < <lt>><ESC>i| inoremap > <c-r>=ClosePair('>')<CR>
"inoremap ) <c-r>=ClosePair(')')<CR>
"inoremap ] <c-r>=ClosePair(']')<CR>
"inoremap } <c-r>=CloseBracket()<CR>
"inoremap " <c-r>=QuoteDelim('"')<CR>
"inoremap ' <c-r>=QuoteDelim("'")<CR>

"function ClosePair(char)
"if getline('.')[col('.') - 1] == a:char
"return "\<Right>"
"else
"return a:char
"endif
"endf

"function CloseBracket()
"if match(getline(line('.') + 1), '\s*}') < 0
"return "\<CR>}"
"else
"return "\<ESC>j0f}a"
"endif
"endf

"function QuoteDelim(char)
"let line = getline('.')
"let col = col('.')
"if line[col - 2] == "\\"
"" Inserting a quoted quotation mark into the string
"return a:char
"elseif line[col - 1] == a:char
"" Escaping out of the string
"return "\<Right>"
"else
"" Starting a string
"return a:char.a:char."\<ESC>i"
"endif
"endf

if has('autocmd')
  " Source .vimrc when I write it.  The nested keyword allows 
  " autocommand ColorScheme to fire when sourcing ~/.vimrc.
  au! BufWritePost .vimrc nested source %

  " Change color of cursor in terminal:
  " - red in normal mode.
  " - orange in insert mode.
  " Tip found there:
  "   http://forums.macosxhints.com/archive/index.php/t-49708.html
  " It works at least with: xterm rxvt eterm
  " But do nothing with: gnome-terminal terminator konsole xfce4-terminal
	if 0
  if version >= 700
    if &term =~ "xterm\\|rxvt"
      ":silent !echo -ne "\033]12;red\007"
      let &t_SI = "\033]12;orange\007"
      let &t_EI = "\033]12;red\007"
      ""au! VimLeave * :sil !echo -ne "\033]12;red\007"
      au! VimLeave * :sil call CleanupStuff
    endif
	endif
  endif	
endif

" See http://vim.wikia.com/wiki/Using_GUI_color_settings_in_a_terminal
" Cygwin terminal does not support 256 colors but vim insider xterm
" with cygwin does support 256 colors.
if version >= 700 && !has('gui_running') && &term != 'cygwin'
  " In the terminal, try to use CSApprox.vim plugin or guicolorscheme.vim
  " plugin if possible in order to have consistent colors on different
  " terminals.
  "
  " Uncomment one of the following line to force 256 or 88 colors if
  " your terminal supports it.  Or comment both of them if your terminal
  " supports neither 256 nor 88 colors.
  set t_Co=256
  "set t_Co=88

  if &t_Co == 256 || &t_Co == 88
    " Check whether to use CSApprox.vim plugin or guicolorscheme.vim plugin.
    " The 2 plugins have their pros and cons:
    "
    " - CSApprox.vim is more robust since it does not rely on parsing
    "   the colorscheme file.
    " - CSApprox.vim is better documented and more configurable.
    " - CSApprox.vim does not rely on a hack to load it.
    "
    " - guicolorscheme.vim is faster.
    " - guicolorscheme.vim does not require +gui feature being built in Vim.
    "
    if has('gui') &&
      \ (filereadable(expand("$HOME/.vim/plugin/CSApprox.vim")) ||
      \  filereadable(expand("$HOME/vimfiles/plugin/CSApprox.vim")))
      let s:use_CSApprox = 1
    elseif filereadable(expand("$HOME/.vim/plugin/guicolorscheme.vim")) ||
      \    filereadable(expand("$HOME/vimfiles/plugin/guicolorscheme.vim"))
      "let s:use_guicolorscheme = 1
    endif
  endif
endif

" rastafari colorscheme available at:
"   http://dominique.pelle.free.fr/rastafari.vim
if exists('s:use_CSApprox')
  " Can use the CSApprox.vim plugin.
  let g:CSApprox_attr_map = { 'bold' : 'bold', 'italic' : '', 'sp' : '' }
  colorscheme rastafari
elseif exists('s:use_guicolorscheme')
  " Can use the guicolorscheme plugin. It needs to be loaded before
  " running GuiColorScheme (hence the :runtime! command).
  runtime! plugin/guicolorscheme.vim
  GuiColorScheme rastafari
else
  colorscheme jkh.grumble
  "colorscheme wood
  "colorscheme vylight
  "colorscheme soso
  "colorscheme tir_black
  "colorscheme vibrantink
  "colorscheme vividchalk
  "colorscheme vc
  "colorscheme winter
  "colorscheme wombat
  "colorscheme wombat256
  "colorscheme xcodelike
  "colorscheme xemacs
  "colorscheme xoria256
  "colorscheme zenburn
  "colorscheme spring
  "colorscheme tcsoft
  "colorscheme synic
  "colorscheme summerfruit256
  "colorscheme sea
  "colorscheme silent
  "colorscheme softblue
  "colorscheme simpleandfriendly
  "colorscheme sienna
  "colorscheme settlemyer
  "colorscheme satori
  "colorscheme rootwater
  "colorscheme robinhood
  "colorscheme rdark
  "colorscheme night
  "colorscheme neon
  "colorscheme oceandeep
  "colorscheme olive
  "colorscheme moria
  "colorscheme moss
  "colorscheme molokai
  "colorscheme autumn
  "colorscheme camo
  "colorscheme candy
  "colorscheme dante
  "colorscheme darkblue2
  "colorscheme darkbone
  "colorscheme darkslategray
  "colorscheme dawn
  "colorscheme dw_yellow
endif

"xsemiyas"
if 0
highlight CurrentLine guibg=yellow guifg=black ctermbg=yellow ctermfg=black 
au! Cursorhold * exe 'match CurrentLine /\%' . line('.') . 'l.*/' 
set ut=100
endif

if version >= 700 && has('autocmd')
  " Undo break if I don't press a key in insert mode for a few seconds.
  au! CursorHoldI * call feedkeys("\<C-G>u", "nt")
endif


" vim -b : edit binary using xxd-format
" See :help hex-editing
augroup Binary
  au!
  au BufReadPre   *.dat let &bin=1
  au BufReadPost  *.dat if &bin    | %!xxd
  au BufReadPost  *.dat set ft=xxd | endif
  au BufWritePre  *.dat if &bin    | %!xxd -r
  au BufWritePre  *.dat endif
  au BufWritePost *.dat if &bin    | %!xxd
  au BufWritePost *.dat set nomod  | endif
augroup END

" hexa conversion
nmap <C-@>h :%!xxd<CR>
nmap <C-@>d :%!xxd -r<CR>

set tags=./tags,../tags,../../tags,../../../tags,../../../../tags,../../../../../tags,../../../../../../tags,../../../../../../../ta:gs,../../../../../../../../tags,~/tags,/Volumes/android/master/libcore/luni/tags
let g:ctags_path='/usr/bin/ctags'
let g:ctags_statusline=1
"let g:ctags_regenerate=0
""(or whatever other additional arguments you want to pass to ctags)
let g:ctags_args='-I__declspec+'
let generate_tags=1
