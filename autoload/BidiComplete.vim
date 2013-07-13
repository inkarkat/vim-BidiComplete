" BidiComplete.vim: Insert mode completion that considers text before AND AFTER
" the cursor.
"
" DEPENDENCIES:
"   - CompleteHelper.vim autoload script.
"   - ingo/collections.vim autoload script
"
" Copyright: (C) 2008-2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"	008	21-Feb-2013	Move to ingo-library.
"	007	29-Aug-2012	The number returned by
"				BidiComplete#GetMatchNum() may be too large when
"				the same match is found in multiple buffers.
"				Replicate the consolidation that Vim does by
"				counting only unique completion words.
"	006	22-Jan-2012	Add BidiComplete#GetMatchNum() hook to enable
"				custom "stop insert mode after completion"
"				mapping extension.
"	005	21-Jan-2012	Split off functions into separate autoload
"				script.
"			    	Using a map-expr instead of i_CTRL-O to set
"				'completefunc', as the temporary leave of insert
"				mode caused a later repeat via '.' to only
"				insert the completed fragment, not the entire
"				inserted text.
"	004	30-Sep-2011	Add <silent> to <Plug>-mapping.
"	003	10-Jun-2009	Changed default mapping to <C-x><C-b>; this
"				isn't used enough to warrant such a short
"				mapping, and it's less mentally taxing because
"				most completions start with <C-x>.
"	002	15-Aug-2008	Completed implementation.
"	001	13-Aug-2008	file creation

function! s:GetCompleteOption()
    return (exists('b:BidiComplete_complete') ? b:BidiComplete_complete : g:BidiComplete_complete)
endfunction

function! s:Process( match )
    let a:match.abbr = a:match.word
    let a:match.word = strpart( a:match.word, 0, len( a:match.word) - len(s:remainder) )
    return a:match
endfunction

let s:matchNum = -1
function! BidiComplete#GetMatchNum()
    return s:matchNum
endfunction

function! BidiComplete#BidiComplete( findstart, base )
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
	call CompleteHelper#FindMatches( l:matches, '\V\<' . escape(a:base, '\') . '\k\+' . escape(s:remainder, '\') . '\>' , {'complete': s:GetCompleteOption()} )
	if ! empty(s:remainder)
	    call map( l:matches, 's:Process(v:val)' )
	endif

	" We may have found the same match in multiple buffers. Vim
	" automatically consolidates those in the completion, but for counting,
	" we have to do this ourselves.
	let s:matchNum = len(ingo#collections#Unique(map(copy(l:matches), 'v:val.word')))

	return l:matches
    endif
endfunction

function! BidiComplete#Expr()
    set completefunc=BidiComplete#BidiComplete
    return "\<C-x>\<C-u>"
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
