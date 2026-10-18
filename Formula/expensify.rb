class Expensify < Formula
  desc "Manage New Expensify expenses, reports, and workspaces"
  homepage "https://github.com/magarcia/expensify-cli"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.1.0/expensify_v0.1.0_darwin_arm64.tar.gz"
      sha256 "d841cc8d031a189c98f17d5765abdd4d98cc3185d1b19a7d49ac5d6bf78b19bb"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.1.0/expensify_v0.1.0_darwin_amd64.tar.gz"
      sha256 "b1baaf2e1e04d3aa3ea83aa18654e446a8071e88ddfb0b01bd6a6ecd93cbb99e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.1.0/expensify_v0.1.0_linux_arm64.tar.gz"
      sha256 "ba03965b8ba6e3c20ca04a60fa762830c5fb312574b23ee89dc95e2c2423a8e4"
    end

    on_intel do
      url "https://github.com/magarcia/expensify-cli/releases/download/v0.1.0/expensify_v0.1.0_linux_amd64.tar.gz"
      sha256 "288c489f58af0bc5dfb07165f1a6d1f8bdbd70d10b4433c88e29ffaa0e379bee"
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
