# python bridge for executing things interactively

declare-option str python_bridge_in /tmp/python-bridge-in
declare-option str python_bridge_out /tmp/python-bridge-out

define-command start-python-bridge %{
    nop %sh{
        mkfifo $kak_opt_python_bridge_in
        mkfifo $kak_opt_python_bridge_out
        ( tail -f $kak_opt_python_bridge_in | python -i > $kak_opt_python_bridge_out ) >/dev/null 2>&1 </dev/null &
    }
}

define-command stop-python-bridge %{
    nop %sh{
        echo "exit()" > $kak_opt_python_bridge_in
        rm $kak_opt_python_bridge_in
        rm $kak_opt_python_bridge_out
    }
}

define-command send-to-python %{
    evaluate-commands %sh{
        echo "set-register | %{ cat > $kak_opt_python_bridge_in; read -t 1 response < $kak_opt_python_bridge_out; echo \$response}"
    }
    execute-keys -itersel "|<ret>"
}
