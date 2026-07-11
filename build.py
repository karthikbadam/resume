#!/usr/bin/env python3
"""Build the resume PDF (and optional PNG previews) from src/resume.typ."""

import argparse
import pathlib
import sys

import typst

ROOT = pathlib.Path(__file__).parent
ENTRY = ROOT / "src" / "resume.typ"
OUT = ROOT / "out"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--png", action="store_true", help="also render per-page PNG previews")
    args = parser.parse_args()

    OUT.mkdir(exist_ok=True)
    typst.compile(
        ENTRY,
        output=OUT / "Badam_Resume.pdf",
        root=ROOT,
        font_paths=[ROOT / "fonts"],
    )
    print(f"wrote {OUT / 'Badam_Resume.pdf'}")

    if args.png:
        typst.compile(
            ENTRY,
            output=OUT / "Badam_Resume-{p}.png",
            root=ROOT,
            font_paths=[ROOT / "fonts"],
            format="png",
            ppi=150,
        )
        print(f"wrote {OUT}/Badam_Resume-*.png")
    return 0


if __name__ == "__main__":
    sys.exit(main())
