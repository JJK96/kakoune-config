from typing import Any, Callable, Dict, Iterator, List, Optional, Tuple
import attr
import enchant
import enchant.checker
from enchant.tokenize import Filter
from path import Path
import re
import xdg.BaseDirectory

NumberedLine = Tuple[int, str]
LinesGetter = Callable[[Path], Iterator[NumberedLine]]

SCISSORS = "# ------------------------ >8 ------------------------\n"


def get_lines_git_commit(path: Path) -> Iterator[NumberedLine]:
    with path.open() as f:
        for lineno, line in enumerate(f, start=1):
            if line == SCISSORS:
                break
            if line.startswith("#"):
                continue
            yield lineno, line


def get_lines_unknown_type(path: Path) -> Iterator[NumberedLine]:
    with path.open() as f:
        for lineno, line in enumerate(f, start=1):
            yield lineno, line


KNOWN_FILETYPES: Dict[str, LinesGetter] = {"git-commit": get_lines_git_commit}


@attr.s
class Error:
    path: Path = attr.ib()
    line: int = attr.ib()
    offset: int = attr.ib()
    word: str = attr.ib()


def get_pwl_path(lang: str) -> Path:
    data_path = Path(xdg.BaseDirectory.save_data_path("kak-spell"))
    data_path.makedirs_p()
    pwl_path = data_path / f"{lang}.pwl"
    if not pwl_path.exists():
        pwl_path.write_text("")
    return pwl_path


def get_lines(path: Path, filetype: Optional[str] = None) -> Iterator[NumberedLine]:
    default_func = get_lines_unknown_type
    if filetype:
        func = KNOWN_FILETYPES.get(filetype, default_func)
    else:
        func = default_func
    yield from func(path)


class UrlFilter(Filter):  # type: ignore
    r"""Filter skipping over urls
    """
    _pattern = re.compile(r"(\w+)://\S+")

    def _skip(self, word: str) -> bool:
        if self._pattern.match(word):
            return True
        return False


def get_filters() -> List[Filter]:
    return [UrlFilter]


def is_inside_backticks(text: str, error: Any) -> bool:
    pos = error.wordpos
    start = pos - 1
    end = pos + len(error.word)
    return text[start] == "`" and text[end] == "`"


class Checker:
    def __init__(self, *, lang: str):
        self.pwl_path = get_pwl_path(lang)
        dict_with_pwl = enchant.DictWithPWL(lang, str(self.pwl_path))
        self._checker = enchant.checker.SpellChecker(lang, filters=get_filters())
        self._checker.dict = dict_with_pwl

    def check(self, path: Path, filetype: Optional[str] = None) -> Iterator[Error]:
        for lineno, line in get_lines(path, filetype=filetype):
            self._checker.set_text(line)
            for error in self._checker:
                if filetype == "markdown" and is_inside_backticks(line, error):
                    continue
                yield Error(path, lineno, error.wordpos + 1, error.word)

    def add(self, word: str) -> None:
        words = set(self.pwl_path.lines(retain=False))
        words.add(word)
        self.pwl_path.write_lines(sorted(words))

    def remove(self, word: str) -> None:
        words = set(self.pwl_path.lines(retain=False))
        words.discard(word)
        self.pwl_path.write_lines(sorted(words))

    def replace(self, word: str) -> List[str]:
        return self._checker.suggest(word)  # type: ignore
