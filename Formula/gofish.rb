class Gofish < Formula
  desc "Cross-platform systems package manager"
  homepage "https://gofi.sh"
  url "https://github.com/fishworks/gofish.git",
      tag:      "v0.15.0",
      revision: "691768d1a77f2adb3e57271cddf6fea31cc6dadf"
  license "Apache-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gofish"
    sha256 cellar: :any_skip_relocation, mojave: "b9a02c3fb3ce8fec94c197b9cf57ea59407424cf4900eb7048dafacb5013be9c"
  end

  depends_on "go" => :build

  def install
    system "make"
    bin.install "bin/gofish"
  end

  def caveats
    <<~EOS
      To activate gofish, run:
        gofish init
    EOS
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/gofish version")
  end
end
