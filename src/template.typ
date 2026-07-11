// Styling and components for the resume. Content lives in content/resume.yaml.

#let accent = rgb("#1f4e79")
#let ink = rgb("#1f2328")
#let muted = rgb("#6e7781")
#let hairline = rgb("#d0d7de")

#let base-size = 9pt
#let period-col = 60pt

// --- Small helpers ---------------------------------------------------------

#let smallcaps-label(body) = text(
  size: 0.82em,
  weight: 600,
  tracking: 0.08em,
  fill: accent,
  upper(body),
)

#let section(title) = {
  v(4pt)
  smallcaps-label(title)
  v(-6pt)
  line(length: 100%, stroke: 0.5pt + hairline)
  v(-2pt)
}

#let sidebar-group(title, items) = {
  smallcaps-label(title)
  v(-4pt)
  text(fill: ink, items.join(" · "))
  v(4pt)
}

// A dated entry: muted period on the left, content on the right.
#let entry(period, body) = grid(
  columns: (period-col, 1fr),
  column-gutter: 12pt,
  text(size: 0.9em, fill: muted, period),
  body,
)

#let entry-heading(title, detail) = grid(
  columns: (auto, 1fr),
  column-gutter: 8pt,
  text(weight: 700, title),
  align(right, text(size: 0.9em, fill: muted, detail)),
)

#let bullets(items) = list(
  tight: false,
  spacing: 4pt,
  indent: 0pt,
  body-indent: 6pt,
  marker: text(fill: accent, "•"),
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
      #text(weight: 700, p.name)
      #text(size: 0.88em, fill: accent, [ [#p.stack.join(", ")] ])
      #text(size: 0.9em, fill: muted, p.org)
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
      text(weight: 600, fill: accent, p.id),
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

#let header-block(basics) = align(center)[
  #text(size: 26pt, weight: 300, basics.first_name)
  #h(6pt)
  #text(size: 26pt, weight: 700, fill: accent, basics.last_name)
  #v(-8pt)
  #text(size: 0.94em, fill: muted)[
    #link(basics.website_url)[#basics.website]
    #h(4pt) | #h(4pt)
    #link("mailto:" + basics.email)[#basics.email]
    #h(4pt) | #h(4pt)
    #basics.location
  ]
]

#let sidebar(basics, profiles, skills) = {
  set text(size: 0.94em)
  sidebar-group("Contact", (basics.phone, link("mailto:" + basics.email)[#basics.email]))
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
  set text(font: "Inter", size: base-size, fill: ink)
  set par(justify: false, leading: 0.55em)
  show link: set text(fill: ink)
  body
}
