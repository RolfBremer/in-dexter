#import "../in-dexter.typ": *
#set page("a6", flipped: true, numbering: "1")

_A test for the order of page references. Marks in floating content,
like figures, can land on a page after the marks that follow them in the
source. The index still lists the pages in ascending order._

#block(height: 50%, width: 100%)

// Too tall for the rest of this page, so the float moves to page 2,
// while the mark in the text after it stays on page 1.
#figure(
  placement: top,
  rect(height: 60%, width: 100%)[#index[Float]Floating figure],
  caption: [A floating figure on page 2.],
)

#index[Float]Text on page 1.

#pagebreak()

#index[Float]Text on page 3, after the figure's page.

== Index

Expected: Float, 1, 2, 3

#make-index()
