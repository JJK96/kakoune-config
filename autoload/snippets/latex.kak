hook global WinSetOption filetype=(latex) %[
    set buffer snippets \
"begin"  %{ snippets-insert %{\begin{$1}
\end{$1}}} \
"matrix" %{ snippets-insert %{\left[\begin{matrix}
$1
\end{matrix}\right]}} \
"header" %{ snippets-insert %{-----
author: Jan-Jaap Korpershoek ($1)
title: $1
-----
}} \
"ss"     %{ snippets-insert %{\subsection*{$1}
}} \
"s"      %{ snippets-insert %{\section*{$1}
}} \
"align"  %{ snippets-insert %{\begin{align*}
$1
\end{align*}}} \
"mod"    %{ snippets-insert %{\text{ mod } $1}} \
"image"  %{ snippets-insert %{\begin{figure}
\includegraphics[width=\textwidth]{$1}
\caption{$2}
\end{figure}}}
]
