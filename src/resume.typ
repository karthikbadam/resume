#import "template.typ": *

#let data = yaml("/content/resume.yaml")

#show: resume.with(data)

// Page 1 auto-centers between the top and bottom margins: the 1fr struts split
// whatever space the content leaves, so the page rebalances itself when content
// is added or removed. No hand-tuned offsets or heights anywhere.
#v(1fr)
#header-block(data.basics)
#v(4pt)
#two-col(
  sidebar(data.basics, data.profiles, data.skills),
  {
    // Drop the first caption to match the sidebar's top inset, so "Profiles"
    // and "Professional Experience" stay level.
    v(3pt)
    experience-section(data.experience)
    education-section(data.education)
  },
)
#v(1fr)

// Page 2: full-width sections, flowing from the top with a touch more leading.
#pagebreak()
#[
  #set par(leading: 0.66em)
  #projects-section(data.projects)
  #v(6pt)
  #publications-section(data.publications)
  #v(6pt)
  #service-section(data.service)
]
