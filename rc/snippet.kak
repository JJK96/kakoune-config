# Snippets
# Based on: https://github.com/shachaf/kak/blob/master/scripts/snippet.kak
# Adaptations have been made by me

# TODO: Maybe let snippets use %opt{indentwidth} or something to indent correctly?

declare-option -docstring %{
  A snippet program that should take a snippet file and optional snippet name, and:
    * Print a list of snippet names (for completion) when run with no snippet name.
    * Return 0 and print a snippet when run with a valid snippet name.
    * Return 1 when run with an invalid snippet name.} \
  str snippet_program

declare-option -docstring 'path to snippet file' \
  str snippet_file

declare-option -docstring 'search pattern for snippet holes' \
  str snippet_hole_pattern '\$\d+'

def replace-next-hole %{
  eval -save-regs 'ab/' %{
    try %{
      exec '"aZ'
      reg / %opt{snippet_hole_pattern}
      exec '<space>h/<ret>'
      exec -save-regs '' %{<a-*>"aZ%s<ret>"bZ"az"b<a-z>a}
      exec -with-hooks '<a-c>'
    } catch %{
      exec '"az'
      fail 'No holes found.'
    }
  }
}
def select-word \
  -docstring 'select a word which can later be be used to :snippet or :emmet' \
%{
    execute-keys '<esc><a-?>\h+|^<ret>'
}


def snippet-word \
  -docstring ':snippet the selected word' \
  %{
  eval -save-regs 'ab' %{
    try %{
      exec '"aZ'
      select-word
      exec '_"by' # trim and copy word
      exec "$%opt{snippet_program} '%opt{snippet_file}' '%reg{b}'<ret>" # abort if not valid snippet
      exec '<a-d>' # delete snippet name
      snippet "%reg{b}" # If there are multiple cursors, we assume they're all on the same snippet.
    } catch %{
      exec '"az'
      exec -with-hooks i
      fail "not a snippet"
    }
  }
}

def snippet \
  -docstring %{Insert snippet at cursor and start typing at first hole.} -params 1 \
  -shell-candidates %{ "$kak_opt_snippet_program" "$kak_opt_snippet_file" } %{
  eval -save-regs '|abc' %{
    try %{
      exec "!%opt{snippet_program} '%opt{snippet_file}' '%arg{1}'<ret>" 'uU' # insert and select snippet
      exec '<a-;><a-s>)"aZ "bZgi"b<a-z>u<a-;>"a<a-z>a&' # fix indentation
      exec 'h'
      replace-next-hole
    }
  }
}

hook global WinSetOption filetype=(html|xml) %[
    # calls to emmet-cli
    # Depends on ../bin/emmet-call
    define-command emmet %{
        execute-keys "<esc>x|%val{config}/bin/emmet-call<ret>"
        execute-keys "<esc>uU)<a-;> ;: replace-next-hole<ret>"
    }
    map global insert <a-E> ' <esc>;h: try snippet-word catch emmet<ret>'
    map global insert <a-e> '<esc>: replace-next-hole<ret>'
]


set global snippet_program "%val{config}/bin/snippet"
set global snippet_file "%val{config}/snippets.yaml"
set global snippet_hole_pattern %{\$\d+|\$\{\d+(:\w+)?\}|[⁰¹²³⁴⁵⁶⁷💙💚💛💜💝💟🧡]}
hook global WinCreate .* %{
addhl window/SnippetHole \
  regex (¹)|(²)|(³)|(⁴)|(⁵)|(⁶)|(⁷) \
  1:default,red \
  2:default,rgb:FF8000 \
  3:default,yellow \
  4:default,green \
  5:default,blue \
  6:default,rgb:6F00FF \
  7:default,rgb:9F00FF
}
