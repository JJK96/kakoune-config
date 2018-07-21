colorscheme gruvbox

# relative line numbers
add-highlighter global/ number-lines -relative
add-highlighter global/ wrap

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

# clipboard interaction
map global user p -docstring 'paste from clipboard' '!xsel -bo<ret>'
map global user y -docstring 'copy to clipboard' '<a-|>xsel -bi<ret>; :echo "copied selection to X11 clipboard"<ret>'
map global user d -docstring 'cut to clipboard' '|xsel -bi<ret>; :echo "copied selection to X11 clipboard"<ret>'

# other mappings
map global normal x <a-x>
map global normal <a-x> gi<a-l>

# comment lines
map global normal <a-m> %{_:comment-block<ret>}

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

hook global InsertKey <backspace> %{ try %{
  exec -draft hGh<a-k>\A\h+\Z<ret>gihyp<lt>
}}

# Open file in new window
define-command open-in-new-window -params 1 -file-completion %{ new edit %arg{@} }
alias global e open-in-new-window

# file types
hook global BufCreate .*\.xsd %{ set buffer filetype xml }

#connect to kakoune language server
eval %sh{kak-lsp --kakoune -s $kak_session }
#nop %sh{ (kak-lsp1 -s $kak_session -vvv ) > /tmp/kak-lsp.log 2>&1 < /dev/null & }
lsp-auto-hover-enable

# snippets
map global insert <a-E> '<esc>: try replace-next-hole catch snippet-word<ret>'

#spell
map global user s -docstring 'spell replace' :spell-replace<ret>
declare-option str language en-GB
hook global WinSetOption filetype=(latex|markdown|git-commit) %{
    hook window BufWritePost .* %{
        spell %opt{language}
    }
}

# Disable clippy

set-option global ui_options ncurses_assistant=off

# XML tags

map global object t -docstring 'xml tag' %{c<lt>.*?<gt>,<lt>/.*?<gt><ret>}

# better indentation

hook global WinSetOption filetype=(p4|php) %[
    hook -group c-family-indent window ModeChange insert:.* c-family-trim-autoindent
    hook -group c-family-insert window InsertChar \n c-family-insert-on-newline
    hook -group c-family-indent window InsertChar \n c-family-indent-on-newline
    hook -group c-family-indent window InsertChar \{ c-family-indent-on-opening-curly-brace
    hook -group c-family-indent window InsertChar \} c-family-indent-on-closing-curly-brace
    hook -group c-family-insert window InsertChar \} c-family-insert-on-closing-curly-brace
]

# rust

hook global WinSetOption filetype=(rust) %[
    set-option buffer formatcmd rustfmt
]

# synonyms

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

# autoload files in rc directory

evaluate-commands %sh{
    autoload_directory() {
        find -L "$1" -type f -name '*\.kak' \
            -exec printf 'try %%{ source "%s" } catch %%{ echo -debug Autoload: could not load "%s" }\n' '{}' '{}' \;
    }
    autoload_directory ${kak_config}/rc
}
