---
name: voice
description: Speaks Claude's last reply aloud through the Selan voice gateway. Use when the user asks to hear an answer, says "read that out", "speak", "say it aloud", or runs /voice.
allowed-tools: 'Bash, Read'
---

Read Claude's last reply out loud through the company's Selan voice gateway.

The gateway holds the company's provider key and picks the model, voice and
format. A request carries the text and nothing else — naming a model, a voice or
a format is refused with 400, because the company chose those and a caller may
not override them.

## Speak

```bash
"${CLAUDE_PLUGIN_ROOT}/skills/voice/scripts/speak.sh"
```

That reads the last reply in this project and speaks it. The options:

```bash
speak.sh --print          # show what it would say, spending nothing
speak.sh --save note.mp3  # keep the audio
speak.sh --quiet          # synthesize without playing
git log -1 --format=%s | speak.sh
```

It takes no text argument. To speak something other than the last reply, pipe
it in.

**Run `--print` first when the reply was mostly code.** Markdown that means
nothing aloud is replaced rather than spelled out — a code block becomes
"code", a link becomes its text, tables are dropped — so a reply that was all
code may leave nothing to say.

Above about 30 seconds it prints the estimate before spending, so a long reply
can be cancelled and asked for as a summary instead. Measured on Kokoro, 819
characters came back as 63 seconds.

## Setup

`SELAN_API_KEY` (or `ANTHROPIC_AUTH_TOKEN`) must hold a Selan token, and the
company must have voice switched on. `SELAN_VOICE_URL` overrides the gateway,
which defaults to `https://gw.selan.ai`.

For a shorter command, link it onto PATH. Run this **from a Claude Code session**,
where `CLAUDE_PLUGIN_ROOT` is set:

```bash
mkdir -p ~/.local/bin
ln -sfn "${CLAUDE_PLUGIN_ROOT:?run this from Claude Code}/skills/voice/scripts/speak.sh" ~/.local/bin/speak
```

The `:?` matters. In a plain terminal that variable is empty, and without the
guard the command happily links `speak` to `/skills/voice/scripts/speak.sh` — a
path that does not exist, so `speak` then answers "No such file or directory"
rather than saying it was never linked. From your own terminal, use the resolving
one-liner in the README instead.

That path carries the plugin version, so the link needs remaking after an update.
Nothing here depends on it — the commands above call the script directly.

Only `curl` and `awk` are needed — deliberately no node, python or jq.

## What to send when piping

**Send the answer, not the transcript.** Speech is linear and cannot be
skimmed, so what works on screen usually does not work aloud:

- Strip code blocks, paths, URLs and command lines — say what they did.
- Drop tables and bullet lists, or read only the line that carries the result.
- Keep it to a few sentences. Long output is the wrong medium; offer to speak a
  summary rather than reading the whole thing.

Say the outcome first: *"Merged. CI is green."* rather than *"I have now
completed the merge operation."*

## When not to speak

Do not speak unless asked. Text stays the primary channel — speech is an extra
one, never a replacement — and every request spends real credit against the
company's key.

## What the failures mean

| Status | Meaning |
| --- | --- |
| `401` | The token is missing or not valid for this gateway. |
| `403` | The company has not switched voice on, or its key cannot serve the configured model. |
| `400` | Empty text, or text past the configured character limit. |
| `502` | The provider refused, or the audio ran past the gateway's ceiling. |

A `403` is the ordinary state for a company that has not switched voice on. Say
so plainly rather than retrying.
