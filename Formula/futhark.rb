class Futhark < Formula
  desc "Data-parallel functional programming language"
  homepage "https://futhark-lang.org/"
  url "https://github.com/diku-dk/futhark/archive/v0.20.6.tar.gz"
  sha256 "1502fea3bd21b37181bf0d8981c2e7406ae4274dff0a52fe014c4a410c48925a"
  license "ISC"
  head "https://github.com/diku-dk/futhark.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/futhark"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f5362b91d54ec7003e840ea97089f527f0e5f699c74a2f58349f237f78418b43"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build
  depends_on "sphinx-doc" => :build

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args

    system "make", "-C", "docs", "man"
    man1.install Dir["docs/_build/man/*.1"]
  end

  test do
    (testpath/"test.fut").write <<~EOS
      let main (n: i32) = reduce (*) 1 (1...n)
    EOS
    system "#{bin}/futhark", "c", "test.fut"
    assert_equal "3628800i32", pipe_output("./test", "10", 0).chomp
  end
end
