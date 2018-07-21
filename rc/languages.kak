hook global WinSetOption filetype=(html) %[
    define-command emmet %{
        execute-keys "<esc><a-?>\h+|^<ret>|%val{config}/bin/emmet-call<ret>"
        execute-keys "<esc>uU)<a-;> ;: replace-next-hole<ret>"
    }
    map global insert <a-E> ' <esc>;h: try snippet-word catch emmet<ret>'
    map global insert <a-e> '<esc>: replace-next-hole<ret>'
]

hook global WinSetOption filetype=(xml) %[
    set-option buffer formatcmd %{xmllint --format -}
]

hook global WinSetOption filetype=(json) %[
    set-option buffer formatcmd %{python -m json.tool}
]

