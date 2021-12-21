class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.3.3/texmath-0.12.3.3.tar.gz"
  sha256 "c80e796a22e17faf29253ce733046a12670c173a10dbfdbd8182821fccb28c7d"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/texmath"
    sha256 cellar: :any_skip_relocation, mojave: "ca7c615ec0e7196acdd5da036bf2fbea3f5cf3daa12a2e7138a45afb8dc89898"
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
