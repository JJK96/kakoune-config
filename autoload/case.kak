# foo_bar → fooBar
# foo-bar → fooBar
# foo bar → fooBar
def camelcase %{
  exec '`s[-_<space>]<ret>d~<a-i>w'
}

# fooBar → foo_bar
# foo-bar → foo_bar
# foo bar → foo_bar
def snakecase %{
  exec '<a-:><a-;>s-|[a-z][A-Z]<ret>;a<space><esc>s[-\s]+<ret>c_<esc><a-i>w`'
}

# fooBar → foo-bar
# foo_bar → foo-bar
# foo bar → foo-bar
def kebabcase %{
  exec '<a-:><a-;>s_|[a-z][A-Z]<ret>;a<space><esc>s[_\s]+<ret>c-<esc><a-i>w`'
}

def -hidden select-prev-word-part %{
  exec <a-/>[A-Z][a-z]+|[A-Z]+|[a-z]+<ret>
}
def -hidden select-next-word-part %{
  exec /[A-Z][a-z]+|[A-Z]+|[a-z]+<ret>
}
def -hidden extend-prev-word-part %{
  exec <a-?>[A-Z][a-z]+|[A-Z]+|[a-z]+<ret>
}
def -hidden extend-next-word-part %{
  exec ?[A-Z][a-z]+|[A-Z]+|[a-z]+<ret>
}

declare-user-mode movecase
map global movecase w -docstring 'move to next camelcase' ': select-next-word-part<ret>'
map global movecase W -docstring 'extend to next camelcase' ': extend-next-word-part<ret>'
map global movecase b -docstring 'move to previous camelcase' ': select-prev-word-part<ret>'
map global movecase B -docstring 'extend to previous camelcase' ': extend-prev-word-part<ret>'
