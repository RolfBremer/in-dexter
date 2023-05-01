#import "./index.typ": *

// This typst file demonstrates the usage of the index package.
#set text(lang: "en", font: "Arial", size: 10pt)
#set heading(numbering: "1.1")

// Index-Entry hiding : this rule makes the index entries in the document invisible.
#show figure.where(kind: "jkrb_index"): it => {}

// Index-Entry showing : this rule makes the index entries in the document visible.
// Use this for review purposes alternatively to the hiding rule above.
// #show figure.where(kind: "jkrb_index"): it => {
//     text(fill: red)[ --> '#it.caption']
// }


// Front Matter
#align(center)[
    #text(size: 23pt)[Typst-Index]
    #linebreak() #v(1em)
    #text(size: 16pt)[An index package for Typst]
    #linebreak() #v(.5em)
    #text(size: 12pt)[Version 0.1 (1. Mai 2023)]
    #linebreak() #v(.5em)
    #text(size: 10pt)[Rolf Bremer, Jutta Klebe]
    #v(4em)
]


= Sample Document to Demonstrate the Typst-Index

Using the index package in a typst document consists of some simple steps:

+ Importing the package `index.typ`.
+ Marking the words or phrases to include in the index.
+ Defining the show rule for the entries (usually to hide them).
+ Generating the index page by calling the `makeIndex()` function.

== Importing the Package

The index package is currently available on GitHub
(https://github.com/RolfBremer/typst-index). It is still in development and may have
breaking changes #index[Breaking Changes] in its next iteration.
#index[Iteration]#index[Development]

```typ
    #import "./index.typ": *
```


== Marking of Entries
We have marked several words to be included in an index page at the
end of the document. #index[Sample] The markup for the entry stays invisible
#index[Invisible]. Its location in the text gets recorded, and later it is shown as a page
reference in the index page. #index[Index Page]

```typ
    #index[The Entry Phrase]
```


=== Marker Classes

#index(class: classes.main)[Classes]
#index(class: classes.main)[Marker Classes]

The entries support a class. This class determines the
visualization for the page number of the entry. Currently, we distinguish between class
"Simple" #index[Simple] and class "Main" #index[Main]. The first one is the default. The
second is provided to mark the main reference for that entry -- its page number will be
printed in *bold*.

```typ
    #index(class: classes.main)[The Entry Phrase]
```

In future versions of this package there may be more marker classes for additional cases.
It is recommended to use the `classes` definition of the package.

- `classes.simple`
- `classes.main`


#pagebreak()


== Controlling the Show

At the start of this document, just after the `import` #index[Import] statements, we used
a `show` rule #index[Show Rule] to define, what we want to see of the index markers in the
resulting document. This is usually defined in a way, that the markers just show nothing:

```typ
    // Index-Entry hiding : this rule makes the index entries in the document invisible.
    #show figure.where(kind: "jkrb_index"): it => {}
```

For review #index[Review] reasons, this can be changed to show up in the resulting
document. For example like this:

```typ
    // Index-Entry: this rule makes the index entries in the document visible.
    #show figure.where(kind: "jkrb_index"): it => {
        text(fill: red)[ --> '#it.caption']
    }
```

The index markers now show up in the resulting document and can easily be reviewed.

== The Index Page

#index(class: classes.main)[Index Page]

To actually create the index page, the `makeIndex()` function has to be called. Of course,
it can be embedded into an appropriately formatted #index[Formatting]
environment#index[Environment], like this:

```typ
    #columns(3)[
        #makeIndex()
    ]
```


= Why Having an Index in Times of Search Functionality?

#index(class: classes.main)[Searching vs. Index]

A _handpicked Index_ #index[Hand Picked] in times of search functionality #index[Search
Functionality] seems a bit old-fashioned #index[Old-fashioned] at the first glance. But such
an index allows the author to direct the reader who is looking for a specific topic, to
exactly the right places. Especially in larger documents #index[Large Documents] and books
this becomes very useful, since search engines may provide too many locations of specific
words. The index #index[Index] is much more comprehensive, assuming that the author
#index[Authors responsibility] has its content #index[Content] selected well.

#line(length: 100%, stroke: .1pt + gray)

= Index

Here we generate the Index page in three columns:

#columns(3)[
    #makeIndex()
]
