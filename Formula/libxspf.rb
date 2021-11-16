class Libxspf < Formula
  desc "C++ library for XSPF playlist reading and writing"
  homepage "https://libspiff.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libspiff/Sources/1.2.1/libxspf-1.2.1.tar.bz2"
  sha256 "ce78a7f7df73b7420b6a54b5766f9b74e396d5e0b37661c9a448f2f589754a49"
  license "BSD-3-Clause"


  depends_on "cpptest" => :build
  depends_on "pkg-config" => :build
  depends_on "uriparser"

  uses_from_macos "expat"

  resource "check.cpp" do
    url "https://gitlab.xiph.org/xiph/libxspf/-/raw/master/examples/check/check.cpp"
    sha256 "fdd1e586c4f5b724890eb2ce6a3cd3b9910a8e74ee454fe462ba8eb802f7c4b9"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    resource("check.cpp").stage(testpath)
    flags = "-I#{include} -L#{lib} -lxspf".split
    system ENV.cxx, "check.cpp", "-o", "check", *flags
  end
end
