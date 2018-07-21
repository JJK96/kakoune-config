evaluate-commands %sh{
    bg='rgb:212733'
	line='rgb:151a1f'
	error='rgb:ff3333'
	gutter='rgb:35404c'
	selection='rgb:253340'
	stackGuide='rgb:1a2633'
	activeGuide='rgb:314559'
	tag='rgb:39bae6'
	function='rgb:ffb454'
	entity='rgb:59c2ff'
	string='rgb:c2d94c'
	regexp='rgb:95e6cb'
	markup='rgb:f07178'
	keyword='rgb:ff7733'
	special='rgb:e6b673'
	comment='rgb:5c6773'
	constant='rgb:ffee99'
	operator='rgb:f29668'
    fg='rgb:d9d7ce'
    fg_idle='rgb:607080'
    accent='rgb:ffcc66'
    panel='rgb:272d38'
    guide='rgb:3d4751'

    echo "
        # Code highlighting
        face global value     ${constant}
        face global type      ${tag}+b
        face global variable  ${fg}
        face global module    ${tag}
        face global function  ${function}
        face global string    ${string}
        face global keyword   ${keyword}
        face global operator  ${operator}
        face global attribute ${keyword}
        face global comment   ${comment}
        face global meta      ${comment}
        face global builtin   ${function}+b

        # Markdown highlighting
        face global title     ${function}+b
        face global header    ${tag}
        face global bold      ${fg}+b
        face global italic    ${fg}+i
        face global mono      ${fg}
        face global block     default
        face global link      default
        face global bullet    default
        face global list      default

    	# builtin
        face global Error              default,${error}
        face global Information        ${bg},${fg}
        face global LineNumberCursor   ${line},${accent}
        face global LineNumbers        ${guide},${bg}
        face global MatchingChar       default,${bg}
        face global MenuBackground     default,${panel}
        face global MenuForeground     ${panel},${fg}
        face global MenuInfo           ${bg}
        face global PrimaryCursor      ${bg},${fg}
        face global PrimaryCursorEol   ${bg},${fg}
        face global PrimarySelection   ${fg},${selection}
        face global Prompt             ${accent}
        face global SecondaryCursor    ${bg},${fg}
        face global SecondaryCursorEol ${bg},${fg}
        face global SecondarySelection ${bg},${selection}
        face global StatusCursor       ${bg},${fg}
        face global StatusLine         ${fg},${panel}
        face global StatusLineInfo     ${tag}
        face global StatusLineMode     ${accent}+b
        face global StatusLineValue    ${error}
    "
}
