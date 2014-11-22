function! s:CloseMatchingPair()
" Source:
" http://www.reddit.com/r/vim/comments/2lnwqy/map_to_close_current_quote_bracket_or_paren/
" http://stackoverflow.com/a/6080996/79125

    let matched_pairs = {'(' : ')',
                   \  '[' : ']',
                   \  '{' : '}',
                   \ }
    let unmatched_pairs = {'"' : '"',
                   \  "'" : "'",
                   \ }

    if synIDattr(synID(line("."), col(".")-1, 0), "name") =~? "string"
        let pairs = unmatched_pairs
        let [lnum, col] = searchpairpos("[". join(keys(pairs)) ."]", '', "[". join(values(pairs)) ."]", 'nbW')
    else
        let pairs = matched_pairs
        let [lnum, col] = searchpairpos("[". join(keys(pairs)) ."]", '', "[". join(values(pairs)) ."]", 'nbW',
            \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string"')
    endif

    let c = ''
    if (lnum != 0) && (col != 0)
        " Found it above
        let c = getline(lnum)[col - 1]
    elseif col('.') == col('$')
        " Might be last character of line
        let c = getline(line('.'))[col('.')-1]
    endif

    let g:closer_key = c

    if has_key(pairs, c)
        return pairs[c]
    endif

    return ''
endfun

inoremap <expr> <C-l> <SID>CloseMatchingPair()
