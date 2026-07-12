#!/usr/bin/env python3
"""Build the resume PDF (and optional PNG previews) from src/resume.typ."""

import argparse
import pathlib
import sys

import typst

ROOT = pathlib.Path(__file__).parent
ENTRY = ROOT / "src" / "resume.typ"
OUT = ROOT / "out"

# Candidate font pairings (display font for name/headings, body font for text).
VARIANTS = {
    "inter": {"display-font": "Space Grotesk", "body-font": "Inter"},
    "plex": {"display-font": "IBM Plex Sans", "body-font": "IBM Plex Sans"},
    "source": {"display-font": "Source Sans 3", "body-font": "Source Sans 3"},
    "figtree": {"display-font": "Figtree", "body-font": "Figtree"},
}


def compile(output, fonts=None, **kwargs):
    typst.compile(
        ENTRY,
        output=output,
        root=ROOT,
        font_paths=[ROOT / "fonts"],
        sys_inputs=fonts or {},
        **kwargs,
    )
    print(f"wrote {output}")


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--png", action="store_true", help="also render per-page PNG previews")
    parser.add_argument("--variants", action="store_true", help="build one PDF + page-1 PNG per font pairing")
    parser.add_argument("--font", choices=VARIANTS, default="inter", help="font pairing for the main build")
    args = parser.parse_args()

    OUT.mkdir(exist_ok=True)

    if args.variants:
        vdir = OUT / "variants"
        vdir.mkdir(exist_ok=True)
        for name, fonts in VARIANTS.items():
            compile(vdir / f"Badam_Resume_{name}.pdf", fonts=fonts)
            compile(vdir / (f"Badam_Resume_{name}" + "-{p}.png"), fonts=fonts, format="png", ppi=150)
        return 0

    fonts = VARIANTS[args.font]
    compile(OUT / "Badam_Resume.pdf", fonts=fonts)
    if args.png:
        compile(OUT / "Badam_Resume-{p}.png", fonts=fonts, format="png", ppi=150)
    return 0


if __name__ == "__main__":
    sys.exit(main())
