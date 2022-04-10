class Fourmolu < Formula
  desc "Formatter for Haskell source code"
  homepage "https://github.com/fourmolu/fourmolu"
  url "https://github.com/fourmolu/fourmolu/archive/v0.6.0.0.tar.gz"
  sha256 "3f5dd18b542caea267f7e520b672948e25a33e8675d70234b8372549feef0e47"
  license "BSD-3-Clause"
  head "https://github.com/fourmolu/fourmolu.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fourmolu"
    sha256 cellar: :any_skip_relocation, mojave: "aaab8d884fbd0d64ccfc66a3ded901f0a266dabff4b6b470959f62f7b5589562"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      foo =
        f1
        p1
        p2 p3

      foo' =
        f2 p1
        p2
        p3

      foo'' =
        f3 p1 p2
        p3
    EOS
    expected = <<~EOS
      foo =
          f1
              p1
              p2
              p3

      foo' =
          f2
              p1
              p2
              p3

      foo'' =
          f3
              p1
              p2
              p3
    EOS
    assert_equal expected, shell_output("#{bin}/fourmolu test.hs")
  end
end
