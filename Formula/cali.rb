class Cali < Formula
  desc "Calendar CLI - View your calendar events in the terminal"
  homepage "https://github.com/magarcia/cali"
  version "0.3.0"
  license "MIT"

  on_macos do
    url "https://github.com/magarcia/cali/releases/download/v#{version}/cali-#{version}-aarch64-apple-darwin.tar.gz"
    sha256 "e3cff3d87beff0b87d07f7d95b21a3c8c59ed751439714a382ae4dce260cfe25"
  end


  def install
    bin.install "cali"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cali --version")
  end
end
