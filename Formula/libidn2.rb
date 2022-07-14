class Libidn2 < Formula
  desc "International domain name library (IDNA2008, Punycode and TR46)"
  homepage "https://www.gnu.org/software/libidn/#libidn2"
  url "https://ftp.gnu.org/gnu/libidn/libidn2-2.3.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/libidn/libidn2-2.3.3.tar.gz"
  mirror "http://ftp.gnu.org/gnu/libidn/libidn2-2.3.3.tar.gz"
  sha256 "f3ac987522c00d33d44b323cae424e2cffcb4c63c6aa6cd1376edacbf1c36eb0"
  license any_of: ["GPL-2.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(/href=.*?libidn2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libidn2"
    sha256 mojave: "f5681c9f556edc06417894c9b295569b646adbed276d6b17da6fe41a55e4be8d"
  end

  head do
    url "https://gitlab.com/libidn/libidn2.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
    depends_on "ronn" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libunistring"

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}",
                          "--with-packager=Homebrew"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    ENV["CHARSET"] = "UTF-8"
    output = shell_output("#{bin}/idn2 räksmörgås.se")
    assert_equal "xn--rksmrgs-5wao1o.se", output.chomp
    output = shell_output("#{bin}/idn2 blåbærgrød.no")
    assert_equal "xn--blbrgrd-fxak7p.no", output.chomp
  end
end
