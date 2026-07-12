# Resume

Karthik Badam's resume as code: content lives in [`content/resume.yaml`](content/resume.yaml),
a [Typst](https://typst.app) template renders it to a two-page, machine-readable PDF.

## Layout

- `content/resume.yaml` — all resume content (the only file to edit for text changes)
- `src/template.typ` — colors, fonts, and layout components
- `src/resume.typ` — document entry point (page structure)
- `fonts/` — vendored Inter fonts (SIL OFL 1.1, see `fonts/OFL.txt`)
- `build.py` / `Makefile` — build tooling
- `.github/workflows/build.yml` — CI: builds the PDF on every push (artifact) and
  attaches it to the release on `v*` tags

## Build

```sh
pip install typst
make pdf        # writes out/Badam_Resume.pdf
make png        # also renders per-page PNG previews
```

## Notes

- The PDF has a real text layer, document metadata, and clickable links, so it
  parses cleanly in ATS systems (`pdftotext` extracts everything in reading order).
- To re-theme, touch only `src/template.typ`; content and design are independent.
