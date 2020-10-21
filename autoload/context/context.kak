declare-option -hidden str context_dir %sh{echo "${kak_source%/*}"}

declare-option str context_fifo

define-command show-context %{
    evaluate-commands -draft %{
        execute-keys Gk<a-x>
        nop %sh{
            printf "%s" "$kak_selection" | "${kak_opt_context_dir}/context" > "$kak_opt_context_fifo"
        }
        edit -fifo "%opt{context_fifo}" "%val{bufname}_context"
    }
}

define-command buffer-enable-context %{
    evaluate-commands %sh{
        fifo=$(mktemp -t kak_context_XXXXX)
        mkfifo "$fifo"
        echo set-option buffer context_fifo "$fifo"
    }
    evaluate-commands -draft %{
        new edit -fifo "%opt{context_fifo}" "%val{bufname}_context"
    }
    hook buffer NormalIdle .* show-context
}

define-command buffer-disable-context %{
    evaluate-commands %sh{
        rm "$kak_opt_context_fifo"
    }
}
