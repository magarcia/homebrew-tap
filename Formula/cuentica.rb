class Cuentica < Formula
  desc "Command-line client for the Cuéntica API"
  homepage "https://github.com/magarcia/cuentica-cli"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/magarcia/cuentica-cli/releases/download/v#{version}/cuentica_v#{version}_darwin_arm64.tar.gz"
      sha256 "b54741f226d9303a150afae1f216e07d1076cdb7deea47dba0f2bf38a9880feb"
    end
    on_intel do
      url "https://github.com/magarcia/cuentica-cli/releases/download/v#{version}/cuentica_v#{version}_darwin_amd64.tar.gz"
      sha256 "b229b81ad307b19d16409275f7bb88f46a386e56daa5e7773625a9acd71ff271"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/magarcia/cuentica-cli/releases/download/v#{version}/cuentica_v#{version}_linux_arm64.tar.gz"
      sha256 "f6a3ae24e79ccb1c23f3d10e08d6072fa67abec999142ee50a455f6082892ee1"
    end
    on_intel do
      url "https://github.com/magarcia/cuentica-cli/releases/download/v#{version}/cuentica_v#{version}_linux_amd64.tar.gz"
      sha256 "a4dc0ab1b5c008b5ac147abacff0b84d751b538c2e7db239ff8a30d5b160f4f8"
    end
  end

  def install
    bin.install "cuentica"
    doc.install "README.md", "LICENSE", "THIRD_PARTY_NOTICES"
    generate_completions_from_executable(bin/"cuentica", "completion")
  end

  test do
    ENV["CUENTICA_API_KEY"] = ""
    assert_match "cuentica v#{version}", shell_output("#{bin}/cuentica --version")
    assert_path_exists bash_completion/"cuentica"
    assert_path_exists zsh_completion/"_cuentica"
    assert_path_exists fish_completion/"cuentica.fish"

    output = shell_output("#{bin}/cuentica document update --id 123 " \
                          "--field date=2026-10-17 --dry-run --no-input --output json")
    request = JSON.parse(output)
    assert_equal "PUT", request.fetch("method")
    assert_equal "/document/123", request.fetch("path")
    assert_equal "2026-10-17", request.fetch("body").fetch("date")
    refute request.fetch("requires_confirmation")
  end
end
