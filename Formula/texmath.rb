class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.5/texmath-0.12.5.tar.gz"
  sha256 "697a60ab7a658c24266ed3d4e82a4960c42c85f94e24cb851004ec01d406249a"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/texmath"
    sha256 cellar: :any_skip_relocation, mojave: "60c9b40ab6d84569a21665f2a410ddbcab9cbf4ea8c3739a999990d66d28d78a"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args, "-fexecutable"
  end

  test do
    assert_match "<mn>2</mn>", pipe_output(bin/"texmath", "a^2 + b^2 = c^2")
  end
end
