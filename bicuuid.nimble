# Package
version       = "0.1.0"
author        = "Hendrik Albers"
description   = "Add uuids to bic files"
license       = "MIT"
srcDir        = "src"
bin           = @["bicuuid"]


# Dependencies
requires "nim >= 1.4.8"
requires "neverwinter >= 1.4.4"
requires "https://github.com/hendrikgit/nim-uuidv4#0.1.0"
