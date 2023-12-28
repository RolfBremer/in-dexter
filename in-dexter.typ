// Copyright 2023 Rolf Bremer, Jutta Klebe
// Use of this code is governed by the License in the LICENSE.txt file.
// For a 'how to use this package', see the accompanying .md, .pdf + .typ documents.

#let index(fmt: it => it, ..entry) = locate(loc => [
    #metadata((
        fmt: fmt,
        location: loc.position(),
        entry: entry,
    ))<jkrb_index>
])

#let as-text(input) = {
    if type(input) == str {
        input
    } else if type(input) == content {
        if input.has("text") {
            input.text
        } else if input.has("children") {
            input.children.map(child => as-text(child)).join("")
        } else {
            panic("Encountered content without 'text' or 'children' field: " + repr(input))
        }
    } else {
        panic("Unexpected entry type " + type(input) + " of " + repr(input))
    }
}

#let plain(entry, page, fmt, register) = {
    let initial-letter = entry.first()
    let page-link = (page: page, fmt: fmt)

    let reg-entry = register.at(initial-letter, default: (:))
    let refs = reg-entry.at(entry, default: (:))
    let pages = refs.at("pages", default: ())

    if not pages.contains(page-link) {
        pages.push(page-link)
        reg-entry.insert(entry, ("pages": pages))
        register.insert(initial-letter, reg-entry)
    }
    register
}

#let references(loc) = {
    let register = (:)
    for indexed in query(<jkrb_index>, loc) {
        let (entry, fmt, location) = indexed.value
        let entries = entry.pos().map(as-text)
        if entries.len() == 0 {
            panic("expected entry to have at least one entry to add to the index")
        } else if entries.len() == 1 {
            register = plain(entries.first(), location.page, fmt, register)
        } else {
        }
    }
    register
}

#let make-link((page, fmt)) = {
    link((page: page, x: 0pt, y: 0pt), fmt[#page])
}

#let make-index(title: none, outlined: false) = locate(loc => {
    let dict = references(loc)

    if title != none {
        heading(
            outlined: outlined,
            numbering: none,
            title
        )
    }

    for initial in dict.keys().sorted() {
        heading(level: 2, numbering: none, outlined: false, initial)
        let entry = dict.at(initial)
        for idx in entry.keys().sorted() [
            #idx
            #box(width: 1fr)
            #let pages = entry.at(idx).at("pages", default: ())
            #pages.map(make-link).join(", ") \
        ]
    }
})

