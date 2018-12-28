# Call emmet-cli with the current selection as input.
# Depends on https://github.com/Delapouite/emmet-cli
define-command emmet %{
    evaluate-commands -save-regs '"' %{
        execute-keys -save-regs "" d
        evaluate-commands %sh{
            eval set -- "$kak_reg_dquote"
            snippet=$(echo "$@" | emmet -p | sed -e "s/\t/\$\{indent\}/g")
            echo "snippets-insert %{$snippet}"
        }
    }
}
