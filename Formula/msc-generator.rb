class MscGenerator < Formula
  desc "Draws signalling charts from textual description"
  homepage "https://sourceforge.net/p/msc-generator"
  url "https://downloads.sourceforge.net/project/msc-generator/msc-generator/v7.x/msc-generator-7.1.tar.gz"
  sha256 "cecd1d3ef2dd2018eb95ee1ece5dea37f5f2f7811da2fe6f4a6884898c1eb489"
  license "AGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/msc-generator"
    sha256 cellar: :any, mojave: "5ee1597774de5eabfabdb5bed82c45470eecf6b7107d1ebef17ed83b353c30e1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "help2man" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gcc"
  depends_on "glpk"
  depends_on "graphviz"
  depends_on "sdl2"

  fails_with :clang # needs std::range

  def install
    system "./configure", "--prefix=#{prefix}"
    # Dance around upstream trying to build everything in doc/ which we don't do for now
    # system "make", "install"
    system "make", "-C", "src", "install"
    system "make", "-C", "doc", "msc-gen.1"
    man1.install "doc/msc-gen.1"
  end

  test do
    # Try running the program
    system "#{bin}/msc-gen", "--version"
    # Construct a simple chart and check if PNG is generated (the default output format)
    (testpath/"simple.signalling").write("a->b;")
    system "#{bin}/msc-gen", "simple.signalling"
    assert_predicate testpath/"simple.png", :exist?
    bytes = File.binread(testpath/"simple.png")
    assert_equal bytes[0..7], "\x89PNG\r\n\x1a\n".force_encoding("ASCII-8BIT")
  end
end
