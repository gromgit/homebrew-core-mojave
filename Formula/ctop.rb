class Ctop < Formula
  desc "Top-like interface for container metrics"
  homepage "https://bcicen.github.io/ctop/"
  url "https://github.com/bcicen/ctop.git",
      tag:      "v0.7.7",
      revision: "11a1cb10f416b4ca5e36c22c1acc2d11dbb24fb4"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ctop"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "664beefc65c44145bf8ce18e4990f23f13c572931c08f7647327fa47cdc23830"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "ctop"
  end

  test do
    system "#{bin}/ctop", "-v"
  end
end
