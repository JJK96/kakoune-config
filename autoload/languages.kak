# Small configurations for different languages

hook global WinSetOption filetype=(xml) %[
    set-option buffer formatcmd %{xmllint --format -}
]

# hook global WinSetOption filetype=(xml|html) %[
#     map global insert <a-E> ' <esc>;h: try snippet-word catch emmet<ret>'
# ]

hook global WinSetOption filetype=(json) %[
    set-option buffer formatcmd %{python -m json.tool}
]

hook global WinSetOption filetype=(python) %[
    set-option buffer formatcmd %{yapf}
]

# better indentation
hook global WinSetOption filetype=(p4|php) %[
    hook -group c-family-indent window ModeChange insert:.* c-family-trim-autoindent
    hook -group c-family-insert window InsertChar \n c-family-insert-on-newline
    hook -group c-family-indent window InsertChar \n c-family-indent-on-newline
    hook -group c-family-indent window InsertChar \{ c-family-indent-on-opening-curly-brace
    hook -group c-family-indent window InsertChar \} c-family-indent-on-closing-curly-brace
    hook -group c-family-insert window InsertChar \} c-family-insert-on-closing-curly-brace
]

hook global WinSetOption filetype=(rust) %[
    set-option buffer formatcmd rustfmt
]

# hook global WinSetOption filetype=(markdown|latex) %[
#     set -add buffer snippet_files "%val{config}/snippets/latex.yaml"
# ]

hook global WinSetOption filetype=(plain|markdown) %[
    set buffer lsp_server_configuration languageTool.language="en"
]
