" TODO: summary
"
" DESCRIPTION:
" USAGE:
" INSTALLATION:
" DEPENDENCIES:
" CONFIGURATION:
" INTEGRATION:
" LIMITATIONS:
" ASSUMPTIONS:
" KNOWN PROBLEMS:
" TODO:
"
" Copyright: (C) 2008 by Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'. 
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS 
"	001	13-Aug-2008	file creation

" Avoid installing twice or when in unsupported VIM version. 
if exists('g:loaded_MiddleComplete') || (v:version < 700)
    finish
endif
let g:loaded_MiddleComplete = 1

function! MiddleComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword. 
	let l:startCol = searchpos('\k*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif
	"let l:base = strpart(getline('.'), l:startCol, (col('.') - l:startCol - 1))
"****D echomsg '****' l:base
	
	let s:remainder = matchstr( getline('.'), '^\k*', col('.') - 1 )
echomsg '**** "' s:remainder . '"' col('.')
	return l:startCol - 1 " Return byte index, not column. 
    else
	" Find matches starting with a:base. 
	let l:matches = CompleteHelper#FindMatches( '\V\<' . escape(a:base, '\') . '\k\+' . escape(s:remainder, '\') . '\>' , 0 )
	if ! empty(s:remainder)
	    call map( l:matches, 'strpart(v:val, 0, len(v:val) - ' . len(s:remainder) . ')' ) 
	endif
	return l:matches
    endif
endfun

inoremap <C-X><C-M> <C-O>:set completefunc=MiddleComplete<CR><C-X><C-U>

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
