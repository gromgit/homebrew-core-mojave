class Quantlib < Formula
  desc "Library for quantitative finance"
  homepage "https://www.quantlib.org/"
  url "https://github.com/lballabio/QuantLib/releases/download/QuantLib-v1.26/QuantLib-1.26.tar.gz"
  sha256 "04fe6cc1a3eb7776020093f550d4da89062586cc15d73e92babdf4505e3673e9"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/quantlib"
    sha256 cellar: :any, mojave: "cfeb98ec03045b81ef345be31fa63615ae86b6326f27a6ba96c659f948395281"
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
