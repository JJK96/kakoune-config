# Configuration options for markdown

# Compile to pdf or to html
declare-option -docstring "compile to pdf" str markdown_filetype pdf
declare-option -docstring "store in tmp directory" bool markdown_tmp true
declare-option -hidden str markdown_out_file ""
declare-option -docstring "pdf reader command" str markdown_pdf_reader "open"
declare-option -docstring "pdf reader reset command" str markdown_pdf_reset "pkill -HUP llpp"

define-command markdown_set_out_file %{
    evaluate-commands %sh{
        if $kak_opt_markdown_tmp; then
            dir="/tmp"
            filename="output"
        else
            dir="${kak_buffile%/*}"
            filename="${kak_buffile##*/}"
            filename="${filename%.*}"
        fi
        echo "set-option window markdown_out_file $dir/$filename.$kak_opt_markdown_filetype"
    }
}

define-command markdown_open_reader %{
    evaluate-commands %sh{
        ( eval $kak_opt_markdown_pdf_reader $kak_opt_markdown_out_file ) >/dev/null 2>/tmp/err </dev/null &
    }
}

define-command markdown_toggle_checkbox %{
    evaluate-commands -draft %{
        execute-keys -save-regs "" <a-x>s\[.\]<ret>h
        evaluate-commands -itersel %{
            execute-keys -save-regs "" y
            set-register dquote %sh{
                if [ "$kak_reg_dquote" = " " ]; then
                    echo "x"
                else
                    echo " "
                fi
            }
            execute-keys R
        }
    }
}

hook global WinSetOption filetype=markdown %{

    hook window WinSetOption markdown_tmp=.* %{
        markdown_set_out_file
    }

    hook window WinSetOption markdown_filetype=.* %{
        markdown_set_out_file
    }

    define-command enable-markdown-compile %{
        # compile markdown in background on save.
        hook window -group markdown-compile BufWritePost .* %{ nop %sh{ (
            pandoc -o $kak_opt_markdown_out_file $kak_buffile && \
            if [ "$kak_opt_markdown_filetype" = "pdf" ]; then
                eval "$kak_opt_markdown_pdf_reset"
            fi
            ) > /dev/null 2>&1 < /dev/null &
        }}
        markdown_set_out_file
    }

    hook -once global WinSetOption filetype=(?!markdown).* %{
        remove-hooks window markdown-compile
    }

    map global insert <c-b> "****<esc>hhi"
    map -docstring "Toggle checkbox" global user c ": markdown_toggle_checkbox<ret>"

}

