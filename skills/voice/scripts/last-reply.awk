# Prints Claude's most recent reply in this project, stripped for speech.
#
# awk rather than a JSON library: this ships as a skill, and a machine with
# Claude Code on it is not guaranteed to have node, python or jq. The scanner
# below respects backslash escapes, so a reply containing a quote or a newline
# survives the round trip.

# The value of the next JSON string starting at position `from` in `line`,
# with its escapes resolved. Returns "" when the string is unterminated.
function jsonString(line, from,   out, c, n) {
  out = ""
  n = length(line)
  while (from <= n) {
    c = substr(line, from, 1)
    if (c == "\"") return out
    if (c == "\\") {
      from++
      c = substr(line, from, 1)
      if (c == "n") out = out "\n"
      else if (c == "t") out = out "\t"
      else if (c == "r") out = out "\r"
      else if (c == "u") { out = out " "; from += 4 }
      else out = out c
    } else {
      out = out c
    }
    from++
  }
  return out
}

# Every "text" part of one transcript line, concatenated in order. A turn that
# only called a tool has none, which is why the caller keeps looking.
function replyOf(line,   at, out, part) {
  out = ""
  at = index(line, "\"type\":\"text\",\"text\":\"")
  while (at > 0) {
    part = jsonString(line, at + length("\"type\":\"text\",\"text\":\""))
    out = out part
    line = substr(line, at + 1)
    at = index(line, "\"type\":\"text\",\"text\":\"")
  }
  return out
}

# Markdown that carries meaning on screen and none in the ear.
function forSpeech(s) {
  gsub(/```[^`]*```/, " code ", s)
  gsub(/`/, "", s)
  gsub(/!\[[^]]*\]\([^)]*\)/, " image ", s)
  gsub(/\]\([^)]*\)/, "]", s)
  gsub(/\[/, "", s); gsub(/\]/, "", s)
  gsub(/https?:\/\/[^ ]*/, " link ", s)
  gsub(/\*\*/, "", s); gsub(/\*/, "", s)
  gsub(/^[ \t]*#+[ \t]*/, "", s)
  gsub(/\n[ \t]*#+[ \t]*/, "\n", s)
  gsub(/\n[ \t]*\|[^\n]*/, "", s)
  gsub(/\n[ \t]*[-*+][ \t]+/, "\n", s)
  gsub(/\n[ \t]*[0-9]+\.[ \t]+/, "\n", s)
  gsub(/\n[ \t]*[-=][-=][-=]+[ \t]*/, "\n", s)
  gsub(/[ \t][ \t]+/, " ", s)
  gsub(/\n\n+/, "\n", s)
  sub(/^[ \t\n]+/, "", s)
  sub(/[ \t\n]+$/, "", s)
  return s
}

# Kept, not printed: only the last one is wanted, and it is only known at EOF.
/"type":"assistant"/ {
  if ($0 ~ /"isSidechain":true/) next
  candidate = replyOf($0)
  if (candidate ~ /[^ \t\n]/) last = candidate
}

END {
  if (last == "") exit 66
  spoken = forSpeech(last)
  if (spoken !~ /[^ \t\n]/) exit 66
  print spoken
}
