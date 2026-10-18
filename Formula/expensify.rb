class Expensify < Formula
  desc "Manage New Expensify expenses, reports, and workspaces"
  homepage "https://github.com/magarcia/expensify-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.1.2/expensify_v0.1.2_darwin_arm64.tar.gz"
      sha256 "199b1a914cb812a308417059ff94815e916cda95ebd1427cdb88d190216696f0"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.1.2/expensify_v0.1.2_darwin_amd64.tar.gz"
      sha256 "5c5628e955fd4033feb074152b240cee4fd1f7af9f0d006be6f5fb62710e2cd9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.1.2/expensify_v0.1.2_linux_arm64.tar.gz"
      sha256 "6a9a4b4a8a24572500073bd76413e6755c1a2dd501824ef778a3003a8bd13b22"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.1.2/expensify_v0.1.2_linux_amd64.tar.gz"
      sha256 "49a8fc5583cb95262ba4fae725701fb0af32efdef29ed79500113c10b6c20091"
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
