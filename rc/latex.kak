# latex

hook global WinSetOption filetype=latex %{

# Compile the first main.tex found
hook window -group latex-compile BufWritePost .* %{ nop %sh{ (
latex-compile-main ${kak_buffile%/*}
) > /tmp/tex.log 2>&1 < /dev/null &}}

# Snippets

define-command _enumerate %{execute-keys %{i\begin{enumerate}<ret>
\item <ret>
\end{enumerate}<esc>}}

define-command _newitem %{execute-keys o\item<space>}

}

hook global WinSetOption filetype=(?!latex).* %{
    remove-hooks global latex-compile
}
