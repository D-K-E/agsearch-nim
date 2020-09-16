# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import agmodule/constants
import agmodule/utils
import agmodule/messages
import agmodule/text
import agmodule/searchmanager
import agmodule/simplesearch
import agmodule/tfidfsearch
import agmodule/tfidf

import os # paramCount
import threadpool
import strutils
import tables
import sets

let debug = true

var terms: seq[string]
var separator = ""


when isMainModule:
    printStart()
    if paramCount() == 0:
        printNoArgMessage()
        separator = handleSeparator()
        var searchTerms = gatherSearchTerms(separator)
        terms = printFilterSearchTerms(searchTerms, separator)
        let searchChoice = chooseSearchInterface()
        var manager: SearchManager
        var infos = fetchInfos()
        case searchChoice
        of 1:
            manager = SearchManager(terms: terms,
                                    kind: skBoolean)
        of 2:
            manager = SearchManager(terms: terms,
                                    kind: skTfIdf)
        else:
            raise newException(ValueError, "Unknown searcher choice")
        var results: seq[TextInfo]
        for info in infos:
            if manager.kind == skBoolean:
                let searcher = SimpleSearch(info: info,
                                            terms: terms)
                if simpleInSearch(searcher):
                    results.add(info)

        var tfs: Table[string, seq[TfIdfTerm]]
        if manager.kind == skTfIdf:
            var termSet = toHashSet(terms)
            tfs = getTfIdfTerms(termSet, sep = " ",
                                infos = infos)
        if debug:
            echo(terms)
            echo($(results))
            echo($(tfs))
