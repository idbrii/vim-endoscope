" Original close pairs:
" http://stackoverflow.com/a/6080996/79125
" Modified to support quotes
" http://www.reddit.com/r/vim/comments/2lnwqy/map_to_close_current_quote_bracket_or_paren/

function! s:is_string(col_pos)
    return synIDattr(synID(line("."), a:col_pos, 0), "name") =~? "string"
endfunction

" Return a corresponding pair to be sent to the buffer
function! CloseMatchingPair()
    let closepairs = {'(' : ')',
                   \  '[' : ']',
                   \  '{' : '}',
                   \  '"' : '"',
                   \  "'" : "'",
                   \ }

    let prev_byte = col(".") - 1
    if s:is_string(prev_byte)
        let [m_lnum, m_col] = searchpairpos("[\"']", '', "[\"']", 'nbW')
    else
        let [m_lnum, m_col] = searchpairpos('[[({]', '', '[\])}]', 'nbW',
            \ 's:is_string(col("."))')
    endif

    if (m_lnum != 0) && (m_col != 0)
        let c = getline(m_lnum)[m_col - 1]
        return closepairs[c]
    endif
    return ''
endfun

imap <C-;> <C-r>=CloseMatchingPair()<CR>
