#!/usr/bin/env bash
# Speaks Claude's last reply — or piped text — through the Selan voice gateway.
#
# The gateway holds the company's provider key and picks the model, voice and
# format, so this sends the text and nothing else. Naming a model or a voice
# here would be refused with 400.
set -euo pipefail

usage() {
  cat >&2 <<'TXT'
usage: speak [--print] [--save FILE] [--quiet]

  speak                  speak Claude's last reply in this project
  speak --print          show what that would say, spending nothing
  git log -1 --format=%s | speak

  --save FILE   write the audio there and keep it
  --quiet       synthesize without playing

env: SELAN_API_KEY (or ANTHROPIC_AUTH_TOKEN), SELAN_VOICE_URL
TXT
}

# Resolved through the symlink in ~/.local/bin, so the transcript reader is
# found in the skill directory rather than beside the link.
self=${BASH_SOURCE[0]}
while [ -L "$self" ]; do
  target=$(readlink "$self")
  case $target in
    /*) self=$target ;;
    *) self=$(cd -- "$(dirname -- "$self")" && pwd -P)/$target ;;
  esac
done
here=$(cd -- "$(dirname -- "$self")" && pwd -P)

save=""
quiet=false
print=false
while [ "$#" -gt 0 ]; do
  case $1 in
    --save) save=${2:-}; [ -n "$save" ] || { usage; exit 64; }; shift 2 ;;
    --quiet) quiet=true; shift ;;
    --print) print=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "speak: speak reads the last reply or stdin; it takes no text argument" >&2; usage; exit 64 ;;
  esac
done

# A pipe that actually carried something, otherwise read back what Claude just
# said. Emptiness rather than isatty decides: stdin is not a terminal under CI,
# under `!` in Claude Code, or anywhere else this gets called.
text=""
if [ ! -t 0 ]; then
  text=$(cat)
fi

if [ -z "${text//[[:space:]]/}" ]; then
  # Claude Code stores a project's transcripts under a slug of its path.
  project=${PWD//[\/.]/-}
  transcripts=${CLAUDE_CONFIG_DIR:-$HOME/.claude}/projects/$project
  newest=$(ls -t "$transcripts"/*.jsonl 2>/dev/null | head -1 || true)
  if [ -z "$newest" ]; then
    echo "speak: nothing to say, and no Claude transcript for $PWD" >&2
    exit 66
  fi
  if ! text=$(awk -f "$here/last-reply.awk" "$newest"); then
    echo "speak: that transcript has no reply worth reading aloud" >&2
    exit 66
  fi
  # Said before the spend, because a long reply is a long sit. Measured on this
  # voice: 819 characters came back as 63 seconds, so about 13 a second. The
  # threshold is half a minute — past that, a summary is usually what was
  # wanted.
  seconds_estimate=$(( ${#text} / 13 ))
  if [ "$print" = false ] && [ "$seconds_estimate" -gt 30 ]; then
    echo "speak: ${#text} characters, about ${seconds_estimate}s — ctrl-c and ask for a summary instead" >&2
  fi
fi

if [ "$print" = true ]; then
  printf '%s\n' "$text"
  exit 0
fi

# The transcript path can still come back blank if the reply was all code.
if [ -z "${text//[[:space:]]/}" ]; then
  echo "speak: nothing to say" >&2
  exit 64
fi

url=${SELAN_VOICE_URL:-https://gw.selan.ai}
token=${SELAN_API_KEY:-${ANTHROPIC_AUTH_TOKEN:-}}
if [ -z "$token" ]; then
  echo "speak: set SELAN_API_KEY (or ANTHROPIC_AUTH_TOKEN) to a Selan token" >&2
  exit 78
fi

anthropic_sdk_version=${ANTHROPIC_SDK_VERSION:-0.129.0}
user_agent="Anthropic SDK $anthropic_sdk_version"

audio=$(mktemp -t selan-voice)
headers=$(mktemp -t selan-voice-headers)
# The audio carries no credential, but it is a company's paid output.
trap 'rm -f "$audio" "$headers"' EXIT

# The text goes in over stdin, never argv: an argument is visible in a process
# listing to every other user on the machine.
status=$(
  printf '%s' "$text" \
    | awk -f "$here/request-body.awk" \
    | curl --silent --show-error \
        --output "$audio" --dump-header "$headers" --write-out '%{http_code}' \
        --max-time 120 \
        --request POST "$url/openai/v1/audio/speech" \
        --header "authorization: Bearer $token" \
        --header 'content-type: application/json' \
        --user-agent "$user_agent" \
        --data-binary @-
)

if [ "$status" != "200" ]; then
  echo "speak: the gateway answered $status" >&2
  # Selan's own refusal shape; it carries no credential.
  head -c 400 "$audio" >&2
  echo >&2
  exit 1
fi

# Reported so a caller can tie the spend to a line in the company's usage.
generation=$(awk 'BEGIN{IGNORECASE=1} /^x-generation-id:/ {sub(/\r$/,""); print $2}' "$headers")
bytes=$(wc -c < "$audio" | tr -d ' ')
# Seconds, not bytes: the listener is about to spend that, and a byte count
# says nothing about how long they will be sitting there.
if command -v ffprobe >/dev/null 2>&1; then
  seconds=$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$audio" 2>/dev/null | cut -d. -f1)
fi
echo "spoke ${seconds:+${seconds}s, }${bytes} bytes${generation:+ (generation $generation)}"

if [ -n "$save" ]; then
  cp "$audio" "$save"
  echo "saved $save"
fi

if [ "$quiet" = true ]; then
  exit 0
fi

if command -v afplay >/dev/null 2>&1; then
  afplay "$audio"
elif command -v ffplay >/dev/null 2>&1; then
  ffplay -nodisp -autoexit -loglevel error "$audio"
elif [ -z "$save" ]; then
  # Kept rather than discarded: the synthesis is already paid for.
  kept=${TMPDIR:-/tmp}/selan-voice-$$.mp3
  cp "$audio" "$kept"
  echo "no audio player found; saved to $kept" >&2
fi
