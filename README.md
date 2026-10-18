# Martin's Homebrew tap

Install [Expensify CLI](https://github.com/magarcia/expensify-cli) with Homebrew:

```sh
brew install magarcia/tap/expensify
expensify --version
expensify auth login
```

Expensify supports macOS and Linux on Apple Silicon/ARM64 and Intel/AMD64. Homebrew selects the matching release binary and installs shell completions. See the [CLI documentation](https://github.com/magarcia/expensify-cli#readme) for authentication and commands.

Upgrade:

```sh
brew update
brew upgrade expensify
```

## Available formulae

| Formula | Install | Description |
|---------|---------|-------------|
| [expensify](https://github.com/magarcia/expensify-cli) | `brew install magarcia/tap/expensify` | Manage Expensify expenses, reports, and workspaces |
| [cali](https://github.com/magarcia/cali) | `brew install magarcia/tap/cali` | View calendar events in the terminal |
| [cc2md](https://github.com/magarcia/cc2md) | `brew install magarcia/tap/cc2md` | Convert Claude Code session logs to Markdown |
| [snapwin](https://github.com/magarcia/snapwin) | `brew install magarcia/tap/snapwin` | Capture macOS window screenshots |

The full install commands add this tap automatically. To browse it first:

```sh
brew tap magarcia/tap
brew search magarcia/tap/
```

## Updating Expensify

The [Update Expensify workflow](https://github.com/magarcia/homebrew-tap/actions/workflows/update-expensify.yml) checks for stable CLI releases hourly. It runs the updater tests, updates the formula's version and release checksums, and validates it with Homebrew before pushing. You can also run it manually from GitHub Actions.

The [Expensify workflow](https://github.com/magarcia/homebrew-tap/actions/workflows/expensify.yml) checks installation on macOS and Linux, both ARM64 and AMD64. It runs for relevant pull requests, pushes, and manual runs. Automatic formula updates start it explicitly after pushing.

To prepare an update locally:

```sh
python3 -m unittest discover -s scripts -p 'test_*.py'
./scripts/update-expensify
git diff -- Formula/expensify.rb
```

The updater reads the latest stable release from `magarcia/expensify-cli`. Set `GH_TOKEN` if you need authenticated GitHub API requests.

## Development

Use Homebrew's tap checkout for local installation checks. Edit the formula there before running these checks:

```sh
brew tap magarcia/tap
cd "$(brew --repo magarcia/tap)"
brew style Formula/expensify.rb
brew install magarcia/tap/expensify
brew test magarcia/tap/expensify
brew audit --strict magarcia/tap/expensify
```

If Expensify is already installed, use `brew reinstall magarcia/tap/expensify` to test the changed formula.
