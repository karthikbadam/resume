#import "template.typ": *

#let data = yaml("/content/resume.yaml")

#show: resume.with(data)

#header-block(data.basics)
#v(8pt)

// Page 1: tinted sidebar panel (profiles, skills) + experience and education.
#grid(
  columns: (28%, 1fr),
  column-gutter: 16pt,
  grid.cell(fill: panel, inset: 10pt, sidebar(data.basics, data.profiles, data.skills)),
  {
    experience-section(data.experience)
    v(6pt)
    education-section(data.education)
  },
)

// Page 2: full-width projects, publications, and service.
#pagebreak()
#projects-section(data.projects)
#v(6pt)
#publications-section(data.publications)
#v(6pt)
#service-section(data.service)
