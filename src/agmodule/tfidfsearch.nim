## smart searcher
import text
import utils
import tfidf

type
    TFIdfSearch* = object
        info*: seq[TextInfo]
        terms*: seq[string]


