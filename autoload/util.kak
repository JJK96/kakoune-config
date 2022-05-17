define-command today %{
    execute-keys '| date +"%d-%m-%Y"<ret>'
}

define-command base64 -params ..1 -docstring "base64 [image]"%{
    execute-keys '| xargs cat | base64<ret>'
    evaluate-commands %sh{
        if [ "$1" = "image" ]; then
            echo "set-register dquote %{data:image/png;base64,}"
            echo "execute-keys P"
        fi
    }
}

define-command vscode -docstring "Open current file in visual studio code" %{
    nop %sh{code -g $kak_buffile:$kak_cursor_line:$kak_cursor_column}
}
