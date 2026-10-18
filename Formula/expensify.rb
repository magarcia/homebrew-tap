class Expensify < Formula
  desc "Manage New Expensify expenses, reports, and workspaces"
  homepage "https://github.com/magarcia/expensify-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.2.0/expensify_v0.2.0_darwin_arm64.tar.gz"
      sha256 "4781b3c4fd5e402a26d506bd2270d7ff89de746db538debe4244f1bc825313af"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.2.0/expensify_v0.2.0_darwin_amd64.tar.gz"
      sha256 "c68806b291c87a71852441fd1bcbd4fb0730014b74caf9bb25f8e1383f91254a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.2.0/expensify_v0.2.0_linux_arm64.tar.gz"
      sha256 "dcfa15078aaa5b345782b2f6ffde48e60bf0d7f2a6ce3c030a927c9519812ac6"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.2.0/expensify_v0.2.0_linux_amd64.tar.gz"
      sha256 "b86b86399a176c738b023d94e4a2c76ebdfec6a98dc07cfc000cd20fded994be"
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
