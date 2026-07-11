// Styling and components for the resume. Content lives in content/resume.yaml.

// Palette: near-black slate ink, pure blue accent, cool grays.
#let ink = rgb("#0f172a")
#let accent = rgb("#0071e3")
#let muted = rgb("#475569")
#let hairline = rgb("#e2e8f0")
#let panel = rgb("#f1f5f9")

// Font pairing is overridable per build: --input body-font=... --input display-font=...
#let body-font = sys.inputs.at("body-font", default: "Inter")
#let display-font = sys.inputs.at("display-font", default: "Space Grotesk")

#let base-size = 9pt
#let period-col = 58pt

// --- Small helpers ---------------------------------------------------------

#let caps-label(body, fill: ink, size: 0.8em) = text(
  font: display-font,
  size: size,
  weight: 600,
  tracking: 0.1em,
  fill: fill,
  upper(body),
)

// Section header: spaced-caps title with a hairline filling the rest of the row.
// More space above than below, so the header binds to its own content.
#let section(title) = {
  v(10pt)
  grid(
    columns: (auto, 1fr),
    column-gutter: 10pt,
    align: horizon,
    caps-label(title, size: 0.86em),
    line(length: 100%, stroke: 0.5pt + hairline),
  )
  v(2pt)
}

// Sidebar group: items flow two per row; long items span the full width.
// Profile links get one per row (wide: true).
#let sidebar-group(title, items, wide: false) = {
  caps-label(title, fill: accent, size: 0.78em)
  v(-3pt)
  if wide {
    stack(spacing: 4.5pt, ..items)
  } else {
    // Pack adjacent short items into pairs; long items take a full row.
    let cells = ()
    let pending = none
    for i in items {
      if i.len() > 11 {
        if pending != none { cells.push(grid.cell(colspan: 2, pending)); pending = none }
        cells.push(grid.cell(colspan: 2, i))
      } else if pending == none {
        pending = i
      } else {
        cells.push(grid.cell(pending))
        cells.push(grid.cell(i))
        pending = none
      }
    }
    if pending != none { cells.push(grid.cell(colspan: 2, pending)) }
    grid(
      columns: (1fr, 1fr),
      column-gutter: 6pt,
      row-gutter: 4.5pt,
      ..cells,
    )
  }
  v(10pt)
}

// A dated entry: muted period on the left, content on the right.
#let entry(period, body) = grid(
  columns: (period-col, 1fr),
  column-gutter: 12pt,
  text(size: 0.88em, fill: muted, number-type: "lining", period),
  body,
)

#let entry-heading(title, detail) = grid(
  columns: (auto, 1fr),
  column-gutter: 8pt,
  text(weight: 600, size: 1.02em, title),
  align(right, text(size: 0.88em, fill: muted, detail)),
)

// Markerless "bullets": plain statements separated by whitespace.
// Gaps stay clearly smaller than the between-entry spacing so entries group.
#let bullets(items) = stack(spacing: 6pt, ..items)

// --- Sections ---------------------------------------------------------------

#let education-section(education) = {
  section[Education]
  stack(
    spacing: 10pt,
    ..education.map(e => entry(e.period)[
      #entry-heading(e.degree, [#e.school · #e.location])
      #v(-4pt)
      #text(size: 0.92em, fill: muted, e.note)
    ]),
  )
}

#let experience-section(experience) = {
  section[Professional Experience]
  stack(
    spacing: 13pt,
    ..experience.map(e => entry(e.period)[
      #entry-heading(e.company, e.location)
      #v(-4pt)
      #text(weight: 500, size: 0.94em, fill: muted, e.title)
      #v(-3pt)
      #bullets(e.bullets)
    ]),
  )
}

#let projects-section(projects) = {
  section[Featured Projects]
  stack(
    spacing: 12pt,
    ..projects.map(p => block[
      #grid(
        columns: (auto, 1fr),
        column-gutter: 10pt,
        align: (left + bottom, right + bottom),
        [#text(weight: 600, size: 1.02em, p.name)#text(size: 0.92em, [ · #p.org])],
        text(size: 0.86em, weight: 500, fill: accent, p.stack.join("\u{a0}· ")),
      )
      #v(-3pt)
      #text(size: 0.96em)[
        #p.description
        #if "contributions" in p [
          #text(weight: 600)[Contributions:] #p.contributions
        ]
      ]
    ]),
  )
}

#let publications-section(publications) = {
  section[Notable Publications]
  stack(
    spacing: 8pt,
    ..publications.map(p => grid(
      columns: (20pt, 1fr),
      column-gutter: 8pt,
      text(font: display-font, weight: 600, size: 0.9em, fill: accent, p.id),
      text(size: 0.96em)[
        #p.text
        #if "note" in p [ #text(weight: 600)[#p.note]]
      ],
    )),
  )
}

#let service-section(service) = {
  section[Service]
  bullets(service.map(s => text(size: 0.96em, s)))
}

// --- Page furniture ----------------------------------------------------------

// Header: name on the left, contact stacked on the right.
#let header-block(basics) = grid(
  columns: (1fr, auto),
  align: (left + bottom, right + bottom),
  {
    text(font: display-font, size: 27pt, weight: 500, tracking: -0.02em, basics.first_name)
    h(7pt)
    text(font: display-font, size: 27pt, weight: 700, tracking: -0.02em, fill: accent, basics.last_name)
  },
  text(size: 0.92em, fill: muted)[
    #link(basics.website_url)[#basics.website] #h(3pt)|#h(3pt) #link("mailto:" + basics.email)[#basics.email] \
    #basics.location
  ],
)

#let sidebar(basics, profiles, skills) = {
  set text(size: 0.94em)
  set par(justify: false)
  sidebar-group("Profiles", profiles.map(p => link(p.url)[#p.label]), wide: true)
  for group in skills {
    sidebar-group(group.group, group.items)
  }
}

// --- Document shell -----------------------------------------------------------

#let resume(data, body) = {
  set document(
    title: data.basics.first_name + " " + data.basics.last_name + " – Resume",
    author: data.basics.first_name + " " + data.basics.last_name,
    keywords: data.basics.keywords.join(", "),
  )
  set page(
    paper: "us-letter",
    margin: (x: 1.3cm, top: 1.2cm, bottom: 1.4cm),
    footer: align(center, text(size: 8pt, fill: muted, context counter(page).display("1 / 1", both: true))),
  )
  set text(font: body-font, size: base-size, fill: ink, tracking: -0.006em)
  set par(justify: true, leading: 0.62em)
  show link: set text(fill: ink)
  body
}
