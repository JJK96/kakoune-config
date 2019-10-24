define-command pipe-selections -params 1.. -override -docstring '
pipe-selections [<switches>] command: Pipe all selections newline delimited through a shell command and return the result in place.
switches:
    -delimiter <string>: use the given delimiter instead of a newline. 
' %{
    # Copy current selections to a temporary sort buffer
    execute-keys %{"sy}
    edit -scratch *pipe-selections*
    execute-keys %{"s<a-p>}

    execute-keys %sh{
        delimiter='\\n'
        if [ "$1" == "-delimiter" ]; then
            delimiter=$2
            shift
            shift
        fi
        echo "<a-!>printf $delimiter<ret>ggd"

        # Sort the buffer
        echo "%|head -c-1|$@<ret>"
        # Yank the sorted candidates
        delimiter=$(printf $delimiter)
        echo "%S$delimiter<ret>"
    }
    execute-keys %{"sy}

    # Update the original buffer
    delete-buffer
    execute-keys %{"sR}
}

define-command pipe-selections1 -params 0.. -override %{
    info %sh{
        eval set -- "$kak_quoted_selections"
        IFS=$'\0'; echo "$*" | xxd
    }
}
