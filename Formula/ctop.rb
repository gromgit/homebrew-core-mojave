class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
      tag:      "v0.7.7",
      revision: "11a1cb10f416b4ca5e36c22c1acc2d11dbb24fb4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ctop"
    sha256 cellar: :any_skip_relocation, mojave: "7d3d0b8d4867f9f476996652451ea3ff26eea24b09fb3a52d7706fdd2a8cabd2"
  end

  # Bump to 1.18 on the next release (0.7.7 or later).
  depends_on "go@1.17" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
