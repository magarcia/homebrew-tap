class Expensify < Formula
  desc "Manage New Expensify expenses, reports, and workspaces"
  homepage "https://github.com/magarcia/expensify-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.2/expensify_v0.3.2_darwin_arm64.tar.gz"
      sha256 "0c5d57f5fbff01311d3936e3d3d7005a4bc3a6fa471477f5654e20ea254fe3ee"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.2/expensify_v0.3.2_darwin_amd64.tar.gz"
      sha256 "b62390d3ecb559c84374686570aee9065b7a13114c7c397b4af392821282b16a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.2/expensify_v0.3.2_linux_arm64.tar.gz"
      sha256 "c1ef5dcf9900838141f5ee464d279c48eff7a88e7bf0b72ddfa587134cd760d6"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.3.2/expensify_v0.3.2_linux_amd64.tar.gz"
      sha256 "c815a05794d3b0f7f5eb9c4b216c09d6cda68cd32303af554e93500728dc2bea"
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
