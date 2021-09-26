define-command -params .. fifo %{ evaluate-commands %sh{
     output=$(mktemp -d "${TMPDIR:-/tmp}"/kak-fifo.XXXXXXXX)/fifo
     mkfifo ${output}
     ( eval "$@" > ${output} 2>&1 & ) > /dev/null 2>&1 < /dev/null

     printf %s\\n "evaluate-commands -try-client '$kak_opt_toolsclient' %{
               edit! -fifo ${output} *fifo*
               hook -always -once buffer BufCloseFifo .* %{ nop %sh{ rm -r $(dirname ${output}) } }
           }"
}}
