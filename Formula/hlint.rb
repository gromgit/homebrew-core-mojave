class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.4/hlint-3.4.tar.gz"
  sha256 "76fc615d6949fb9478e586c9ddd5510578ddaa32261d94f1a1f3670f20db8e95"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hlint"
    sha256 cellar: :any_skip_relocation, mojave: "a3edbcbb58e05ee90739a853c7d6806a5ea781cb0dd5d2c5033cfc12cb9edac1"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "ncurses"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    man1.install "data/hlint.1"
  end

  test do
    (testpath/"test.hs").write <<~EOS
      main = do putStrLn "Hello World"
    EOS
    assert_match "No hints", shell_output("#{bin}/hlint test.hs")

    (testpath/"test1.hs").write <<~EOS
      main = do foo x; return 3; bar z
    EOS
    assert_match "Redundant return", shell_output("#{bin}/hlint test1.hs", 1)
  end
end
