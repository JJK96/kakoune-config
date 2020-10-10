def -hidden basic-autoindent-on-newline %{
  eval -draft -itersel %{
    try %{ exec -draft ';K<a-&>' }                      # copy indentation from previous line
    try %{ exec -draft ';k<a-x><a-k>^\h+$<ret>H<a-d>' } # remove whitespace from autoindent on previous line
  }
}
def -hidden basic-autoindent-trim %{
  try %{ exec -draft '<a-x>' '1s^(\h+)$<ret>' '<a-d>' }
}
def basic-autoindent-enable %{
  hook -group basic-autoindent window InsertChar '\n' basic-autoindent-on-newline
  hook -group basic-autoindent window ModeChange 'pop:insert:normal' basic-autoindent-trim
  hook -group basic-autoindent window WinSetOption 'filetype=.*' basic-autoindent-disable
}
def basic-autoindent-disable %{ rmhooks window basic-autoindent }
