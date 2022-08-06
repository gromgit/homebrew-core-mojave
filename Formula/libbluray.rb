class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/videolan/libbluray/1.3.2/libbluray-1.3.2.tar.bz2"
  sha256 "456814db9f07c1eecdef7e840fcbb20976ef814df875428bfb81ecf45851f170"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://download.videolan.org/pub/videolan/libbluray/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libbluray"
    rebuild 1
    sha256 cellar: :any, mojave: "d831a1a3a14431a7b68bc418111d07779bd9b27a1c1cf3e3cb595010bd66b96c"
  end

  head do
    url "https://code.videolan.org/videolan/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"

  uses_from_macos "libxml2"

  def install
    args = %W[--prefix=#{prefix} --disable-dependency-tracking --disable-silent-rules --disable-bdjava-jar]

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libbluray/bluray.h>
      int main(void) {
        BLURAY *bluray = bd_init();
        bd_close(bluray);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbluray", "-o", "test"
    system "./test"
  end
end
