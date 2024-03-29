class Darcs < Formula
  desc "Distributed version control system that tracks changes, via Haskell"
  homepage "http://darcs.net/"
  url "https://hackage.haskell.org/package/darcs-2.16.5/darcs-2.16.5.tar.gz"
  sha256 "d63c6cd236e31e812e8ad84433d27059387606269fbd953f4c349c3cb3aa242b"
  license "GPL-2.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/darcs"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0b933093c9c0ce3702780c5d01f5e7fce892d15b0b41aa5efe2974f4fe6a939f"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "gmp"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    mkdir "my_repo" do
      system bin/"darcs", "init"
      (Pathname.pwd/"foo").write "hello homebrew!"
      system bin/"darcs", "add", "foo"
      system bin/"darcs", "record", "-am", "add foo", "--author=homebrew"
    end
    system bin/"darcs", "get", "my_repo", "my_repo_clone"
    cd "my_repo_clone" do
      assert_match "hello homebrew!", (Pathname.pwd/"foo").read
    end
  end
end
