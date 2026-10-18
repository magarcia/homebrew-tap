# homebrew-tap

This is Martin's Homebrew tap for installing various CLI tools.

## Installation

Install Cuéntica CLI on macOS or Linux:

```bash
brew install magarcia/tap/cuentica
cuentica --version
```

This adds the tap automatically and installs the release binary and Bash, Zsh, and Fish completions. Intel/AMD and ARM64 are supported. Upgrade with `brew update` followed by `brew upgrade magarcia/tap/cuentica`.

To add the tap separately:

```bash
brew tap magarcia/tap
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| [`cali`](https://github.com/magarcia/cali) | Calendar CLI - View your calendar events in the terminal |
| [`cc2md`](https://github.com/magarcia/cc2md) | Convert Claude Code session logs into clean, readable markdown |
| [`cuentica`](https://github.com/magarcia/cuentica-cli) | Manage Cuéntica invoices, income, expenses, contacts, and documents |
| [`snapwin`](https://github.com/magarcia/snapwin) | macOS CLI for capturing window screenshots |

## Usage

After tapping, install a formula:

```bash
brew install magarcia/tap/cali
brew install magarcia/tap/cc2md
brew install magarcia/tap/cuentica
brew install magarcia/tap/snapwin
```

## Development

Keep the development checkout in `~/dev/homebrew-tap`:

```bash
git clone https://github.com/magarcia/homebrew-tap.git ~/dev/homebrew-tap
cd ~/dev/homebrew-tap
```

The Cuéntica workflow tests installation, completions, functional behavior, style, and audits on macOS and Linux for both architectures. After publishing a formula change, check Homebrew's updated copy:

```bash
brew update
brew reinstall magarcia/tap/cuentica
brew test magarcia/tap/cuentica
brew audit --strict --online magarcia/tap/cuentica
```

For each stable Cuéntica release, update `Formula/cuentica.rb` with its version and the four archive SHA-256 values from `checksums.txt`. See the [Cuéntica release guide](https://github.com/magarcia/cuentica-cli/blob/main/docs/releasing.md#update-homebrew).
