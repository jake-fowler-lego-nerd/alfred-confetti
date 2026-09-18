# Confetti

An Alfred workflow that fires a confetti cannon across your screen — two bursts from the bottom corners, crossing in the middle. Use it when you need to celebrate a quick win.

Native macOS UI, not a shell trick: the whole effect is a Swift script (run via Alfred's `/usr/bin/swift` Run Script language) that drops a borderless, click-through window at screen-saver level and drives two `CAEmitterLayer`s from it.

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

- macOS with Xcode Command Line Tools installed (provides `/usr/bin/swift`). On a Mac that's never had them, running the workflow the first time will prompt to install them rather than firing confetti.
- Alfred 5 with Powerpack (Run Script actions with a language other than a shell require Powerpack).

## License

MIT — see [LICENSE](LICENSE).
