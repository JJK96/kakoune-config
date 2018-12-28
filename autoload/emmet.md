# Emmet.kak

A wrapper around [emmet-cli](https://github.com/Delapouite/emmet-cli) that uses [kakoune-snippets](https://github.com/occivink/kakoune-snippets) to process the snippets.

## Setup

Load `emmet.kak`
Make sure `emmet` is in your path


## Dependencies

- [emmet-cli](https://github.com/Delapouite/emmet-cli)
- [kakoune-snippets](https://github.com/occivink/kakoune-snippets)

## Usage

1. Enter a [valid emmet abbreviation](https://docs.emmet.io/abbreviations/syntax) into the buffer.
2. Select it.
3. run `:emmet`

You can also create mappings for ease of use, some examples:

To expand the current line:

`map global insert <a-e> "<esc>x: emmet<ret>"`
