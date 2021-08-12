import os, streams, strformat, tables
import neverwinter/gff

proc toBicGffRoot(filename: string): GffRoot
proc name(bic: GffRoot): string
proc get(locstring: GffCExoLocString, lang: Language = Language.English): string

if paramCount() == 0:
  echo "Provide paths to bic files as arguments"
  quit(QuitSuccess)

var bics = newSeq[(string, GffRoot)]()
for p in commandLineParams():
  if not fileExists(p):
    echo &"File \"{p}\" not found"
    quit(QuitFailure)
  bics &= (p, p.toBicGffRoot)

for (fn, bic) in bics:
  echo &"{fn}: {bic.name}"

proc toBicGffRoot(filename: string): GffRoot =
  try:
    result = filename.openFileStream.readGffRoot(false)
  except ValueError:
    echo &"File \"{filename}\" ist not a GFF file"
    quit(QuitFailure)
  if result.fileType != "BIC ":
    echo &"File \"{filename}\" ist not a BIC file"
    quit(QuitFailure)

proc name(bic: GffRoot): string =
  let first = bic["FirstName", GffCExoLocString].get
  if first != "":
    first & " " & bic["LastName", GffCExoLocString].get
  else:
    first

proc get(locstring: GffCExoLocString, lang: Language = Language.English): string =
  locstring.entries.getOrDefault(ord(lang), locstring.entries.getOrDefault(ord(Language.English)))