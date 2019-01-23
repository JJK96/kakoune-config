# relative line numbers
add-highlighter global/ number-lines -relative -hlcursor
add-highlighter global/ wrap

add-highlighter global/ show-matching

# Disable clippy
set-option global ui_options ncurses_assistant=off

# indentation
set-option global tabstop     4
set-option global indentwidth 4

# keep space around cursor
set-option global scrolloff 10,10

# save on pressing enter
map global normal <ret> ": w<ret>"

# remap grep-jump
map global goto <ret> "<esc><ret>"

# vim old habits
map global normal D '<a-l>d' -docstring 'delete to end of line'
map global normal Y '<a-l>y' -docstring 'yank to end of line'
map global normal <a-h> Gi

# case insensitive search
map global prompt <a-i> "<home>(?i)<end>"

# calculate
map global normal = '|calc<ret>'

# Movement mode (depends on case.kak)
map global user m -docstring "case based movement" ': enter-user-mode -lock movecase<ret>'

# user mappings
map global user l -docstring 'lsp' ': enter-user-mode lsp<ret>'

## clipboard interaction
map global user p -docstring 'paste from clipboard' '!xsel -bo<ret>'
map global user y -docstring 'copy to clipboard' '<a-|>xsel -bi<ret>; : echo "copied selection to X11 clipboard"<ret>'
map global user d -docstring 'cut to clipboard' '|xsel -bi<ret>; : echo "copied selection to X11 clipboard"<ret>'

## comment lines
map global user c -docstring 'toggle comment lines' %{_: try comment-block catch comment-line<ret>}

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

# Use termite
set global termcmd "termite -e"

# Terminal, used by ide wrapper
define-command -hidden _terminal -params .. %{
  shell \
    -export session \
    -export client \
    %sh(echo $TERMINAL) %arg(@) \
    %sh(test $# = 0 &&
      echo $SHELL
    )
}

# Delete buffer and quit
define-command -hidden _q %{db;quit}
define-command -hidden _wq %{w;_q}
alias global q _q
alias global wq _wq
map global normal <c-q> ": _q<ret>"

# Open file in new window
define-command open-in-new-window -params .. -file-completion %{ new edit %arg{@} }
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

#spell
# map global user s -docstring 'spell replace' :spell-replace<ret>
declare-option str language en-GB
define-command spell-enable %{
    #hook global WinSetOption filetype=(latex|markdown|git-commit) %{
        hook window BufWritePost .* %{
            spell %opt{language}
        }
    #}
}

# XML tags

map -docstring "xml tag object" global object t %{c<lt>([\w.]+)\b[^>]*?(?<lt>!/)>,<lt>/([\w.]+)\b[^>]*?(?<lt>!/)><ret>}

# modeline
set-option global modelinefmt %{{Error}%sh{[ $kak_opt_lsp_diagnostic_error_count -gt 0 ] && echo "$kak_opt_lsp_diagnostic_error_count"}{Default} %val{bufname} %val{cursor_line}:%val{cursor_char_column} {{context_info}} {{mode_info}} - %val{client}@[%val{session}]}

# Plugins

source "%val{config}/plugins/plug.kak/rc/plug.kak"
plug "andreyorst/plug.kak" noload
plug "andreyorst/fzf.kak" %{
    map global user f -docstring 'Open fzf mode' %{: fzf-mode<ret>}
    map global fzf g -docstring 'Open vcs mode' %{: fzf-vcs-mode<ret>}
}
plug "occivink/kakoune-phantom-selection" %{
    declare-user-mode phantom-selection
    map global user h -docstring "Phantom selections" ": enter-user-mode phantom-selection<ret>"
    map global phantom-selection n -docstring "Next" ": phantom-sel-iterate-next<ret>"
    map global phantom-selection p -docstring "Previous" ": phantom-sel-iterate-prev<ret>"
    map global phantom-selection c -docstring "Clear" ": phantom-sel-select-all; phantom-sel-clear<ret>"
    map global phantom-selection a -docstring "Add" ": phantom-sel-add-selection<ret>"
}
plug "occivink/kakoune-snippets" %{
    set-option global snippets_auto_expand false
    declare-user-mode snippets
    map global user s -docstring "Snippets" ": enter-user-mode snippets<ret>"
    map global snippets n -docstring "Select next placeholder" ": snippets-select-next-placeholders<ret>"
    map global snippets s -docstring "Snippet" ": snippets "
    map global snippets i -docstring "Info" ": snippets-info<ret>"
    map global insert <a-e> "<esc>: try snippets-select-next-placeholders catch phantom-sel-iterate-next<ret>i"
    add-highlighter global/ ranges snippets_placeholders 
    source "%val{config}/snippets.kak"
}
    
plug "occivink/kakoune-sudo-write"
plug "jjk96/kakoune-fireplace"
plug "lenormf/kakoune-extra" load %{
    #syntastic.kak
}
plug "alexherbo2/select.kak" %{
    plug "alexherbo2/yank-ring.kak" %{
        map global normal <c-p> ":<space>yank-ring-previous<ret>"
        map global normal <c-n> ":<space>yank-ring-next<ret>"
    }
}
plug "Delapouite/kakoune-buffers" %{
    map global user b ': enter-user-mode -lock buffers<ret>'   -docstring 'buffers (lock)…'
}
plug "ul/kak-tree" %{
    declare-user-mode tree
    map global tree u ': tree-select-parent-node<ret>' -docstring 'parent'
    map global tree n ': tree-select-next-node<ret>' -docstring 'next'
    map global tree p ': tree-select-previous-node<ret>' -docstring 'previous'
    map global tree c ': tree-select-children<ret>' -docstring 'children'
    map global tree f ': tree-select-first-child<ret>' -docstring 'first child'
    map global tree t ': tree-node-sexp<ret>' -docstring 'show syntax tree'
    map global tree . ': enter-user-mode -lock tree<ret>' -docstring 'lock'
    map global user t ': enter-user-mode tree<ret>' -docstring 'tree-sitter'
}
plug 'delapouite/kakoune-cd' %{
    # Suggested aliases
    alias global cdb change-directory-current-buffer
    alias global cdr change-directory-project-root
    alias global ecd edit-current-buffer-directory
    alias global pwd print-working-directory
}
plug 'Delapouite/kakoune-mirror' %{
    map global user o -docstring 'mirror' ': enter-user-mode mirror<ret>'
    map global mirror . ': enter-user-mode -lock mirror<ret>'
}

# Overwrites colors defined in kak-lsp
colorscheme gruvbox
