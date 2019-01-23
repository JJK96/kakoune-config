# Configuration options for markdown

# Compile to pdf or to html
declare-option -docstring "compile to pdf" bool markdown_pdf false
declare-option -docstring "store in tmp directory" bool markdown_tmp true

hook global WinSetOption filetype=markdown %{

# compile markdown in background on save.
hook window -group markdown-compile BufWritePost .* %{ nop %sh{ (
if $kak_opt_markdown_tmp; then
    dir="/tmp"
    filename="output"
else
    dir="${kak_buffile%/*}"
    filename="${kak_buffile##*/}"
    filename="${filename%.*}"
fi
if $kak_opt_markdown_pdf; then
    pandoc -o $dir/"$filename".pdf $kak_buffile && \
    pkill -HUP mupdf 
else
	pandoc -o $dir/"$filename".html $kak_buffile 
fi
) > /dev/null < /dev/null &}}

}

hook global WinSetOption filetype=(?!markdown).* %{
    remove-hooks window markdown-compile
}

