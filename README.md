# Confetti

Fires a confetti cannon across your screen — two bursts from the bottom corners, crossing in the middle. Use it when you need to celebrate a quick win.

## Usage

Fire a burst of confetti with the Hotkey `⌃⌥⌘C`.

![Confetti firing across the screen](images/screenshot.png)

Configure the Hotkey from the workflow's Triggers if `⌃⌥⌘C` conflicts with something else.

Alternatively, type the `confetti` keyword in Alfred.

## Configuration

Set these in the Workflow's Configuration (Alfred Preferences → Confetti → **Configure Workflow…**):

| Field | Default | Does |
| --- | --- | --- |
| Duration | `5` | How long the confetti stays on screen, in seconds. |
| Particle Count | `14` | Density of the confetti (particles emitted per second, per color). |
| Theme | `Standard` | Color palette. Options: **Standard** (full rainbow), **Neon**, **Pastel**, **Monochrome**, **Two Bit** (a custom orange/blue/gray palette). |

## Install

Download the latest `.alfredworkflow` from [Releases](../../releases) and double-click it.

## Requirements

- macOS (arm64 or Intel) — no Xcode Command Line Tools needed. Earlier versions of this workflow shipped the Swift source and ran it through `/usr/bin/swift`, which required Xcode CLT on the machine running it; as of v1.1.0 it ships as a precompiled, signed, notarized binary instead, so that's no longer necessary for anyone installing it.
- Alfred 5 with Powerpack (Run Script actions require Powerpack).

Building it from source yourself does need Xcode Command Line Tools (or full Xcode) plus a Developer ID certificate and notarization credentials — see [`build-binary.sh`](build-binary.sh).

## License

MIT — see [LICENSE](LICENSE).
