class Cc2md < Formula
  desc "Convert Claude Code session logs into clean, readable markdown"
  homepage "https://github.com/magarcia/cc2md"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/magarcia/cc2md/releases/download/v#{version}/cc2md_Darwin_arm64.tar.gz"
      sha256 "205337b740a0c5c73ad4937d89ad1a6f3ac83108b163b076f5a094ce80ca4b37"
    else
      url "https://github.com/magarcia/cc2md/releases/download/v#{version}/cc2md_Darwin_x86_64.tar.gz"
      sha256 "75614515ee9bec945a0652bf666f2c9629ffd93bba3e2fdfa0fc4fba4a0f623a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/magarcia/cc2md/releases/download/v#{version}/cc2md_Linux_arm64.tar.gz"
      sha256 "a190a7415527bdb1956b03d52f4ceb8710e65b21757511d242f8a8aa981e2f0e"
    else
      url "https://github.com/magarcia/cc2md/releases/download/v#{version}/cc2md_Linux_x86_64.tar.gz"
      sha256 "be3a9d889022f6ea90af0ec2dc71bbd053e7c46fa30645f388455a397f08b572"
    end
  end

  def install
    bin.install "cc2md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cc2md --version")
  end
end
