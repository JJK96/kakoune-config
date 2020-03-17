define-command wordcount %{
    evaluate-commands %sh{
        words=$(echo "$kak_selection" | wc -w)
        echo info $words
    }
}
