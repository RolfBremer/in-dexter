// Copyright 2023 Rolf Bremer, Jutta Klebe
// Use of this code is governed by the License in the LICENSE.txt file.
// For a 'how to use this package', see the accompanying .md, .pdf + .typ documents.

/**
 * adds a new entrty to the index
 * @param fmt: function: content -> content
 * @param initial: "letter" to sort entries under - otherwise first letter of entry is used,
 *        useful for indexing umlauts or accented letters with their unaccented versions or
 *        symbols under a common "Symbols" headline
 * @param ..entry, variable argument to nest index entries (left to right)
 */
#let index(fmt: it => it, initial: none, ..entry) = locate(loc => [
    #metadata((
        fmt: fmt,
        initial: initial,
        location: loc.position(),
        entry: entry,
    ))<jkrb_index>
])

/**
 * extracts (nested) content or text to content
 */
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

/**
 * internal function to set nested entries
 */
#let make-entries(entries, page-link, reg-entry) = {
    let (entry, ..rest) = entries
    if rest.len() == 0 {
        let pages = reg-entry.at(entry, default: (:)).at("pages", default: ())

        if not pages.contains(page-link) {
            pages.push(page-link)
            reg-entry.insert(entry, ("pages": pages))
        }
    } else {
        let nested-entries = reg-entry.at("nested", default: (:))
        if nested-entries.keys().len() > 0 { panic(nested-entries) }
        let ref = make-entries(rest, page-link, nested-entries.at(entry, default: (:)))
        nested-entries.insert("nested", ref)
        reg-entry.insert(entry, nested-entries)
    }
    reg-entry
}

/**
 * internal function to collet plain and nested entries into the index
 */
#let references(loc) = {
    let register = (:)
    for indexed in query(<jkrb_index>, loc) {
        let (entry, fmt, initial, location) = indexed.value
        let entries = entry.pos().map(as-text)
        if entries.len() == 0 {
            panic("expected entry to have at least one entry to add to the index")
        } else {
            let initial-letter = if initial == none { entries.first().first() } else { initial }
            let reg-entry = register.at(initial-letter, default: (:))
            register.insert(initial-letter, make-entries(entries, (page: location.page, fmt: fmt), reg-entry))
        }
    }
    register
}

/**
 * internal function to format a page link
 */
#let render-link((page, fmt)) = {
    link((page: page, x: 0pt, y: 0pt), fmt[#page])
}

/**
 * internal function to format a page link
 */
#let render-entry(idx, entries, lvl) = {
    let pages = entries.at("pages", default: ())
    let rendered-pages = [ #box(width: (lvl + 1) * 1em)#idx#box(width: 1fr)#pages.map(render-link).join(", ") ]
    let sub-entries = entries.at("nested", default: (:))
    let rendered-entries = if sub-entries.keys().len() > 0 [
        #for entry in sub-entries.keys().sorted() [
            #render-entry(entry, sub-entries.at(entry), lvl + 1) \
        ]
    ]
    [
        #rendered-pages \
        #rendered-entries
    ]
}

/**
 * inserts the index into the document
 * @param title (default: none) sets the title of the index to use
 * @param ..entry, variable argument to nest index entries (left to right)
 */
#let make-index(title: none, outlined: false) = locate(loc => {
    let dict = references(loc)

    if title != none {
        heading(
            outlined: outlined,
            numbering: none,
            title
        )
    }

    // panic(dict)
    for initial in dict.keys().sorted() {
        heading(level: 2, numbering: none, outlined: false, initial)
        let entry = dict.at(initial)
        for idx in entry.keys().sorted() {
            render-entry(idx, entry.at(idx), 0)
        }
    }
})

