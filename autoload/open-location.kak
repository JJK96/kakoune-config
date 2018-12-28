# Open the locatin indicated by a description such as `path_to_file:line:column`
# Where the `:column` is optional, for situations where only a line number is given.
# 
# This works at least with kak-lsp buffers and the `:grep` command.

define-command open-location %{
    execute-keys xs^.*?(:\d+){1,2}<ret>
    evaluate-commands %sh{
        echo "edit $kak_selection" | sed -e "s/:/ /g"
    }
}
