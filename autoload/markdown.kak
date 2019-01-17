# Configuration options for markdown

# Compile to pdf or to html
declare-option -docstring "compile to pdf" bool markdown_pdf false
declare-option -docstring "store in tmp directory" bool markdown_tmp true

hook global WinSetOption filetype=markdown %{

# compile markdown in background on save.
hook window -group markdown-compile BufWritePost .* %{ nop %sh{ (
if $kak_opt_markdown_tmp; then
    dir="/tmp"
else
    dir="${kak_buffile%/*}/"
fi
if $kak_opt_markdown_pdf; then
    pandoc -o $dir/output.pdf $kak_buffile && \
    pkill -HUP mupdf 
else
	pandoc -o $dir/output.html $kak_buffile 
fi
) > /dev/null 2>&1 < /dev/null &}}

}

hook global WinSetOption filetype=(?!markdown).* %{
    remove-hooks window markdown-compile
}

