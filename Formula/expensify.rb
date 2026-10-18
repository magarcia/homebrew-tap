class Expensify < Formula
  desc "Manage New Expensify expenses, reports, and workspaces"
  homepage "https://github.com/magarcia/expensify-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.0/expensify_v0.3.0_darwin_arm64.tar.gz"
      sha256 "8ea1a7c690d15d4c124f7ce5c1b3d7dc455eadbffca05b1fcbddc7defdbd6256"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.0/expensify_v0.3.0_darwin_amd64.tar.gz"
      sha256 "1fcfd14ad462c349ebc4e98c3dc1132fb52e8f5ef3127c2d2bc2d25a4044d65b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.0/expensify_v0.3.0_linux_arm64.tar.gz"
      sha256 "c716cc208780098c08d43782f96ee764f205abe3552c76ca4d4d5ad31658fc3a"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.0/expensify_v0.3.0_linux_amd64.tar.gz"
      sha256 "97d001c9ebbe38515b696037847814f04fa032c54f0eb36830143f66ec3a1da7"
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
