class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://code.google.com/p/powerman/"
  license "GPL-2.0"

  stable do
    url "https://github.com/chaos/powerman/releases/download/v2.3.27/powerman-2.3.27.tar.gz"
    sha256 "1575f0c2cc49ba14482582b9bbba19e95496434f95d52de6ad2412e66200d2d8"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/powerman"
    sha256 mojave: "5795be97fffbe860d93f5413adb509b69343c78f29bc187a10fca1ce28f8b2f0"
  end

  head do
    url "https://github.com/chaos/powerman.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "curl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-httppower",
                          "--with-ncurses",
                          "--without-genders",
                          "--without-snmppower",
                          "--without-tcp-wrappers"
    system "make", "install"
  end

  test do
    system "#{sbin}/powermand", "-h"
  end
end
