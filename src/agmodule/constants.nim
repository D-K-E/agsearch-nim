## some constants for file structure
import os

let appDir* = getAppDir().absolutePath()

let dataDir* = joinPath(appDir, "data")

let rawDataDir* = joinPath(dataDir, "raw")

let normalizedDataDir* = joinPath(dataDir, "normalized")

let resultsDir* = joinPath(appDir, "results")

let tempDir* = joinPath(appDir, "temp")

let textInfoDbPath* = joinPath(dataDir, "textInfoDB.json")
