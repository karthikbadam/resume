#import "template.typ": *

#let data = yaml("/content/resume.yaml")

#show: resume.with(data)

#header-block(data.basics)
#v(4pt)

// Page 1: tinted sidebar panel (profiles, skills) + experience and education.
#grid(
  columns: (24%, 1fr),
  column-gutter: 16pt,
  align: (horizon, top),
  block(
    fill: panel,
    radius: 8pt,
    inset: 10pt,
    width: 100%,
    sidebar(data.basics, data.profiles, data.skills),
  ),
  {
    experience-section(data.experience)
    v(1pt)
    education-section(data.education)
  },
)

// Page 2: full-width projects, publications, and service.
// Long-form prose: extra leading for readability.
#pagebreak()
#[
  #set par(leading: 0.7em)
  #projects-section(data.projects)
  #v(8pt)
  #publications-section(data.publications)
  #v(8pt)
  #service-section(data.service)
]
