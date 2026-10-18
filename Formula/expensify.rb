class Expensify < Formula
  desc "Manage New Expensify expenses, reports, and workspaces"
  homepage "https://github.com/magarcia/expensify-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.1/expensify_v0.3.1_darwin_arm64.tar.gz"
      sha256 "20d3966c4ca16d76cb9c92cedb684aa59a72cccf0029dd908021b332ccc2e521"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.1/expensify_v0.3.1_darwin_amd64.tar.gz"
      sha256 "42af0dfa7781e5d196ca1ae6d3ce2d1156232ffca5e8c8dae8ce1167b42c1bba"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.1/expensify_v0.3.1_linux_arm64.tar.gz"
      sha256 "970e4e0d09b43b3b0f6ccd55f03bdcd8a49095ba468e23975d50a1c47df94aab"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.1/expensify_v0.3.1_linux_amd64.tar.gz"
      sha256 "9b3e77122e5ee356976d5d00db9c42c5585582cffeffddc96644365396bce0f6"
    end
  end

  def install
    bin.install "expensify"
    bash_completion.install "completions/expensify.bash" => "expensify"
    zsh_completion.install "completions/_expensify"
    fish_completion.install "completions/expensify.fish"
    doc.install "README.md", "THIRD_PARTY_NOTICES", "docs"
    pkgshare.install "skills"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/expensify --version")

    output = shell_output(
      "#{bin}/expensify expense create --amount 1234 --currency USD " \
      "--merchant Homebrew --date 2026-10-18 --dry-run --no-input " \
      "--output llm --config-dir #{testpath}/config",
    )
    assert_match "- command: expense create", output
    assert_match "- dryRun: true", output
    assert_match '"amount":"1234"', output
    assert_match '"merchant":"Homebrew"', output
    assert_path_exists pkgshare/"skills/expensify/SKILL.md"
  end
end
