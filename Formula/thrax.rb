class Thrax < Formula
  include Language::Python::Shebang

  desc "Tools for compiling grammars into finite state transducers"
  homepage "https://www.openfst.org/twiki/bin/view/GRM/Thrax"
  url "https://www.openfst.org/twiki/pub/GRM/ThraxDownload/thrax-1.3.6.tar.gz"
  sha256 "5f00a2047674753cba6783b010ab273366dd3dffc160bdb356f7236059a793ba"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://www.openfst.org/twiki/bin/view/GRM/ThraxDownload"
    regex(/href=.*?thrax[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/thrax"
    sha256 cellar: :any, mojave: "5e9001cc07788c0d20ff062e6bfc5804f700ea42938d8f9e6318c5a2e464e4e1"
  end

  depends_on "openfst"

  on_linux do
    depends_on "gcc"
    depends_on "python@3.10"
  end

  fails_with gcc: "5"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
    rewrite_shebang detected_python_shebang, bin/"thraxmakedep" if OS.linux?
  end

  test do
    # see http://www.openfst.org/twiki/bin/view/GRM/ThraxQuickTour
    cp_r pkgshare/"grammars", testpath
    cd "grammars" do
      system "#{bin}/thraxmakedep", "example.grm"
      system "make"
      system "#{bin}/thraxrandom-generator", "--far=example.far", "--rule=TOKENIZER"
    end
  end
end
