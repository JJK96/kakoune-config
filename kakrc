# relative line numbers
add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ wrap

add-highlighter global/ show-matching

# indentation
set-option global tabstop     4
set-option global indentwidth 4

# keep space around cursor
set-option global scrolloff 10,10

# save on pressing enter
map global normal <ret> :w<ret>

# Select whole lines when moving selection with J or K
map global normal J J<a-x>
map global normal K K<a-x>

# vim old habits
map global normal D '<a-l>d' -docstring 'delete to end of line'
map global normal Y '<a-l>y' -docstring 'yank to end of line'
map global normal <a-h> Gi

# user mappings

map global user l -docstring 'lsp' ':enter-user-mode lsp<ret>'

## clipboard interaction
map global user p -docstring 'paste from clipboard' '!xsel -bo<ret>'
map global user y -docstring 'copy to clipboard' '<a-|>xsel -bi<ret>; :echo "copied selection to X11 clipboard"<ret>'
map global user d -docstring 'cut to clipboard' '|xsel -bi<ret>; :echo "copied selection to X11 clipboard"<ret>'

## comment lines
map global user c -docstring 'toggle comment lines' %{_:try comment-block catch comment-line<ret>}

# other mappings
map global normal x <a-x>
map global normal <a-x> gi<a-l>


# tab to select menu item.
hook global InsertCompletionShow .* %{
    map window insert <tab> <c-n>
    map window insert <s-tab> <c-p>
}

hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
}

# tabs to spaces
hook global InsertChar \t %{
    exec -draft h@
}

# hook global InsertKey <backspace> %{ try %{
#   exec -draft hGh<a-k>\A\h+\Z<ret>gihyp<lt>
# }}

# Terminal, used by ide wrapper
define-command terminal -params .. %{
  shell \
    -export session \
    -export client \
    %sh(echo $TERMINAL) %arg(@) \
    %sh(test $# = 0 &&
      echo $SHELL
    )
}


# Delete buffer and quit
define-command dq %{db;q}

# Open file in new window
define-command open-in-new-window -params 1 -file-completion %{ new edit %arg{@} }
alias global e open-in-new-window

# file types
hook global BufCreate .*\.xsd %{ set buffer filetype xml }

# kakoune language server

# Depends on https://github.com/ul/kak-lsp
eval %sh{kak-lsp1 --kakoune -s $kak_session }
# Debug output
nop %sh{ (kak-lsp1 -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }
lsp-enable
lsp-auto-hover-enable

# snippets
map global insert <a-E> ' <esc>;h: snippet-word<ret>'
map global insert <a-e> '<esc>: replace-next-hole<ret>'

#spell
map global user s -docstring 'spell replace' :spell-replace<ret>
declare-option str language en-GB
define-command spell-enable %{
    #hook global WinSetOption filetype=(latex|markdown|git-commit) %{
        hook window BufWritePost .* %{
            spell %opt{language}
        }
    #}
}

# Disable clippy

set-option global ui_options ncurses_assistant=off

# XML tags

map -docstring "xml tag object" global object t %{c<lt>([\w.]+)\b[^>]*?(?<lt>!/)>,<lt>/([\w.]+)\b[^>]*?(?<lt>!/)><ret>}

# modeline
set-option global modelinefmt %{{Error}%sh{[ $kak_opt_lsp_diagnostic_error_count -gt 0 ] && echo "$kak_opt_lsp_diagnostic_error_count"}{Default} %val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} - %val{client}@[%val{session}]}

# synonyms
# Depends on http://aiksaurus.sourceforge.net/
define-command synonyms %{ %sh{
    input=$(aiksaurus "$kak_selection")
    if echo "$input" | grep '\*\*\*.*\*\*\*' 2>&1 > /dev/null; then
        echo "info %{" "$(echo "$input" | head -n 2 )" "}"
    fi
    menu=$(echo "$input" | sed -e 's/ =/,/g;s/=//g' | \
    awk -v RS= -v FS=, '{
            printf "%s", "%{"$1"}" "%{menu -auto-single ";
            for (i=3; i<=NF; i++)
                printf "%s", "%{"$i"}" "%{execute-keys -itersel c"$i"<esc>be}";
            printf "%s", "}";
        }')
    printf 'menu -auto-single %s' "${menu}"
}}
map global user w -docstring 'get synonyms' :synonyms<ret>

source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/fzf.kak"

# plugin config
colorscheme gruvbox
set global snippet_files "%val{config}/snippets/snippets.yaml"

# fzf

map global user f -docstring 'Open fzf mode' %{: fzf-mode<ret>}
map global fzf g -docstring 'Open vcs mode' %{: fzf-vcs-mode<ret>}
