define-command today %{
    execute-keys '| date +"%d-%m-%Y"<ret>'
}

define-command base64 -params ..1 %{
    execute-keys '| xargs cat | base64<ret>'
    evaluate-commands %sh{
        if [ "$1" = "image" ]; then
            echo "set-register dquote %{data:image/png;base64,}"
            echo "execute-keys P"
        fi
    }
}
