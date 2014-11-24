## vim-endoscope

[![Build Status](https://api.travis-ci.org/idbrii/vim-endoscope.svg)](https://travis-ci.org/idbrii/vim-endoscope)

A single keystroke to end your scope. Like autoclose plugins, but less
automatic.

I don't like autoclose plugins because they add characters between where my
cursor is and where I want it to be. Instead, endoscope provides a single
keystroke to close the nearest scope. It's not brilliant, but it works
reasonably well.


### Usage

endoscope adds `<C-S>` as an insert-mode map to close the current scope (parens
or quotes). Mnemonic: s for scope.

To set your own map, you can add this to your vimrc:

    imap <C-S> <Plug>(endoscope-close-pair)

vim-surround also maps `i_CTRL-s` to insert paired characters. This is not as
useful when you can just close the previous one instead: It's the same number
of keystrokes but with endoscope you can keep typing, whereas with surround you
need to navigate past the close scope character.

Beware that CTRL-S won't work on terminals with flow control (if you
accidentally freeze your terminal, use CTRL-Q to unfreeze it). See [How to
unfreeze after accidentally pressing Ctrl-S in a terminal?](3) for how to avoid
this and [What is the point of CTRL-s?](3) for why it happens.

### Limitations

Quote matching only works within a syntax-defined string region. So if you
don't have syntax enabled, it may not work. If you're in an irregular string,
it may not work.

Example: #includes in cpp aren't normal string regions, they're cIncluded
regions. However, this particular case is handled (endoscope treats all
includes as strings).


### Future Work

Ideally, I'd like endoscope to also add all `end` statements covered by tpope/endwise.


### Thanks

* progo on Stack Overflow for [the original close pairs implementation](1).
* marklgr and hahiss on reddit for [adding quote support](2).


### License

MIT

[1]: http://stackoverflow.com/a/6080996/79125
[2]: http://www.reddit.com/r/vim/comments/2lnwqy/map_to_close_current_quote_bracket_or_paren/
[3]: http://unix.stackexchange.com/a/12108/21401
[4]: http://unix.stackexchange.com/q/137842/21401
