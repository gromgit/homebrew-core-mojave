class Texmath < Formula
  desc "Haskell library for converting LaTeX math to MathML"
  homepage "https://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.12.4/texmath-0.12.4.tar.gz"
  sha256 "4373bb9db8f977f37b9c1316c65ca97bae7600277e4f79d681dabf2fcb81f0cc"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/texmath.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/texmath"
    sha256 cellar: :any_skip_relocation, mojave: "2e0711b974ccd6e175227afeb2bb53102b3f18d6db8e646a8f72fd46d7283ff9"
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
