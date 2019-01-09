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

