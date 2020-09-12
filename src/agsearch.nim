# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import agmodule/constants
import agmodule/utils
import agmodule/messages
import agmodule/text
import agmodule/searchmanager
import agmodule/simplesearch
import agmodule/tfidfsearch

import os # paramCount
import threadpool
import strutils

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
            case manager.kind
            of skBoolean:
                let searcher = SimpleSearch(info: info,
                                            terms: terms)
                if simpleInSearch(searcher):
                    results.add(info)
            of skTfIdf:
                let searcher = TFIdfSearch(info: info,
                                           terms: terms)

        if debug:
            echo(terms)
            echo($(results))


