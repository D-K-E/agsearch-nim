## utility functions
import constants

import os
import json

proc emptyTempDir*() =
    removeDir(tempDir)
    createDir(tempDir)

proc moveToRawData*(s: string) =
    moveFile(s, joinPath(rawDataDir, splitPath(s).tail))

proc moveToNormalizedData*(s: string) =
    moveFile(s, joinPath(normalizedDataDir, splitPath(s).tail))

proc moveToData*(s: string) =
    moveFile(s, joinPath(dataDir, splitPath(s).tail))

proc moveToTemp*(s: string) =
    moveFile(s, joinPath(tempDir, splitPath(s).tail))

proc moveToResults*(s: string) =
    moveFile(s, joinPath(resultsDir, splitPath(s).tail))

proc copyToRawData*(s: string) =
    copyFile(s, joinPath(rawDataDir, splitPath(s).tail))

proc copyToNormalizedData*(s: string) =
    copyFile(s, joinPath(normalizedDataDir, splitPath(s).tail))

proc copyToData*(s: string) =
    copyFile(s, joinPath(dataDir, splitPath(s).tail))

proc copyToTemp*(s: string) =
    copyFile(s, joinPath(tempDir, splitPath(s).tail))

proc copyToResults*(s: string) =
    copyFile(s, joinPath(resultsDir, splitPath(s).tail))

proc getTextInfoDB*(): JsonNode =
    return parseFile(textInfoDbPath)

proc getNodeVal*[T](n: JsonNode): T {.raises: ValueError.} =
    ## get value of node if json node is string int float or bool
    when (T is string):
        return n.getStr()
    elif (T is int):
        return n.getInt()
    elif (T is float):
        return n.getFloat()
    elif (T is bool):
        return n.getBool()
    else:
        raise newException(ValueError, "wrong type of json node ")
