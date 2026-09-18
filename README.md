# Confetti

An Alfred workflow that fires a confetti cannon across your screen — two bursts from the bottom corners, crossing in the middle. Use it when you need to celebrate a quick win.

![Confetti firing across the screen](screenshot.png)

Native macOS UI, not a shell trick: the effect ([`confetti.swift`](confetti.swift)) drops a borderless, click-through window at screen-saver level and drives two `CAEmitterLayer`s from it. It ships as a **signed, notarized, universal (arm64 + x86_64) binary** — see [`build-binary.sh`](build-binary.sh) for how it's built.

## Install

Download the latest `.alfredworkflow` from [Releases](../../releases) and double-click it.

## Usage

Default hotkey: `⌃⌥⌘C` (Control+Option+Command+C). Change it from Alfred's workflow list if it conflicts with something else.

## Configuration

Open the workflow in Alfred Preferences and click **Configure Workflow…** to set:

| Field | Default | Does |
| --- | --- | --- |
| Duration | `5` | How long the confetti stays on screen, in seconds. |
| Particle Count | `14` | Density of the confetti (particles emitted per second, per color). |
| Theme | `Standard` | Color palette. Options: **Standard** (full rainbow), **Neon**, **Pastel**, **Monochrome**, **Two Bit** (a custom orange/blue/gray palette). |

## Requirements

- macOS (arm64 or Intel) — no Xcode Command Line Tools needed. Earlier versions of this workflow shipped the Swift source and ran it through `/usr/bin/swift`, which required Xcode CLT on the machine running it; as of v1.1.0 it ships as a precompiled, signed, notarized binary instead, so that's no longer necessary for anyone installing it.
- Alfred 5 with Powerpack (Run Script actions require Powerpack).

Building it from source yourself does need Xcode Command Line Tools (or full Xcode) plus a Developer ID certificate and notarization credentials — see [`build-binary.sh`](build-binary.sh).

## License

MIT — see [LICENSE](LICENSE).
