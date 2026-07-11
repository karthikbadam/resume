#import "template.typ": *

#let data = yaml("/content/resume.yaml")

#show: resume.with(data)

#header-block(data.basics)
#v(6pt)

// Page 1: sidebar (contact, profiles, skills) + education and experience.
#grid(
  columns: (27%, 1fr),
  column-gutter: 20pt,
  sidebar(data.basics, data.profiles, data.skills),
  {
    education-section(data.education)
    v(6pt)
    experience-section(data.experience)
  },
)

// Page 2: full-width projects, publications, and service.
#pagebreak()
#projects-section(data.projects)
#v(6pt)
#publications-section(data.publications)
#v(6pt)
#service-section(data.service)
