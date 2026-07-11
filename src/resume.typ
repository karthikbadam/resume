#import "template.typ": *

#let data = yaml("/content/resume.yaml")

#show: resume.with(data)

// Page-1 background: rounded panel spanning the full height of the sidebar
// column, from just below the header to the bottom margin.
#set page(background: context if counter(page).get().first() == 1 {
  place(top + left, dx: 1.3cm, dy: 70pt,
    rect(width: 129pt, height: 688pt, radius: 8pt, fill: panel))
})

#header-block(data.basics)
#v(4pt)

// Page 1: sidebar (profiles, skills) + experience and education.
#grid(
  columns: (24%, 1fr),
  column-gutter: 16pt,
  block(
    inset: 10pt,
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
  #set par(leading: 0.7em)
  #projects-section(data.projects)
  #v(8pt)
  #publications-section(data.publications)
  #v(8pt)
  #service-section(data.service)
]
