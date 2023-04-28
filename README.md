# typst-index
Automatically create a handcrafted index in typst.
This typst component allows the automatic creation of an Index page with entries
that have been manually marked in the document by its authors. This, in times
of advanced search functionality, seems somewhat outdated, but a handcrafted index
like this allows the authors to point the reader to just the right location in the 
document.


## Marking entries

To mark a word to be included in the index, a simple function can be used. In the 
following sample code, the word "elit" is marked to be included into the index.

```typ
= Sample Text
Lorem ipsum dolor sit amet, consectetur adipiscing #index[elit], sed do eiusmod tempor 
incididunt ut labore et dolore.
```

