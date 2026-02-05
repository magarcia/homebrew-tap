class Cali < Formula
  desc "Calendar CLI - View your calendar events in the terminal"
  homepage "https://github.com/magarcia/cali"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/magarcia/cali/releases/download/v#{version}/cali-#{version}-aarch64-apple-darwin.tar.gz"
      sha256 "456814b70d72e39c51259a96a882f5e2ed0c577d356dc22d78987b85bf49d66b"
    else
      odie "Cali is currently only available for ARM64 (Apple Silicon) Macs."
    end
  end

  def install
    bin.install "cali"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cali --version")
  end
end
