// Styling and components for the resume. Content lives in content/resume.yaml.

// Palette: near-black slate ink, vivid blue accent, cool grays.
#let ink = rgb("#0f172a")
#let accent = rgb("#2563eb")
#let muted = rgb("#64748b")
#let hairline = rgb("#e2e8f0")
#let panel = rgb("#f1f5f9")

#let body-font = "Inter"
#let display-font = "Space Grotesk"

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

// Section header: small accent bar, spaced-caps title, hairline filling the rest.
#let section(title) = {
  v(5pt)
  grid(
    columns: (auto, auto, 1fr),
    column-gutter: 8pt,
    align: horizon,
    rect(width: 4pt, height: 8pt, fill: accent),
    caps-label(title, size: 0.86em),
    line(length: 100%, stroke: 0.5pt + hairline),
  )
  v(1pt)
}

#let sidebar-group(title, items) = {
  caps-label(title, fill: accent, size: 0.78em)
  v(-5pt)
  // Non-breaking space before each separator so wraps leave the dot at line end.
  text(fill: ink, items.join("\u{a0}· "))
  v(5pt)
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

#let bullets(items) = list(
  tight: false,
  spacing: 4pt,
  indent: 0pt,
  body-indent: 7pt,
  marker: box(width: 3pt, height: 3pt, fill: accent, baseline: -3pt),
  ..items,
)

// --- Sections ---------------------------------------------------------------

#let education-section(education) = {
  section[Education]
  stack(
    spacing: 7pt,
    ..education.map(e => entry(e.period)[
      #entry-heading(e.degree, e.location)
      #v(-4pt)
      #text(weight: 500, size: 0.96em, e.school)
      #v(-4pt)
      #text(size: 0.92em, fill: muted, e.note)
    ]),
  )
}

#let experience-section(experience) = {
  section[Professional Experience]
  stack(
    spacing: 8pt,
    ..experience.map(e => entry(e.period)[
      #entry-heading(e.company, e.location)
      #v(-4pt)
      #text(style: "italic", fill: muted, e.title)
      #v(-4pt)
      #bullets(e.bullets)
    ]),
  )
}

#let projects-section(projects) = {
  section[Featured Projects]
  stack(
    spacing: 8pt,
    ..projects.map(p => block[
      #text(weight: 600, size: 1.02em, p.name)
      #h(2pt)
      #text(size: 0.85em, fill: accent, p.stack.join(" · "))
      #text(size: 0.88em, fill: muted, [ #p.org])
      #v(-4pt)
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
    spacing: 6pt,
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

// Header: name on the left, contact stacked on the right, accent-tipped rule below.
#let header-block(basics) = {
  grid(
    columns: (1fr, auto),
    align: (left + bottom, right + bottom),
    {
      text(font: display-font, size: 27pt, weight: 500, tracking: -0.02em, basics.first_name)
      h(7pt)
      text(font: display-font, size: 27pt, weight: 700, tracking: -0.02em, fill: accent, basics.last_name)
    },
    text(size: 0.92em, fill: muted)[
      #link(basics.website_url)[#basics.website] #h(3pt)|#h(3pt) #link("mailto:" + basics.email)[#basics.email] \
      #basics.phone #h(3pt)|#h(3pt) #basics.location
    ],
  )
  v(-2pt)
  grid(
    columns: (56pt, 1fr),
    align: horizon,
    rect(width: 100%, height: 2.5pt, fill: accent),
    line(length: 100%, stroke: 0.5pt + hairline),
  )
}

#let sidebar(basics, profiles, skills) = {
  set text(size: 0.94em)
  sidebar-group("Profiles", profiles.map(p => link(p.url)[#p.label]))
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
  set par(justify: false, leading: 0.55em)
  show link: set text(fill: ink)
  body
}
