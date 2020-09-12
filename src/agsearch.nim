# This is just an example to get you started. A typical hybrid package
# uses this file as the main entry point of the application.

import agmodule/constants
import agmodule/utils
import agmodule/messages
import agmodule/text

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
        #
        if debug:
            echo(terms)


