class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.25/QuantLib-1.25.tar.gz"
  sha256 "0fbe8f621b837b6712d74102892a97a0f09e24a55a34dfc74f1e743a45d73d1d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/quantlib"
    rebuild 1
    sha256 cellar: :any, mojave: "458ad777d6ce968bb615b1ee36eebfec97b12773f40eafd72009587e3ac40e25"
  end

  head do
    url "https://github.com/lballabio/quantlib.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "boost"

  def install
    ENV.cxx11
    (buildpath/"QuantLib").install buildpath.children if build.stable?
    cd "QuantLib" do
      system "./autogen.sh" if build.head?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-lispdir=#{elisp}",
                            "--enable-intraday"

      system "make", "install"
      prefix.install_metafiles
    end
  end

  test do
    system bin/"quantlib-config", "--prefix=#{prefix}", "--libs", "--cflags"
  end
end
