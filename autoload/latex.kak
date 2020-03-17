# latex

hook global WinSetOption filetype=latex %{

# Compile the first main.tex found
# NOTE: Make sure that latex-compile-main is in the path

hook window -group latex-compile BufWritePost .* %{ nop %sh{ (
    latex-compile-main ${kak_buffile%/*}
) > /tmp/tex.log 2>&1 < /dev/null &}}

hook global WinSetOption filetype=(?!latex).* %{
    remove-hooks global latex-compile

}

}
