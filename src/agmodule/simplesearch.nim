## simple boolean search in text
import text
import utils

type
    SimpleSearch* = object
        info*: TextInfo
        terms*: seq[string]

proc boolSearchTerms(terms: seq[string], txt: string,
                match: proc(e1: string, e2: string): bool): bool =
    var check = false
    for term in terms:
        let matchResult = match(term, txt)
        if matchResult:
            check = matchResult
    return check

proc boolSearchTerms(terms: seq[string], chunks: seq[string],
                     match: proc(e1: string, e2: string): bool): bool =
    var check = false
    for chunk in chunks:
        let boolRes = boolSearchTerms(terms, chunk, match)
        if boolRes:
            check = boolRes
    return check


proc simpleSearchTxt(
    searcher: SimpleSearch,
    match: proc(e1, e2: string): bool): bool =
    ## simple search main search function
    let txt = toText(searcher.info)
    if txt.hasChunks:
        return boolSearchTerms(searcher.terms, txt.chunks, match)
    else:
        return boolSearchTerms(searcher.terms, txt.chunks[0], match)

proc simpleInSearch*(searcher: SimpleSearch): bool =
    return simpleSearchTxt(searcher, inMatch)

proc simpleEqSearch*(searcher: SimpleSearch): bool =
    return simpleSearchTxt(searcher, eqMatch)


