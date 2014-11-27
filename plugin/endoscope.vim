" Endoscope - end your scope with a single keystroke
"
if exists('loaded_endoscope') || &cp || version < 700
    finish
endif
let loaded_endoscope = 1


if !exists("g:endoscope_handle_quotes")
    let g:endoscope_handle_quotes = 1
endif


function! s:join_and_escape(items)
    return escape(join(a:items, ''), ']"')
endf

function! s:is_string(col_pos)
    let syn_id = synIDattr(synID(line("."), a:col_pos, 0), "name")
    return syn_id =~? "string\\|include"
endf

function! s:is_next_to_unmatched(cursor_byte, unmatched_pairs)
    let previous_char = getline(line('.'))[a:cursor_byte - 1]
    return has_key(a:unmatched_pairs, previous_char)
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

    let skip = ''
    " col is 1-indexed, so convert to 0-indexed.
    let cursor_byte = col(".") - 1
    if g:endoscope_handle_quotes && s:is_string(cursor_byte) && !s:is_next_to_unmatched(cursor_byte, unmatched_pairs)
        let pairs = unmatched_pairs
    else
        let pairs = matched_pairs
        if g:endoscope_handle_quotes
            let skip = 's:is_string(col("."))'
        endif
    endif

    " Build the search patterns from the open/close-pair dictionary.
    let open_pat  = "[". s:join_and_escape(keys(pairs))   ."]"
    let close_pat = "[". s:join_and_escape(values(pairs)) ."]"
    let [lnum, col] = searchpairpos(open_pat, '', close_pat, 'nbW', skip)

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

inoremap <expr> <Plug>(endoscope-close-pair) <SID>CloseMatchingPair()

if !hasmapto('<Plug>(endoscope-close-pair)', 'i')
    imap <C-s> <Plug>(endoscope-close-pair)
endif

