#import "template.typ": *

#let data = yaml("/content/resume.yaml")

#show: resume.with(data)

// Page-1 background: rounded panel spanning the full height of the sidebar
// column, from just below the header to the bottom margin.
#set page(background: context if counter(page).get().first() == 1 {
  place(top + left, dx: 1.5cm, dy: 94pt,
    rect(width: (100% - 3cm) * 0.24, height: 100% - 94pt - 1.5cm, radius: 8pt, fill: panel))
})

#header-block(data.basics)
#v(14pt)

// Page 1: sidebar (profiles, skills) + experience and education.
#grid(
  columns: (24%, 1fr),
  column-gutter: 16pt,
  block(
    inset: (x: 10pt, top: 26pt, bottom: 10pt),
    width: 100%,
    sidebar(data.basics, data.profiles, data.skills),
  ),
  {
    experience-section(data.experience)
    education-section(data.education)
  },
)

// Page 2: full-width projects, publications, and service.
// Long-form prose: extra leading for readability.
#pagebreak()
#[
  #set par(leading: 0.66em)
  #projects-section(data.projects)
  #v(2pt)
  #publications-section(data.publications)
  #v(2pt)
  #service-section(data.service)
]
