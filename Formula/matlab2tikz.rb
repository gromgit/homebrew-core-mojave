class Matlab2tikz < Formula
  desc "Convert MATLAB(R) figures into TikZ/Pgfplots figures"
  homepage "https://github.com/matlab2tikz/matlab2tikz"
  url "https://github.com/matlab2tikz/matlab2tikz/archive/v1.1.0.tar.gz"
  sha256 "4e6fe80ebe4c8729650eb00679f97398c2696fd9399c17f9c5b60a1a6cf23a19"
  license "BSD-2-Clause"
  head "https://github.com/matlab2tikz/matlab2tikz.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/matlab2tikz"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f2189f2696a4ac8afcb36c43edd30731fdbd40a48889a724a3cc8fc4221b79a7"
  end

  def install
    pkgshare.install Dir["src/*"]
  end
end
