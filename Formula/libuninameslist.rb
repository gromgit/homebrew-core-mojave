class Libuninameslist < Formula
  desc "Library of Unicode names and annotation data"
  homepage "https://github.com/fontforge/libuninameslist"
  url "https://github.com/fontforge/libuninameslist/releases/download/20211114/libuninameslist-dist-20211114.tar.gz"
  sha256 "f5f69090de4a483721207a9df7de5327c13c812a1d23de074d8f0496bc2b740d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)*)["' >]}i)
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libuninameslist"
    rebuild 2
    sha256 cellar: :any, mojave: "838cd647ccea8006d68810932703a3cbcfec8a845a4e67d150e969a64544f078"
  end

  head do
    url "https://github.com/fontforge/libuninameslist.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <uninameslist.h>

      int main() {
        (void)uniNamesList_blockCount();
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-luninameslist", "-o", "test"
    system "./test"
  end
end
