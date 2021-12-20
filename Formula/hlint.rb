class Hlint < Formula
  desc "Haskell source code suggestions"
  homepage "https://github.com/ndmitchell/hlint"
  url "https://hackage.haskell.org/package/hlint-3.3.5/hlint-3.3.5.tar.gz"
  sha256 "812218e0e3eeceebe9ba8c9767543e2381ae163dafc81a762274951965493edf"
  license "BSD-3-Clause"
  head "https://github.com/ndmitchell/hlint.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hlint"
    sha256 cellar: :any_skip_relocation, mojave: "85e5f3a6a55dcd71f0ca3b09e29eb674eb7b8e1c7e4048ff877168f1b6ced3a1"
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
