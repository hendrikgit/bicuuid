import os, streams, strformat, tables
import neverwinter/gff
import uuidv4

proc toBicGffRoot(filename: string): GffRoot
proc name(bic: GffRoot): string
proc get(locstring: GffCExoLocString, lang: Language = Language.English): string

if paramCount() == 0:
  stderr.writeLine "Provide paths to bic files as arguments"
  quit(QuitSuccess)

for fn in commandLineParams():
  if not fileExists(fn):
    stderr.writeLine &"File \"{fn}\" not found"
    quit(QuitFailure)
  let bic = fn.toBicGffRoot
  var uuid = bic["UUID", "".GffCExoString]
  let existing = uuid != ""
  if not existing:
    uuid = getUUID()
    bic["UUID", GffCExoString] = uuid
    let fs = fn.openFileStream(mode = fmWrite)
    fs.write(bic)
    fs.close
  echo &"\"{fn}\",\"{bic.name}\",{uuid}," & (if existing: "existing" else: "generated")

proc toBicGffRoot(filename: string): GffRoot =
  try:
    let fs = filename.openFileStream
    result = fs.readGffRoot(false)
    fs.close
  except ValueError:
    stderr.writeLine &"File \"{filename}\" ist not a GFF file"
    quit(QuitFailure)
  if result.fileType != "BIC ":
    stderr.writeLine &"File \"{filename}\" ist not a BIC file"
    quit(QuitFailure)

proc name(bic: GffRoot): string =
  let first = bic["FirstName", GffCExoLocString].get
  let last = bic["LastName", GffCExoLocString].get
  if first != "":
    result = first
    if last != "": result &= " " & last
  else:
    if last != "": result = last

proc get(locstring: GffCExoLocString, lang: Language = Language.English): string =
  locstring.entries.getOrDefault(ord(lang), locstring.entries.getOrDefault(ord(Language.English)))
