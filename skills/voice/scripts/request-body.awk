# Wraps stdin in {"input": "..."} — the whole request body the gateway takes.
#
# awk rather than a JSON library, for the reason given in last-reply.awk: a
# machine running Claude Code is not guaranteed to have node, python or jq.

function esc(s,   out, i, c, n) {
  out = ""
  n = length(s)
  for (i = 1; i <= n; i++) {
    c = substr(s, i, 1)
    if (c == "\\") out = out "\\\\"
    else if (c == "\"") out = out "\\\""
    else if (c == "\n") out = out "\\n"
    else if (c == "\t") out = out "\\t"
    else if (c == "\r") out = out "\\r"
    # Multi-byte UTF-8 passes through: JSON takes it verbatim, and splitting a
    # sequence to escape it is what would break an accented character.
    else out = out c
  }
  return out
}

{ body = (NR == 1) ? $0 : body "\n" $0 }

END { printf "{\"input\":\"%s\"}", esc(body) }
