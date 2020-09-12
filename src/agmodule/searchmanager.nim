## search manager for simple and smart search
import text
import simplesearch
import tfidfsearch

type
    SearcherKind* = enum
        skBoolean,
        skTfIdf

type
    SearchManager* = object
        terms*: seq[string]
        kind*: SearcherKind


