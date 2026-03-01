# homebrew-tap

This is Martin's Homebrew tap for installing various CLI tools.

## Installation

```bash
brew tap magarcia/tap
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| [`cali`](https://github.com/magarcia/cali) | Calendar CLI - View your calendar events in the terminal |
| [`cc2md`](https://github.com/magarcia/cc2md) | Convert Claude Code session logs into clean, readable markdown |
| [`snapwin`](https://github.com/magarcia/snapwin) | macOS CLI for capturing window screenshots |

## Usage

After tapping, install a formula:

```bash
brew install magarcia/tap/cali
brew install magarcia/tap/cc2md
brew install magarcia/tap/snapwin
```

## Development

To test changes locally:

```bash
brew install --build-from-element Formula/cali.rb
brew test Formula/cali.rb
```
