# Configuration options for markdown

# Compile to pdf or to html
declare-option bool pdf false

hook global WinSetOption filetype=markdown %{

# compile markdown in background on save.
hook window -group markdown-compile BufWritePost .* %{ nop %sh{ (
if $kak_opt_pdf; then
    pandoc -o /tmp/output.pdf $kak_buffile && \
    pkill -HUP mupdf 
else
	pandoc -o /tmp/output.html $kak_buffile 
fi
) > /dev/null 2>&1 < /dev/null &}}

}

hook global WinSetOption filetype=(?!markdown).* %{
    remove-hooks window markdown-compile
}

