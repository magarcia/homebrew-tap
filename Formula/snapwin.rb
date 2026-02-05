class Snapwin < Formula
  desc "macOS CLI for capturing window screenshots"
  homepage "https://github.com/magarcia/snapwin"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/magarcia/snapwin/releases/download/v#{version}/snapwin-#{version}-arm64-macos.tar.gz"
      sha256 "5d8ce5b5fdb5035263d0df09f0d9d961e839cf234bd46b0c3d9740d2bd7abb3a"
    else
      url "https://github.com/magarcia/snapwin/releases/download/v#{version}/snapwin-#{version}-x86_64-macos.tar.gz"
      sha256 "66a29044dd057a886e650b8f8053d1b5bddc1cb6364fe760041ed856bbd66f7b"
    end
  end

  def install
    bin.install "snapwin"
  end

  test do
    assert_match "snapwin", shell_output("#{bin}/snapwin --help 2>&1", 1)
  end
end
