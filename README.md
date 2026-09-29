| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
# selan-voice
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
Hear Claude's answers. A [Claude Code](https://claude.com/claude-code) plugin
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
that speaks the last reply aloud through your company's [Selan](https://selan.ai)
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
voice gateway.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
```
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
/plugin marketplace add selan-ai/selan-voice
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
/plugin install selan-voice@selan-voice
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
```
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
Then ask Claude to read something out. For a `speak` command of your own, link it
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
first — see [Setup](#setup); until you do, `speak` is not a command yet.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
```bash
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
speak            # speak the last reply
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
speak --print    # show what it would say, spending nothing
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
```
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
## What it does
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
Claude's answers are written to be read. Speech is linear — you cannot skim it,
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
and a code block read aloud is noise. So the text is stripped before it is sent:
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
a code block becomes "code", a link becomes its text, tables are dropped. Run
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
`--print` first and you will see exactly what would be spoken, without spending
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
anything.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
Above roughly 30 seconds it tells you the estimate before synthesising, because
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
a long answer is usually better asked for as a summary than listened to whole.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
## What it sends
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
The text, and nothing else.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
The model, the voice, the audio format and the input limit are your company's
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
configuration, held by the gateway. A request that named its own model would be
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
refused with 400 — the person running `speak` does not get to pick, and does not
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
need to know which provider is behind it.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
Your provider key never reaches this machine. The gateway holds it, checks the
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
company is entitled to voice, records what the request cost, and returns audio.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
## Setup
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
| Variable | Meaning |
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
| --- | --- |
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
| `SELAN_API_KEY` | Your Selan token. Falls back to `ANTHROPIC_AUTH_TOKEN`. |
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
| `SELAN_VOICE_URL` | The gateway. Defaults to `https://gw.selan.ai`. |
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
An owner switches voice on for the company in Selan; until then every request
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
answers `403`, which is the correct answer rather than an error to retry.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
`speak` lands on PATH by itself. A `SessionStart` hook relinks
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
`~/.local/bin/speak` at each launch, so an update never leaves a stale link —
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
the cache path carries the plugin's version.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
```bash
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
speak --print   # prove it resolves; spends nothing
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
```
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
If that says "command not found", `~/.local/bin` is not on your PATH — the hook
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
says so too. The link is only a convenience: asking Claude to read something out
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
needs none of it, because the skill calls the script by its own path.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
The hook will not take a `speak` that is not its own. A real file there, or a
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
link pointing elsewhere, is left where it is.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
## Requirements
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
`curl` and `awk`, both of which you already have. No node, no python, no jq —
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
deliberately, so the plugin works on a machine that has none of them.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
Playback uses `afplay` on macOS or `ffplay` where that exists. With neither, the
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
audio is saved and the path printed rather than discarded, because the synthesis
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
is already paid for.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
## Privacy
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
The text you speak goes to your company's Selan gateway and on to the configured
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
provider. Nothing else leaves the machine: no telemetry, no analytics, and the
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
text is passed to `curl` over stdin rather than as an argument, so it does not
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
appear in the process list.
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
## Licence
| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |

| `ANTHROPIC_SDK_VERSION` | The version in the `Anthropic SDK <version>` user agent. Defaults to `0.129.0`. |
MIT
