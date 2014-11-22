" Source:
" http://www.reddit.com/r/vim/comments/2lnwqy/map_to_close_current_quote_bracket_or_paren/
" http://stackoverflow.com/a/6080996/79125

" Close what-I-Mean
function! CloseWIM()
    let closepairs = {'(' : ')',
                   \  '[' : ']',
                   \  '{' : '}',
                   \  '"' : '"',
                   \  "'" : "'",
                   \ }

    if synIDattr(synID(line("."), col(".")-1, 0), "name") =~? "string"
        let [m_lnum, m_col] = searchpairpos("[\"']", '', "[\"']", 'nbW')
    else
        let [m_lnum, m_col] = searchpairpos('[[({]', '', '[\])}]', 'nbW',
            \ 'synIDattr(synID(line("."), col("."), 0), "name") =~? "string"')
    endif

    if (m_lnum != 0) && (m_col != 0)
        let c = getline(m_lnum)[m_col - 1]
        return closepairs[c]
    endif
    return ''
endfun

imap  <C-l>  <C-r>=CloseWIM()<CR>
