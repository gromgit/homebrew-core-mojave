class Purescript < Formula
  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "https://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.14.9/purescript-0.14.9.tar.gz"
  sha256 "edfb8343e7b7699cb4a474c5de2b1eeafdf7cd020879546244c6ec1212b48a8d"
  license "BSD-3-Clause"
  head "https://github.com/purescript/purescript.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/purescript"
    sha256 cellar: :any_skip_relocation, mojave: "3a6b4374e5f91383f0b241f5f9ec56a05ee79709d3b36561d390beea8b954b77"
  end

  depends_on "ghc" => :build
  depends_on "haskell-stack" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "purescript-cst" do
    url "https://hackage.haskell.org/package/purescript-cst-0.5.0.0/purescript-cst-0.5.0.0.tar.gz"
    sha256 "ede84b964d6855d31d789fde824d64b0badff44bf9040da5826b7cbde0d0ed8d"
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
