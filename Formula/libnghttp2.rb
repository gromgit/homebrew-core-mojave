class Libnghttp2 < Formula
  desc "HTTP/2 C Library"
  homepage "https://nghttp2.org/"
  url "https://github.com/nghttp2/nghttp2/releases/download/v1.49.0/nghttp2-1.49.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/nghttp2-1.49.0.tar.gz"
  mirror "http://fresh-center.net/linux/www/legacy/nghttp2-1.49.0.tar.gz"
  sha256 "14dd5654e369227afebfba5198793a1788a0af9d30cddb19af3ec275d110a7a6"
  license "MIT"

  livecheck do
    formula "nghttp2"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libnghttp2"
    sha256 cellar: :any, mojave: "1be0c08f5491c3d02df5f5f8042f3e7c83627964a15d1186adb33826caf42743"
  end

  head do
    url "https://github.com/nghttp2/nghttp2.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  # These used to live in `nghttp2`.
  link_overwrite "include/nghttp2"
  link_overwrite "lib/libnghttp2.a"
  link_overwrite "lib/libnghttp2.dylib"
  link_overwrite "lib/libnghttp2.14.dylib"
  link_overwrite "lib/libnghttp2.so"
  link_overwrite "lib/libnghttp2.so.14"
  link_overwrite "lib/pkgconfig/libnghttp2.pc"

  def install
    system "autoreconf", "-ivf" if build.head?
    system "./configure", *std_configure_args, "--enable-lib-only"
    system "make", "-C", "lib"
    system "make", "-C", "lib", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <nghttp2/nghttp2.h>
      #include <stdio.h>

      int main() {
        nghttp2_info *info = nghttp2_version(0);
        printf("%s", info->version_str);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lnghttp2", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
