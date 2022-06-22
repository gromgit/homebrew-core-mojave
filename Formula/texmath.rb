class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.5.1/texmath-0.12.5.1.tar.gz"
  sha256 "a9b4c7b93840f5772a718b8277c233b813e2e027c94d735d2f6f498e21f01fbd"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/texmath"
    sha256 cellar: :any_skip_relocation, mojave: "1cd769c976018a424011fecab4fdb6bd780dab44822d4d81893fa20f2f016cc8"
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
