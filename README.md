# selan-voice

Hear Claude's answers. A [Claude Code](https://claude.com/claude-code) plugin
that speaks the last reply aloud through your company's [Selan](https://selan.ai)
voice gateway.

```
/plugin marketplace add selan-ai/selan-voice
/plugin install selan-voice@selan-voice
```

Then ask Claude to read something out, or run it yourself:

```bash
speak            # speak the last reply
speak --print    # show what it would say, spending nothing
```

## What it does

Claude's answers are written to be read. Speech is linear — you cannot skim it,
and a code block read aloud is noise. So the text is stripped before it is sent:
a code block becomes "code", a link becomes its text, tables are dropped. Run
`--print` first and you will see exactly what would be spoken, without spending
anything.

Above roughly 30 seconds it tells you the estimate before synthesising, because
a long answer is usually better asked for as a summary than listened to whole.

## What it sends

The text, and nothing else.

The model, the voice, the audio format and the input limit are your company's
configuration, held by the gateway. A request that named its own model would be
refused with 400 — the person running `speak` does not get to pick, and does not
need to know which provider is behind it.

Your provider key never reaches this machine. The gateway holds it, checks the
company is entitled to voice, records what the request cost, and returns audio.

## Setup

| Variable | Meaning |
| --- | --- |
| `SELAN_API_KEY` | Your Selan token. Falls back to `ANTHROPIC_AUTH_TOKEN`. |
| `SELAN_VOICE_URL` | The gateway. Defaults to `https://gw.selan.ai`. |

An owner switches voice on for the company in Selan; until then every request
answers `403`, which is the correct answer rather than an error to retry.

For the short `speak` command, link it:

```bash
ln -sf ~/.claude/plugins/cache/*/selan-voice/*/skills/voice/scripts/speak.sh ~/.local/bin/speak
```

The cache path carries the version, so re-run that after a plugin update. Asking
Claude to read something out needs no link — the skill calls the script by its
own path.

## Requirements

`curl` and `awk`, both of which you already have. No node, no python, no jq —
deliberately, so the plugin works on a machine that has none of them.

Playback uses `afplay` on macOS or `ffplay` where that exists. With neither, the
audio is saved and the path printed rather than discarded, because the synthesis
is already paid for.

## Privacy

The text you speak goes to your company's Selan gateway and on to the configured
provider. Nothing else leaves the machine: no telemetry, no analytics, and the
text is passed to `curl` over stdin rather than as an argument, so it does not
appear in the process list.

## Licence

MIT
