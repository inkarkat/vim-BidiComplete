" TODO: summary
"
" DESCRIPTION:
" USAGE:
" INSTALLATION:
" DEPENDENCIES:
"   - CompleteHelper.vim autoload script. 
"
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
" Credits: Original idea by Laszlo Kozma in his paper "Reverse autocomplete"
"	   (http://www.lkozma.net/autocomplete.html)
"
" REVISION	DATE		REMARKS 
"	001	13-Aug-2008	file creation

" Avoid installing twice or when in unsupported VIM version. 
if exists('g:loaded_BidiComplete') || (v:version < 700)
    finish
endif
let g:loaded_BidiComplete = 1

function! s:Process( match )
    let a:match.abbr = a:match.word
    let a:match.word = strpart( a:match.word, 0, len( a:match.word) - len(s:remainder) )
    return a:match
endfunction

function! BidiComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword under cursor. 
	let l:startCol = searchpos('\k*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif
	
	" Remember any remainder of the keyword under cursor.  
	let s:remainder = matchstr( getline('.'), '^\k*', col('.') - 1 )

	return l:startCol - 1 " Return byte index, not column. 
    else
	" Find keyword matches starting with a:base and ending in s:remainder. 
	let l:matches = []
	call CompleteHelper#FindMatches( l:matches, '\V\<' . escape(a:base, '\') . '\k\+' . escape(s:remainder, '\') . '\>' , {'complete': '.,w'} )
	if ! empty(s:remainder)
	    call map( l:matches, 's:Process(v:val)' )
	endif
	return l:matches
    endif
endfun

inoremap <Plug>BidiComplete <C-o>:set completefunc=BidiComplete<CR><C-x><C-u>
if ! hasmapto('<Plug>BidiComplete', 'i')
    imap <C-x><C-m> <Plug>BidiComplete
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
