function! s:join_and_escape(items)
    return escape(join(a:items, ''), ']"')
endf

function! s:openers(pairs)
    return s:join_and_escape(keys(a:pairs))
endf

function! s:closers(pairs)
    return s:join_and_escape(values(a:pairs))
endf

function! s:is_string(col_pos)
    return synIDattr(synID(line("."), a:col_pos, 0), "name") =~? "string"
endf

" Return a corresponding pair to be sent to the buffer
function! s:CloseMatchingPair()
" Original close pairs:
" http://stackoverflow.com/a/6080996/79125
" Modification for quotes:
" http://www.reddit.com/r/vim/comments/2lnwqy/map_to_close_current_quote_bracket_or_paren/

    let matched_pairs = {'(' : ')',
                   \  '[' : ']',
                   \  '{' : '}',
                   \  '<' : '>',
                   \ }
    let unmatched_pairs = {'"' : '"',
                   \  "'" : "'",
                   \ }

    let prev_byte = col(".") - 1
    if s:is_string(prev_byte)
        let pairs = unmatched_pairs
        let skip = ''
    else
        let pairs = matched_pairs
        let skip = 's:is_string(col("."))'
    endif
    let [lnum, col] = searchpairpos("[". s:openers(pairs) ."]", '', "[". s:closers(pairs) ."]", 'nbW', skip)

    if (lnum != 0) && (col != 0)
        " Found it above
        let c = getline(lnum)[col - 1]
        " How do I sometimes get an invalid c?
        if has_key(pairs, c)
            return pairs[c]
        endif
    endif

    return ''
endf

inoremap <expr> <C-;> <SID>CloseMatchingPair()

