// Styling and components for the resume. Content lives in content/resume.yaml.

// Palette: near-black slate ink, cool grays. Accent + panel match the
// portfolio site theme (karthikbadam.github.io src/theme.ts, light mode).
#let ink = rgb("#0f172a")
#let accent = rgb("#2b6cb0")
#let muted = rgb("#475569")
#let hairline = rgb("#e2e8f0")
#let panel = rgb("#f0f5f9")
#let accent-tint = rgb("#e3edf6")

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
  v(9pt)
  grid(
    columns: (auto, 1fr),
    column-gutter: 10pt,
    align: horizon,
    caps-label(title, size: 0.86em),
    line(length: 100%, stroke: 0.5pt + hairline),
  )
  v(2pt)
}

// Sidebar group, styled after the original resume: right-aligned, a plain
// gray group title, and items flowing with pipe separators. Profile links
// get one per row (wide: true).
// Greedily pack items into lines that fit the available width, with light
// dot separators only between items on the same line — never dangling at
// line ends.
#let flow-lines(items) = layout(size => {
  let sep = text(fill: rgb("#94a3b8"), " · ")
  let lines = ()
  let current = none
  for it in items {
    let candidate = if current == none [#it] else [#current#sep#it]
    if current != none and measure(candidate).width > size.width {
      lines.push(current)
      current = [#it]
    } else {
      current = candidate
    }
  }
  if current != none { lines.push(current) }
  lines.join(linebreak())
})

#let sidebar-group(title, items, wide: false) = align(right)[
  #text(font: display-font, weight: 600, size: 1.02em, fill: muted, title)
  #v(-3pt)
  #text(fill: ink, if wide {
    items.join(linebreak())
  } else {
    flow-lines(items)
  })
  #v(11pt)
]

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

// Join a string's last two words with a non-breaking space, and forbid
// hyphenation inside the final word, so a paragraph can never end in a
// single-word or hyphenated-fragment line (runt).
#let bind-runt(s) = {
  if type(s) != str { return s }
  let m = s.match(regex("^([\s\S]*)\s(\S+)$"))
  if m == none { return s }
  [#m.captures.at(0)\u{a0}#text(hyphenate: false, m.captures.at(1))]
}

// Markerless "bullets": plain statements separated by whitespace.
// Gaps stay clearly smaller than the between-entry spacing so entries group.
#let bullets(items) = stack(spacing: 7pt, ..items.map(bind-runt))

// --- Sections ---------------------------------------------------------------

#let education-section(education) = {
  section[Education]
  stack(
    spacing: 8pt,
    ..education.map(e => entry(e.period)[
      #entry-heading(e.degree, [#e.school · #e.location])
      #v(-4pt)
      #text(fill: muted, bind-runt(e.note))
    ]),
  )
}

#let experience-section(experience) = {
  section[Professional Experience]
  stack(
    spacing: 12pt,
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
      #bind-runt(p.description)
      #if "contributions" in p [
        #text(weight: 600)[Contributions:] #bind-runt(p.contributions)
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
      text[
        #bind-runt(p.text)
        #if "note" in p [
          #box(
            fill: accent-tint,
            inset: (x: 4pt, y: 1.5pt),
            radius: 3pt,
            baseline: 25%,
            text(size: 0.92em, weight: 600, fill: accent, p.note),
          )
        ]
      ],
    )),
  )
}

#let service-section(service) = {
  section[Service]
  bullets(service)
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
  set par(justify: false, leading: 0.85em)
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
    margin: (x: 1.3cm, top: 1.1cm, bottom: 1.3cm),
    footer: align(center, text(size: 8pt, fill: muted, context counter(page).display("1 / 1", both: true))),
  )
  set text(
    font: body-font,
    size: base-size,
    fill: ink,
    tracking: -0.006em,
    hyphenate: true,
    // Suppress widows/orphans at breaks and lone short words on final lines.
    costs: (widow: 10000%, orphan: 10000%, runt: 10000%),
  )
  set par(justify: true, leading: 0.6em)
  show link: set text(fill: ink)
  body
}
