# Package

version = "0.1.0"
author = "Qm Auber"
description = "Ancient Greek Search Engine"
license = "MIT"
srcDir = "src"
installExt = @["nim"]
bin = @["agsearch.out"]
binDir = "bin"

backend = "cpp"

# Dependencies

requires "nim >= 1.0.2"

task docs, "Generate documentation":
    exec "rm -R docs/*"
    exec "nim doc --project --index:on --outdir:docs  src/agsearch.nim"
    exec "nim buildIndex -o:docs/theindex.html docs"
