## implements a simple text helpers
import json
import utils
import strutils
import streams
import system # readfile

type
    TextInfo* = object
        localPath*: string
        url*: string
        id*: string
        hasChunks*: bool
        chunkSeparator*: string

type
    Text* = object
        chunks*: seq[string]
        localPath*: string
        hasChunks*: bool

proc toText(info: TextInfo): Text =
    ## read text from local info if hasChunks
    ## separate it using chunkSeparator
    ## else read the whole text blob into text chunks
    var txt = readFile(info.localPath)
    var chunks: seq[string]
    if info.hasChunks:
        chunks = txt.split(info.chunkSeparator)
    else:
        chunks = @[txt]
    return Text(chunks: chunks,
                localPath: info.localPath,
                hasChunks: info.hasChunks
        )

proc toJson(info: TextInfo): JsonNode =
    return %*info

proc fromJson(node: JsonNode): TextInfo =
    return TextInfo(
            localPath: getStr(node["localPath"]),
            url: getStr(node["url"]),
            id: getStr(node["id"]),
            hasChunks: getBool(node["hasChunks"]),
            chunkSeparator: getStr(node["chunkSeparator"])
    )

proc fetchInfoById(id: string): TextInfo =
    let db = getTextInfoDB()
    var node = db[id]
    node.add("id", newJString(id))
    return fromJson(node)

proc fetchInfoByComponents[T](
    compName: string,
    compVal: T,
    matchFn: proc(e1, e2: T): bool): seq[TextInfo] =
    ## fetch info by using a component as value
    let db = getTextInfoDB()
    var check = false
    for id, node in db.pairs():
        var nodeVal = getNodeVal[T](node[compName])
        if matchFn(compVal, nodeVal):
            node.add("id", newJString(id))
            check = true
            result.add(fromJson(node))

proc fetchInfoByComponent[T](compName, compVal: T,
                                matchFn: proc(e1, e2: T): bool): TextInfo =
    #
    var infos = fetchInfoByComponents[T](compName, compVal, matchFn)
    if len(infos) == 0:
        raise newException(ValueError, "value not found int db")
    result = infos[0]

proc eqMatch[T](e1, e2: T): bool = e1 == e2
proc inMatch[T](e1, e2: T): bool = e1 in e2

proc fetchInfoByPath(path: string): TextInfo =
    return fetchInfoByComponent[string]("localPath", path, eqMatch[string])

proc fuzzyFetchInfoByPath(path: string): TextInfo =
    return fetchInfoByComponent[string]("localPath", path, inMatch[string])

proc fetchInfoByUrl(url: string): TextInfo =
    return fetchInfoByComponent("url", url, eqMatch[string])

proc fuzzyFetchInfoByUrl(url: string): TextInfo =
    return fetchInfoByComponent("url", url, inMatch[string])

proc fetchInfoNotChunked(): seq[TextInfo] =
    return fetchInfoByComponents[bool]("hasChunks", false, eqMatch[bool])

proc fetchInfoChunked(): seq[TextInfo] =
    return fetchInfoByComponents[bool]("hasChunks", true, eqMatch[bool])

proc fetchInfoByChunkSeparator(sep: string): seq[TextInfo] =
    return fetchInfoByComponents[string]("chunkSeparator", sep, eqMatch[string])

proc fuzzyFetchInfoByChunkSeparator(sep: string): seq[TextInfo] =
    return fetchInfoByComponents[string]("chunkSeparator", sep, inMatch[string])

