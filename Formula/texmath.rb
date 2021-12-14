class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.3.2/texmath-0.12.3.2.tar.gz"
  sha256 "d6ec8b7ecb60ca73d56d8043ec79a006144ab50645bb6124c86f5678941d39b5"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/texmath"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "51893669916b778286544b1f371ba751c22178ef35263676c8439022c76e5cff"
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
