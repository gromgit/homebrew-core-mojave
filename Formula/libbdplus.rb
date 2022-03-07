class Libbdplus < Formula
  desc "Implements the BD+ System Specifications"
  homepage "https://www.videolan.org/developers/libbdplus.html"
  url "https://download.videolan.org/pub/videolan/libbdplus/0.1.2/libbdplus-0.1.2.tar.bz2"
  mirror "https://ftp.osuosl.org/pub/videolan/libbdplus/0.1.2/libbdplus-0.1.2.tar.bz2"
  sha256 "a631cae3cd34bf054db040b64edbfc8430936e762eb433b1789358ac3d3dc80a"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libbdplus[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libbdplus"
    rebuild 1
    sha256 cellar: :any, mojave: "a15f957a8a7d27c5ccc368dc824b0f62b9651bf8b52cda1ba581badf3fbe0952"
  end

  head do
    url "https://code.videolan.org/videolan/libbdplus.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbdplus/bdplus.h>
      int main() {
        int major = -1;
        int minor = -1;
        int micro = -1;
        bdplus_get_version(&major, &minor, &micro);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lbdplus", "-o", "test"
    system "./test"
  end
end
