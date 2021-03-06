# Swap word and WORD commands
# map global normal e <a-e>
# map global normal E <a-E>
# map global normal <a-e> e
# map global normal <a-E> E
# map global normal w <a-w>
# map global normal W <a-W>
# map global normal <a-w> w
# map global normal <a-W> W
# map global normal b <a-b>
# map global normal B <a-B>
# map global normal <a-b> b
# map global normal <a-B> B

# Select whole lines when moving selection with J or K
map global normal J J<a-x>
map global normal K K<a-x>

# Make I insert before every line
map global normal I "<a-s>I"
# Make A insert after every line
map global normal A "<a-s>A"

# Swap escape and comma
map global normal , <space>
map global normal <a-,> <a-space>
map global normal <space> ,
map global normal <backspace> <space>
map global normal <a-backspace> <a-space>

# swap f and d
map global normal <c-d> <c-f>
map global normal <c-f> <c-d>

# Give []{} a useful purpose
# map global normal [ <c-u>
# map global normal ] <c-d>
# map global normal { 10k
# map global normal } 10j

# Better x
map global normal x <a-x>
map global normal <a-x> gi<a-l>
