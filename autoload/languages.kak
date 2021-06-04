# Small configurations for different languages

define-command php_format %{
    nop %sh{
        php-cs-fixer fix --rules=@PSR2 $kak_buffile
    }
}

declare-option str formatcmd_json "python -m json.tool"
declare-option str formatcmd_xml "xmllint --format -"
declare-option str formatcmd_python "yapf"
declare-option str formatcmd_rust "rustfmt"
declare-option str formatcmd_javascript "js-beautify"
declare-option str formatcmd_sql "sqlformat --reindent --keywords upper --identifiers lower /dev/stdin"

hook global WinSetOption filetype=(xml) %[
    set-option buffer formatcmd %opt{formatcmd_xml}
]

# hook global WinSetOption filetype=(xml|html) %[
#     map global insert <a-E> ' <esc>;h: try snippet-word catch emmet<ret>'
# ]

hook global WinSetOption filetype=(json) %[
    set-option buffer formatcmd %opt{formatcmd_json}
]

hook global WinSetOption filetype=(python) %[
    set-option buffer formatcmd %opt{formatcmd_python}
    lsp-auto-hover-disable
    set window lsp_server_configuration pyls.plugins.pycodestyle.enabled=false pyls.plugins.pyflakes.enabled=false pyls.plugins.flake8.enabled=true
    alias window comment comment-line
    hook -once -always window WinSetOption filetype=.* %{
        unalias window comment
    }
]

# better indentation
hook global WinSetOption filetype=(p4|php|solidity) %[
    require-module c-family

    hook -group "%val{hook_param_capture_1}-my-trim-indent" window ModeChange insert:.* c-family-trim-indent
    hook -group "%val{hook_param_capture_1}-my-insert" window InsertChar \n c-family-insert-on-newline
    hook -group "%val{hook_param_capture_1}-my-indent" window InsertChar \n c-family-indent-on-newline
    hook -group "%val{hook_param_capture_1}-my-indent" window InsertChar \{ c-family-indent-on-opening-curly-brace
    hook -group "%val{hook_param_capture_1}-my-indent" window InsertChar \} c-family-indent-on-closing-curly-brace
    hook -group "%val{hook_param_capture_1}-my-insert" window InsertChar \} c-family-insert-on-closing-curly-brace

    hook -once -always window WinSetOption filetype=.* "
        remove-hooks window %val{hook_param_capture_1}-.+
    "

]

hook global WinSetOption filetype=(php) %[
    alias window format php_format
    lsp-auto-hover-disable

    hook -once -always window WinSetOption filetype=.* %{
        unalias window format
    }
]

hook global WinSetOption filetype=(rust) %[
    set-option buffer formatcmd %opt{formatcmd_rust}
]

hook global WinSetOption filetype=(javascript) %[
    set-option buffer lintcmd eslint
    set-option buffer formatcmd %opt{formatcmd_javascript}
]

hook global WinSetOption filetype=sql %[
    set window incsearch false
    set-option buffer formatcmd %opt{formatcmd_sql}
]

hook global WinSetOption filetype=c %[
    map global goto a -docstring "alternative file" %{<esc>: c-alternative-file<ret>}
]

hook global WinCreate .*\.grep %[
    set-option window filetype=grep
]

hook global WinCreate /tmp/neomutt.* %[
    set-option window filetype=mail
]

# hook global WinSetOption filetype=(plain|markdown) %[
#     set buffer lsp_server_configuration languageTool.language="en"
# ]

define-command format-selections1 -params 1 %{
    evaluate-commands %sh{
        echo "set-option window formatcmd %opt{formatcmd_$1}"
        echo "format-selections"
        echo "set-option window formatcmd %{$kak_opt_formatcmd}"
    }
}
