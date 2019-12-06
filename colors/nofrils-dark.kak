evaluate-commands %sh{
    base_text="rgb:eeeeee"
    color1="rgb:d7afff"
    color2="rgb:d7ffff"
    dark="rgb:6c6c6c"
    echo "
        # For Code
        face global attribute $base_text
        face global builtin $base_text
        face global comment $dark
        face global function $base_text
        face global keyword $base_text
        face global meta $base_text
        face global module $base_text
        face global operator $base_text
        face global string $base_text,rgb:000000
        face global type $base_text
        face global value $base_text
        face global variable $base_text
        face global identifier $base_text

        # For markup
        face global block $base_text
        face global bold $base_text
        face global bullet $base_text
        face global header $base_text
        face global italic $base_text
        face global link $base_text
        face global list $base_text
        face global mono $base_text
        face global title $base_text

        # builtin faces
        face global Error $base_text,rgb:ff0000
        face global Information $color1,rgb:000000
        face global LineNumberCursor rgb:000000,$color1
        face global LineNumbers $dark,default
        face global LineNumbersWrapped rgb:262626,rgb:262626
        face global MatchingChar rgb:ffffd7,rgb:000000
        face global MenuForeground rgb:000000,rgb:d7ffaf
        face global MenuBackground rgb:d7ffaf,rgb:000000
        face global MenuInfo rgb:000000
        face global PrimaryCursor rgb:000000,$color1+u
        face global PrimarySelection rgb:000000,rgb:ffd787
        face global Prompt rgb:000000,$color1
        face global SecondaryCursor rgb:000000,$color1
        face global SecondarySelection rgb:000000,$color2
        face global StatusCursor $color2,rgb:8888cc
        face global StatusLine $color2,rgb:000000
        face global StatusLineInfo rgb:eaffff,rgb:000000
        face global StatusLineMode $color1,rgb:000000
        face global StatusLineValue $color1,rgb:000000
        face global Whitespace $dark,default
    "
}
