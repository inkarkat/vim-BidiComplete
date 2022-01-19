BIDI COMPLETE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

The built-in insert mode completion i\_CTRL-N searches for words that start
with the keyword in front of the cursor. Any text after the cursor is ignored.
So when you want to replace "MyFunnyVariable" with "MySpecialVariable", you
have to delete everything after "My", then start completion, which now also
offers "MySpecialFunction", "MySpecialWhatever", in which you're not
interested in. If you only removed the "Funny" part, the list of
(inapplicable) completions would be the same, and you would finally end up
with "MySpecialVariableVariable", requiring additional edits.

This plugin offers a custom completion mapping that considers the text after
the cursor; if there is no keyword immediately after the cursor, it behaves
like the built-in completion. It even works when there is only text after, but
not before the cursor, so completion on "|Variable" yields
"MySpecialVariable", "MyFunnyVariable", etc. The base for completion is
derived from the string of keyword characters before and after the cursor, so
set your 'iskeyword' option accordingly.

### SOURCE

- [Original idea by Laszlo Kozma in his paper "Reverse autocomplete"](http://www.lkozma.net/autocomplete.html)

### SEE ALSO

- Check out the CompleteHelper.vim plugin page ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)) for a full
  list of insert mode completions powered by it.

USAGE
------------------------------------------------------------------------------

    In insert mode, invoke the bidirectional completion via CTRL-X CTRL-B.
    You can then search forward and backward via CTRL-N / CTRL-P, as usual.

    CTRL-X CTRL-B           Find matches for words that start with the (optional)
                            keyword in front of the cursor and end with the
                            (mandatory) keyword (or non-keyword non-whitespace,
                            either optionally separated by whitespace) after the
                            cursor.

### EXAMPLE
(the "|" denotes the cursor)

The B|Complete
    will complete to "BidiComplete"
The |Complete
    will offer all words ending with "Complete"
The d|.
    will complete to "dog" if that word ends somewhere with a period (the
    completion base after the cursor is mandatory, and non-keyword characters
    are taken, too)
My | lady
    will complete to "fair" from "fair lady". There's no leading base, as
    whitespace before the cursor is ignored, but for the mandatory trailing
    base, " lady" is taken.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-BidiComplete
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim BidiComplete*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.010 or
  higher.
- Requires the CompleteHelper.vim plugin ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)).

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

By default, the 'complete' option controls which buffers will be scanned for
completion candidates. You can override that either for the entire plugin, or
only for particular buffers; see CompleteHelper\_complete for supported
values.

    let g:BidiComplete_complete = '.,w,b,u'

If you want to use a different mapping, map your keys to the
&lt;Plug&gt;(BidiComplete) mapping target _before_ sourcing the script (e.g.
in your vimrc):

    imap <C-x><C-b> <Plug>(BidiComplete)

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-BidiComplete/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.02    RELEASEME
- Remove default g:BidiComplete\_complete configuration and default to
  'complete' option value instead.

##### 1.01    15-Jul-2013
- Tweak base algorithm: Enforce base after cursor (without it, the completion
would be just like the default one), also take non-keyword non-whitespace
characters there, optionally separated by whitespace. This makes the
completion useful in more places.

##### 1.00    14-Jul-2013
- First published version.

##### 0.01    13-Aug-2008
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2008-2022 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
