" Vim color file
" Maintainer:   Jason Dana <jason.dana@gmail.com>
" Last Change:  09 February 2011 - 0.0.1
" URL: http://github.com/sheutka/vim/colors/earth.vim


set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif
let g:colors_name="earth"

hi Normal           ctermfg=LightGray   ctermbg=Black
hi NonText          ctermfg=DarkGray    ctermbg=Black

hi Statement        ctermfg=DarkRed     ctermbg=Black
hi Comment          ctermfg=242         ctermbg=Black

hi Conditional      ctermfg=DarkGreen   ctermbg=Black 
hi Constant         ctermfg=74          ctermbg=Black
hi Exception        ctermfg=131         ctermbg=Black
hi Identifier       ctermfg=DarkCyan    ctermbg=Black
hi Function         ctermfg=White       ctermbg=Black
hi String           ctermfg=110         ctermbg=Black
hi Keyword          ctermfg=Red         ctermbg=Black
hi Type             ctermfg=Blue        ctermbg=Black
hi Special          ctermfg=74          ctermbg=Black

hi PreProc          ctermfg=182         ctermbg=Black       cterm=none term=none

hi Scrollbar        ctermfg=Blue        ctermbg=Black
hi Cursor           ctermfg=Gray        ctermbg=Black
hi Folded           ctermfg=DarkGreen   ctermbg=Black       cterm=none term=none
hi ErrorMsg         ctermfg=Red         ctermbg=Black       cterm=bold term=bold
hi WarningMsg       ctermfg=Red         ctermbg=Black       cterm=none cterm=none
hi VertSplit        ctermfg=White       ctermbg=Black       cterm=none cterm=none
hi Directory        ctermfg=Cyan        ctermbg=DarkBlue    cterm=none cterm=none
hi Visual           ctermfg=Black       ctermbg=DarkGray    cterm=none cterm=none 
hi Title            ctermfg=White       ctermbg=DarkBlue    cterm=none cterm=none

hi StatusLine       ctermfg=DarkGray    ctermbg=Black       term=none cterm=none   
hi StatusLineNC     ctermfg=DarkGray    ctermbg=Black       term=none cterm=none   
hi LineNr           ctermfg=DarkGray    ctermbg=DarkGray    term=none cterm=none

