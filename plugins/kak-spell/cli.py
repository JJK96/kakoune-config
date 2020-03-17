#!/usr/bin/env python3
from typing import List, Optional
import argparse
import sys

from path import Path

from checker import Checker


def add_word(word: str, *, lang: str) -> None:
    checker = Checker(lang=lang)
    checker.add(word)
    print("Word added to", checker.pwl_path)


def remove_word(word: str, *, lang: str) -> None:
    checker = Checker(lang=lang)
    checker.remove(word)
    print("Word removed from", checker.pwl_path)


def check(path: Path, *, lang: str, filetype: Optional[str] = None) -> bool:
    checker = Checker(lang=lang)
    errors = checker.check(path, filetype=filetype)
    ok = True
    for error in errors:
        ok = False
        print(f"{path}:{error.line}:{error.offset}: error: {error.word}")
    return ok


def kak_menu_from_replacements(replacements: List[str]) -> str:
    menu = ""
    for entry in replacements:
        # Note: %{...} is kakoune way of grouping stuff that may - or not
        # contains quotes, which prevents us from using `%`, `.format()` or
        # f-strings :P
        menu_entry = "%{ENTRY} %{execute-keys -itersel %{cENTRY<esc>be}}"
        menu_entry = menu_entry.replace("ENTRY", entry)
        menu += " " + menu_entry
    return "menu " + menu


def replace(word: str, *, lang: str, kak_output: bool) -> None:
    checker = Checker(lang=lang)
    replacements = checker.replace(word)
    if kak_output:
        menu = kak_menu_from_replacements(replacements)
        print(menu)
    else:
        print(" ".join(replacements))


def main(argv: Optional[List[str]] = None) -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--lang", default="en_US")

    subparsers = parser.add_subparsers(title="commands", dest="command")

    check_parser = subparsers.add_parser("check")
    check_parser.add_argument("path", type=Path)
    check_parser.add_argument(
        "--filetype", help="file type, as set by kakoune in $kak_opt_filetype"
    )

    add_parser = subparsers.add_parser("add")
    add_parser.add_argument("word")

    remove_parser = subparsers.add_parser("remove")
    remove_parser.add_argument("word")

    replace_parser = subparsers.add_parser("replace")
    replace_parser.add_argument(
        "--kakoune", action="store_true", help="Output kak-script compatible output"
    )
    replace_parser.add_argument("word")

    args = parser.parse_args(args=argv)
    lang = args.lang

    if args.command == "add":
        word = args.word
        add_word(word, lang=lang)
    elif args.command == "remove":
        word = args.word
        remove_word(word, lang=lang)
    elif args.command == "check":
        path = args.path
        ok = check(path, lang=lang, filetype=args.filetype)
        if not ok:
            sys.exit(1)
    elif args.command == "replace":
        word = args.word
        kakoune = args.kakoune
        replace(word, lang=lang, kak_output=kakoune)
    else:
        parser.print_help()
        sys.exit(1)


if __name__ == "__main__":
    main()
