define-command show-color -docstring 'show main selection color in status bar' %{
  evaluate-commands %sh{
    awk_script='{
      if ((x=index($1,"#")) > 0)
        $1 = substr($1, x+1)
      if (length($1) == 8)
        $1 = substr($1, 1, 6)
      if (length($1) == 4)
        $1 = substr($1, 1, 3)
      if (length($1) == 3) {
        r = substr($1, 1, 1)
        g = substr($1, 2, 1)
        b = substr($1, 3, 1)
        $1 = r r g g b b
      }
      print "evaluate-commands -client " client " echo -markup {rgb:" $1 "} ██████"
    }'
    printf %s\\n "$kak_selection" | awk -v client="$kak_client" "$awk_script" | kak -p "$kak_session"
  }
}
