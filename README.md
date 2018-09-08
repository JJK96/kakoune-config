# Kakoune configuration

[Kakoune](https://github.com/mawww/kakoune)


# Contact

Feel free to create an issue if you have questions on how to use some stuff

# Files

|File/folder  |Description                    |
|-------------|-------------------------------|
|bin          | Scripts                       |
|colors       | Colorschemes                  |
|rc           | .kak files sourced by kakrc   |
|kakrc        | main configuration file       |
|snippets.yaml| snippets used by snippets.kak |

See the individual files for more explanations

# Snippets

I have combined [emmet-cli](https://github.com/Delapouite/emmet-cli) with [snippets](https://github.com/shachaf/kak/blob/master/scripts/snippet.kak). This works with any text that contains snippet holes.

[asciicast](https://asciinema.org/a/BFUqP7Ho1c0Ts6oManSIUMwqG)

I use `\$\d+|\$\{\d+(:\w+)?\}` as the regex for the holes, but this can be adapted in the `rc/snippets.kak` file

So it fits holes like `$0` or `${1:test}`

## Setup

make kakoune source
`rc/snippets.kak`

Note: `rc/snippets.kak` adds mappings that call emmet-cli if the filetype is html, you might want to adapt that behaviour to your likings.

Add this mapping to your kakrc
`map global insert <a-e> '<esc>: replace-next-hole<ret>'`

### Snippets from snippets.yaml

Add `bin/snippet` to `%val{config}/bin`

Add this mapping to your kakrc
`map global insert <a-E> ' <esc>;h: snippet-word<ret>'`

### Emmet support

Install [my fork of emmet-cli](https://github.com/JJK96/emmet-cli).

Add `bin/emmet-call` to `%val{config}/bin`


