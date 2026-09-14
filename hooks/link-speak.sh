#!/bin/sh
# Relinks `speak` onto PATH at each launch.
#
# The plugin's install path carries its version — .../selan-voice/0.1.2/skills/... — so a link
# made by hand dangles the moment the next version lands, and `speak` then answers "No such file
# or directory" rather than saying it was never relinked. Doing it per session is what makes an
# update invisible.
set -u

script="${CLAUDE_PLUGIN_ROOT:-}/skills/voice/scripts/speak.sh"
[ -x "$script" ] || exit 0

target="$HOME/.local/bin/speak"

# Only ever replace our own link. A `speak` that is a real file, or a link into something else,
# belongs to whoever put it there — a plugin that silently took it would be a worse bug than the
# one this fixes.
if [ -e "$target" ] || [ -L "$target" ]; then
  case "$(readlink "$target" 2>/dev/null || echo '')" in
    */selan-voice/*/skills/voice/scripts/speak.sh) ;;
    *) exit 0 ;;
  esac
fi

mkdir -p "$HOME/.local/bin" 2>/dev/null || exit 0
ln -sfn "$script" "$target" 2>/dev/null || exit 0

# Said once rather than left as a command that is not found: the link is right, the directory it
# is in is not somewhere this shell looks.
case ":${PATH-}:" in
  *":$HOME/.local/bin:"*) ;;
  *) printf '{"systemMessage":"selan-voice: linked %s, but ~/.local/bin is not on your PATH — add it, or call the skill instead."}\n' "$target" ;;
esac
