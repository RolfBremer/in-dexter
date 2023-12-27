// Copyright 2023 Rolf Bremer, Jutta Klebe
// Use of this code is governed by the License in the LICENSE.txt file.
// For a 'how to use this package', see the accompanying .md, .pdf + .typ documents.


// Classes for index entries. The class determines the visualization
// of the entries' page number.
#let classes = (
    main: "Main",
    simple: "Simple",
)

// Index Entry; used to mark an entry in the document to be included in the Index.
// An optional class may be provided.
#let index(..entry) = locate(loc => [
    #metadata((
        class: classes.simple,
        location: loc.position(),
        entry: entry,
    ))<jkrb_index>])

#let index-main(
    ..entry,
    ) = locate(loc => [
        #metadata((
            class: classes.main,
            location: loc.position(),
            entry: entry,
        ))<jkrb_index>])

#let index-of(
    class,
    ..entry,
    ) = locate(loc => [
        #metadata((
            class: class,
            location: loc.position(),
            entry: entry,
        ))<jkrb_index>])


#let as-text(input) = {
    if type(input) == str {
        input
    } else if type(input) == content {
        if input.has("text") {
            input.text
        } else if input.has("children") {
            input.children.map(child => as-text(child)).join("")
        } else if input.has("field") {
            input.field
        } else {
            panic("Encountered content without 'text' or 'children' field: " + repr(input))
        }
    } else {
        panic("Unexpected entry type " + type(input) + " of " + repr(input))
    }
}

#let references(loc) = {
    let register = (:)
    for indexed in query(<jkrb_index>, loc) {
        let (entry, class, location) = indexed.value
        let entries = entry.pos().map(e => as-text(e))
        if entries.len() == 1 {
            let initial = entries.first().first()
            let reg-entry = register.at(initial, default: none)
            let page-link = (page: location.page, class: class)

            if reg-entry == none { // new initial
                register.insert(initial, (entries.first(): ("pages": (page-link,))))
            } else {
                let refs = reg-entry.at(entries.first(), default: none)
                if refs == none {
                    reg-entry.insert(entries.first(),("pages": (page-link,)))
                    register.insert(initial, reg-entry)
                } else {
                    let pages = refs.at("pages", default: none)
                    if pages == none {
                        refs.insert(entries.first(), ("pages": (page-link,)))
                        register.insert(initial, refs)
                    } else if not pages.contains(page-link) {
                        pages.push(page-link)
                        reg-entry.insert(entries.first(), ("pages": pages))
                        register.insert(initial, reg-entry)
                    }
                }
            }
        } else if entries.len() > 1 {
            // panic("bbbrgh")
        } else {
            panic("AARGH: " + repr(indexed))
        }
    }
    register
}

#let make-link((page, class)) = {
    link(
        (page: page, x: 0pt, y: 0pt),
        if class == classes.main {
            strong[#page]
        } else {
            [#page]
        }
    )
}

// Create the index page.
#let make-index(title: none, outlined: false) = {
    locate(loc => {
        let dict = references(loc)

        if title != none {
            heading(outlined: outlined, numbering: none, title)
        }

        for initial in dict.keys().sorted() {
            // panic("initial: " + repr(initial))
            heading(level: 2, numbering: none, outlined: false, initial)
            let entry = dict.at(initial)
            // panic("entry: " + repr(entry))
            for idx in entry.keys().sorted() [
                #idx
                #box(width: 1fr)
                #let pages = entry.at(idx).at("pages", default: ())
                // #panic("pages" + repr(pages))
                #pages.map(make-link).join(", ") \
            ]
        }
    })
}

