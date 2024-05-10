# in-dexter

Automatically create a handcrafted index in [typst](https://typst.app/).
This typst component allows the automatic creation of an Index page with entries
that have been manually marked in the document by its authors. This, in times
of advanced search functionality, seems somewhat outdated, but a handcrafted index
like this allows the authors to point the reader to just the right location in the
document.

⚠️ Typst is in beta and evolving, and this package evolves with it. As a result, no
backward compatibility is guaranteed yet. Also, the package itself is under development
and fine-tuning.

## Table of Contents

* [Usage](#usage)
  * [Importing the Component](#importing-the-component)
  * [Remarks for new version](#remarks-for-new-version)
  * [Marking Entries](#marking-entries)
    * [Generating the index page](#generating-the-index-page)
    * [Brief Sample Document](#brief-sample-document)
    * [Full Sample Document](#full-sample-document)
* [Changelog](#changelog)
  * [v0.2.0](#v020)
  * [v0.1.0](#v010)
  * [v0.0.6](#v006)
  * [v0.0.5](#v005)
  * [v0.0.4](#v004)
  * [v0.0.3](#v003)
  * [v0.0.2](#v002)

## Usage

## Importing the Component

To use the index functionality, the component must be available. This
can be achieved by importing the package `in-dexter` into the project:

Add the following code to the head of the document file(s)
that want to use the index:

```typ
  #import "@preview/in-dexter:0.2.0": *
```

Alternatively it can be loaded from the file, if you have it copied into your project.

```typ
  #import "in-dexter.typ": *
```

## Remarks for new version

In previous versions (before 0.0.6) of in-dexter, it was required to hide the index
entries with a show rule. This is not required anymore.

## Marking Entries

To mark a word to be included in the index, a simple function can be used. In the
following sample code, the word "elit" is marked to be included into the index.

```typ
= Sample Text
Lorem ipsum dolor sit amet, consectetur adipiscing #index[elit], sed do eiusmod tempor
incididunt ut labore et dolore.
```

Nested entries can be created - the following would create an entry `adipiscing` with sub entry
`elit`.

```typ
= Sample Text
Lorem ipsum dolor sit amet, consectetur adipiscing elit#index("adipiscing", "elit"), sed do eiusmod
tempor incididunt ut labore et dolore.
```

The marking, by default, is invisible in the resulting text, while the marked word
will still be visible. With the marking in place, the index component knows about
the word, as well as its location in the document.

## Generating the Index Page

The index page can be generated by the following function:

```typ
= Index
#columns(3)[
  #make-index(title: none)
]
```

This sample uses the optional title, outline, and use-page-counter parameters:

```typ
#make-index(title: [Index], outlined: true, use-page-counter: true)
```

The `make-index()` function takes three optional arguments: `title`, `outlined`, and `use-page-counter`.

* `title` adds a title (with `heading`) and
* `outlined` is `false` by default and is passed to the heading function
* `use-page-counter` is `false` by default. If set to `true` it will use `counter(page).display()` for the page
    number text in the index instead of the absolute page position (the absolute position is still
    used for the actual link target)

If no title is given the heading should never appear in the layout.
Note: The heading is (currently) not numbered.

The first sample emits the index in three columns.
Note: The actual appearance depends on your template or other settings of your document.

You can find a preview image of the resulting page
on [in-dexter´s GitHub repository](https://github.com/RolfBremer/in-dexter).

You may have noticed that some page numbers are displayed as bold. These are index entries
which are marked as "main" entries. Such entries are meant to be the most important for
the given entry. They can be marked as follows:

```typ
#index(fmt: strong, [Willkommen])
```

or you can use the predefined semantically helper function

```typ
#index-main[Willkommen]
```

### Brief Sample Document

This is a very brief sample to demonstrate how in-dexter can be used. The next chapter
contains a more fleshed out sample.

```typ
#import "@preview/in-dexter:0.2.0": *


= My Sample Document with `in-dexter`

In this document the usage of the `in-dexter` package is demonstrated to create
a hand picked #index[Hand Picked] index. This sample #index-main[Sample]
document #index[Document] is quite short, and so is its index.


= Index

This section contains the generated Index.

#make-index()
```

### Full Sample Document

```typ
#import "@preview/in-dexter:0.2.0": *

#let index-main(..args) = index(fmt: strong, ..args)

// Document settings
#set page("a5")
#set text(font: ("Arial", "Trebuchet MS"), size: 12pt)


= My Sample Document with `in-dexter`

In this document #index[Document] the usage of the `in-dexter` package #index[Package]
is demonstrated to create a hand picked index #index-main[Index]. This sample document
is quite short, and so is its index. So to fill this sample with some real text,
let´s elaborate on some aspects of a hand picked #index[Hand Picked] index. So, "hand
picked" means, the entries #index[Entries] in the index are carefully chosen by the
author(s) of the document to point the reader, who is interested in a specific topic
within the documents domain #index[Domain], to the right spot #index[Spot]. Thats, how
it should be; and it is quite different to what is done in this sample text, where the
objective #index-main[Objective] was to put many different index markers
#index[Markers] into a small text, because a sample should be as brief as possible,
while providing enough substance #index[Substance] to demo the subject
#index[Subject]. The resulting index in this demo is somewhat pointless
#index[Pointless], because all entries are pointing to few different pages
#index[Pages], due to the fact that the demo text only has few pages #index[Page].
That is also the reason for what we chose the DIN A5 #index[DIN A5] format, and we
also continue with some remarks #index[Remarks] on the next page.


== Some more demo content without deeper meaning

#lorem(50) #index[Lorem]

#pagebreak()

== Remarks

Here are some more remarks #index-main[Remarks] to have some content on a second page, what
is a precondition #index[Precondition] to demo that Index #index[Index] entries
#index[Entries] may point to multiple pages.


= Index

This section #index[Section] contains the generated Index #index[Index], in a nice
two-column-layout.

#set text(size: 10pt)
#columns(2)[
    #make-index()
]
```

The following image shows a generated index page of another document, with additional
formatting for headers applied.

![Sample for a generated index page.](gallery/SampleIndex.png)

More usage samples are shown in the document `sample-usage.typ` on
[in-dexter´s GitHub](https://github.com/RolfBremer/in-dexter).

A more complex sample PDF is available there as well.

</span>

## Changelog

### v0.3.0

* Support multiple named indexes. Also allow the generation of
  combined index pages.

### v0.2.0

* Allow index to respect unnumbered physical pages at the start of the
  document (Thanks to @jewelpit). See "Skipping physical pages" in the
  sample-usage document.

### v0.1.0

* big refactor (by @epsilonhalbe).
* changing "marker classes" to support direct format
  function `fmt: content -> content` e.g. `index(fmt: strong, [entry])`.
* Implemented:
  * nested entries.
  * custom initials + custom sorting.

### v0.0.6

* Change internal index marker to use metadata instead of figures. This
  allows a cleaner implementation and does not require a show rule to hide
  the marker-figure anymore.
* This version requires Typst 0.8.0 due to the use of metadata().
* Consolidated the `PackageReadme.md` into a single `README.md`.

### v0.0.5

* Address change in `figure.caption` in typst (commit: 976abdf ).

### v0.0.4

* Add title and outline arguments to #make-index() by @sbatial in #4

### v0.0.3

* Breaking: Renamed the main file from `index.typ` to `in-dexter.typ` to match package.
* Added a Changelog to this README.
* Introduced a brief and a full sample code to this README.
* Added support for package manager in Typst.

### v.0.0.2

* Moved version to GitHub.
