## smart searcher
import text
import utils

type
    TFIdfSearch* = object
        info*: TextInfo
        terms*: seq[string]

