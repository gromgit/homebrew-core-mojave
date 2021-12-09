class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.5/purescript-0.14.5.tar.gz"
  sha256 "36c86445da58b8017aa98ba2ab975af7812b9ef739f0b8e7360740d5200ac319"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/purescript"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "8fdf2b2af74eb074fa56737399c9a48dee780f6d364194895b940d1fb4cfeab4"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "purescript-cst" do
    url "https://hackage.haskell.org/package/purescript-cst-0.4.0.0/purescript-cst-0.4.0.0.tar.gz"
    sha256 "0f592230f528ce471a3d3ce44d85f4b96f2a08f5d6483edfe569679a322d6e64"
  end

  def install
    (buildpath/"lib"/"purescript-cst").install resource("purescript-cst")
    system "stack", "install", "--system-ghc", "--no-install-ghc", "--skip-ghc-check", "--local-bin-path=#{bin}"
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<~EOS
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"purs", "compile", test_module_path, "-o", test_target_path
    assert_predicate test_target_path, :exist?
  end
end
