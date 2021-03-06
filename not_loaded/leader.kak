# Not using this because counts are not forwarded, see https://github.com/mawww/kakoune/issues/2635
declare-user-mode leader

map global leader %{0}    %{<a-0>}
map global leader %{1}    %{<a-1>}
map global leader %{2}    %{<a-2>}
map global leader %{3}    %{<a-3>}
map global leader %{4}    %{<a-4>}
map global leader %{5}    %{<a-5>}
map global leader %{6}    %{<a-6>}
map global leader %{7}    %{<a-7>}
map global leader %{8}    %{<a-8>}
map global leader %{9}    %{<a-9>}
map global leader %{a}    %{<a-a>}
map global leader %{b}    %{<a-b>}
map global leader %{c}    %{<a-c>}
map global leader %{d}    %{<a-d>}
map global leader %{e}    %{<a-e>}
map global leader %{f}    %{<a-f>}
map global leader %{g}    %{<a-g>}
map global leader %{h}    %{<a-h>}
map global leader %{i}    %{<a-i>}
map global leader %{j}    %{<a-j>}
map global leader %{k}    %{<a-k>}
map global leader %{l}    %{<a-l>}
map global leader %{m}    %{<a-m>}
map global leader %{n}    %{<a-n>}
map global leader %{o}    %{<a-o>}
map global leader %{p}    %{<a-p>}
map global leader %{q}    %{<a-q>}
map global leader %{r}    %{<a-r>}
map global leader %{s}    %{<a-s>}
map global leader %{t}    %{<a-t>}
map global leader %{u}    %{<a-u>}
map global leader %{v}    %{<a-v>}
map global leader %{w}    %{<a-w>}
map global leader %{x}    %{<a-x>}
map global leader %{y}    %{<a-y>}
map global leader %{z}    %{<a-z>}
map global leader %{A}    %{<a-A>}
map global leader %{B}    %{<a-B>}
map global leader %{C}    %{<a-C>}
map global leader %{D}    %{<a-D>}
map global leader %{E}    %{<a-E>}
map global leader %{F}    %{<a-F>}
map global leader %{G}    %{<a-G>}
map global leader %{H}    %{<a-H>}
map global leader %{I}    %{<a-I>}
map global leader %{J}    %{<a-J>}
map global leader %{K}    %{<a-K>}
map global leader %{L}    %{<a-L>}
map global leader %{M}    %{<a-M>}
map global leader %{N}    %{<a-N>}
map global leader %{O}    %{<a-O>}
map global leader %{P}    %{<a-P>}
map global leader %{Q}    %{<a-Q>}
map global leader %{R}    %{<a-R>}
map global leader %{S}    %{<a-S>}
map global leader %{T}    %{<a-T>}
map global leader %{U}    %{<a-U>}
map global leader %{V}    %{<a-V>}
map global leader %{W}    %{<a-W>}
map global leader %{X}    %{<a-X>}
map global leader %{Y}    %{<a-Y>}
map global leader %{Z}    %{<a-Z>}
map global leader %{!}    %{<a-!>}
map global leader %{"}    %{<a-">}
map global leader %{#}    %{<a-#>}
map global leader %{$}    %{<a-$>}
map global leader %{%}    %{<a-%>}
map global leader %{&}    %{<a-&>}
map global leader %{'}    %{<a-'>}
map global leader %{(}    %{<a-(>}
map global leader %{)}    %{<a-)>}
map global leader %{*}    %{<a-*>}
map global leader %{+}    %{<a-+>}
map global leader %{,}    %{<a-,>}
map global leader %{.}    %{<a-.>}
map global leader %{/}    %{<a-/>}
map global leader %{:}    %{<a-:>}
map global leader %{;}    %{<a-;>}
map global leader %{<lt>} %{<a-lt>}
map global leader %{=}    %{<a-=>}
map global leader %{<gt>} %{<a-gt>}
map global leader %{?}    %{<a-?>}
map global leader %{@}    %{<a-@>}
map global leader %{[}    %{<a-[>}
map global leader %{\}    %{<a-\>}
map global leader %{]}    %{<a-]>}
map global leader %{^}    %{<a-^>}
map global leader %{_}    %{<a-_>}
map global leader %{`}    %{<a-`>}
map global leader %{|}    %{<a-|>}
map global leader %{~}    %{<a-~>}

map global normal <space> ': enter-user-mode leader<ret>'
map global leader <space> '<esc><space>'
map global leader . ': enter-user-mode -lock leader<ret>'
