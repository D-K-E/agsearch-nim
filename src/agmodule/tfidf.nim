# tf idf document
import tables
import text
import utils
import constants
import sets
import os
import strutils
import math
import algorithm

type
    TfIdfTerm* = object
        termDocCount*: int
        invDocCount*: float
        tfIdf*: float
        term*: string
        docLocalPath*: string # used as index

proc `$`(t: TfIdfTerm): string =
    result = t.term & " " & $(t.termDocCount) & " " & t.docLocalPath & " " & $(t.tfIdf)

proc getTermsFreqFromText(txt: Text, sep: string = " "): CountTable[string] =
    ## extract terms from text
    var terms: seq[string]
    if txt.hasChunks == true:
        for chunk in txt.chunks:
            var chunkTerms = chunk.split(sep)
            for chunkTerm in chunkTerms:
                if chunkTerm != sep:
                    terms.add(chunkTerm)
    else:
        var chunk = txt.chunks[0]
        var chunkTerms = chunk.split(sep)
        for chunkTerm in chunkTerms:
            if chunkTerm != sep:
                terms.add(chunkTerm)
    result = toCountTable(terms)

proc getTermCountInDocument(term: string,
                            sep: string = " ",
                            info: TextInfo): int =
    ##
    var txt = toText(info)
    if txt.hasChunks == true:
        for chunk in txt.chunks:
            var chunkTerms = chunk.split(sep)
            for chunkTerm in chunkTerms:
                if chunkTerm == term:
                    result += 1
    else:
        var chunk = txt.chunks[0]
        var chunkTerms = chunk.split(sep)
        for chunkTerm in chunkTerms:
            if chunkTerm == sep:
                result += 1


proc getDocumentFreqForTerm(term: string,
                            infos: seq[TextInfo]): int =
    result = 0
    for info in infos:
        var txt = readFile(joinPath(dataDir, info.localPath))
        if term in txt:
            result += 1

proc getInverseDocumentFreq(term: string, infos: seq[TextInfo]): float =
    var count = getDocumentFreqForTerm(term, infos)
    result = log10(len(infos) / count)

proc tfcomp(a, b: TfIdfTerm): int =
    if a.tfIdf < b.tfIdf:
        result = 1
    elif a.tfIdf == b.tfIdf:
        result = 0
    else:
        result = -1

proc getTfIdfTerm(term: string, sep: string = " ",
                  infos: seq[TextInfo]): seq[TfIdfTerm] =
    for info in infos:
        var tcount = getTermCountInDocument(term, sep,
                                            info)
        var docCount = getInverseDocumentFreq(term, infos)
        result.add(TfIdfTerm(termDocCount: tcount,
                             invDocCount: docCount,
                             term: term,
                             tfIdf: float(tcount) * docCount,
                             docLocalPath: info.localPath))
    result.sort(tfcomp)

proc getTfIdfTerms*(terms: HashSet[string], sep: string = " ",
                   infos: seq[TextInfo]): Table[string, seq[TfIdfTerm]] =
    for term in terms:
        result[term] = getTfIdfTerm(term, sep, infos)

