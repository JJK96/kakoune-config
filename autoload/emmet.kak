# Call emmet-cli with the current selection as input.
# Depends on https://github.com/Delapouite/emmet-cli
define-command emmet %{
    evaluate-commands -save-regs '"' %{
        execute-keys -save-regs "" d
        evaluate-commands %sh{
            eval set -- "$kak_reg_dquote"
            snippet=$(echo "$@" | emmet -p )
            echo "snippets-insert %{$snippet}"
        }
    }
}

declare-option completions emmet_completions 

hook global WinSetOption filetype=(xml|html) %{
    set -add buffer completers option=emmet_completions
    hook -group emmet-complete buffer InsertIdle .* %{
        evaluate-commands -draft %{
            try %{
                execute-keys -save-regs "" Zb
                evaluate-commands %{
                    execute-keys -save-regs "" yz
                    evaluate-commands %sh{
                        eval set -- "$kak_reg_dquote"
                        snippet=$(echo "$@" | emmet -p )
                        [ -z "$snippet" ] || printf "set buffer emmet_completions %s.%s@%s ' |exec -draft <esc>bd;snippets-insert %%{%s}|%s (emmet abbr)'" "$kak_cursor_line" "$kak_cursor_column" $(date +%N) "$snippet" "$@"
                    }
                }

            } catch %{
                set buffer emmet_completions ""
            }
        }
    }
    hook -once -always window WinSetOption filetype=.* %{
        remove-hooks window emmet-.+
        set-option window completers %sh{ printf %s\\n "'${kak_opt_completers}'" | sed -e 's/option=emmet_completions://g'} 
    }
}
