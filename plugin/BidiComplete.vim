" BidiComplete.vim: Insert mode completion that considers text before AND AFTER
" the cursor. 
"
" DESCRIPTION:
"   The built-in insert mode completion |i_CTRL-N| searches for words that start
"   with the keyword in front of the cursor. Any text after the cursor is
"   ignored. 
"   So when you want to replace "MyFunnyVariable" with "MySpecialVariable", you
"   have to delete everything after "My", then start completion, which now also
"   offers "MySpecialFunction", "MySpecialWhatever", in which you're not
"   interested in. If you only removed the "Funny" part, the list of
"   (inapplicable) completions would be the same, and you would finally end up
"   with "MySpecialVariableVariable", requiring additional edits. 
"
"   This plugin offers a custom completion function that considers the text
"   after the cursor; if there is no keyword immediately after the cursor, it
"   behaves like the built-in completion. It even works when there is only text
"   after, but not before the cursor, so completion on "|Variable" yields
"   "MySpecialVariable", "MyFunnyVariable", etc. 
"   The base for completion is derived from the string of keyword characters
"   before and after the cursor, so set your 'iskeyword' option accordingly. 
"
" USAGE:
" i_CTRL-B		Find matches for words that start with the keyword in
"			front of the cursor and end with the keyword after the
"			cursor. 
"   In insert mode, invoke the bidirectional completion via CTRL-B. 
"   You can then search forward and backward via CTRL-N / CTRL-P, as usual. 
"
" INSTALLATION:
" DEPENDENCIES:
"   - CompleteHelper.vim autoload script. 
"
" CONFIGURATION:
"   Analoguous to the 'complete' option, you can specify which buffers will be
"   scanned for completion candidates. Currently, only '.' (current buffer) and
"   'w' (buffers from other windows) are supported. 
"	g:BidiComplete_complete string (default: ".,w")
"	b:BidiComplete_complete string
"   
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
"	003	15-May-2009	Also define the CTRL-X CTRL-B alternative,
"				unless that mapping is already taken. Otherwise,
"				the {rhs} of the <Plug>BidiComplete mapping
"				would be inserted if one accidentally invoked
"				the alternative. 
"	002	15-Aug-2008	Completed implementation. 
"	001	13-Aug-2008	file creation

" Avoid installing twice or when in unsupported VIM version. 
if exists('g:loaded_BidiComplete') || (v:version < 700)
    finish
endif
let g:loaded_BidiComplete = 1

if ! exists('g:BidiComplete_complete')
    let g:BidiComplete_complete = '.,w'
endif

function! s:GetCompleteOption()
    return (exists('b:BidiComplete_complete') ? b:BidiComplete_complete : g:BidiComplete_complete)
endfunction

function! s:Process( match )
    let a:match.abbr = a:match.word
    let a:match.word = strpart( a:match.word, 0, len( a:match.word) - len(s:remainder) )
    return a:match
endfunction

function! s:BidiComplete( findstart, base )
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
	return l:matches
    endif
endfunction

inoremap <Plug>BidiComplete <C-o>:set completefunc=<SID>BidiComplete<CR><C-x><C-u>
if ! hasmapto('<Plug>BidiComplete', 'i')
    imap <C-b> <Plug>BidiComplete

    " Since most completion mappings start with CTRL-X, also define the CTRL-X
    " CTRL-B alternative, unless that mapping is already taken. Otherwise, the
    " {rhs} of the <Plug>BidiComplete mapping would be inserted if one
    " accidentally invoked the alternative. 
    if empty(maparg('<C-x><C-b>', 'i'))
	imap <C-x><C-b> <Plug>BidiComplete
    endif
endif

" vim: set sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
