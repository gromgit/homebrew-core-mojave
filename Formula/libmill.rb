class Libmill < Formula
  desc "Go-style concurrency in C"
  homepage "http://libmill.org/"
  url "http://libmill.org/libmill-1.18.tar.gz"
  mirror "https://github.com/sustrik/libmill/raw/gh-pages/libmill-1.8.tar.gz"
  sha256 "12e538dbee8e52fd719a9a84004e0aba9502a6e62cd813223316a1e45d49577d"
  license "MIT"
  head "https://github.com/sustrik/libmill.git"

  bottle do
    sha256 cellar: :any, mojave:      "26dd0efaf85765fd70f49d78ef0150731eed569711b1f246601f4c6f6cccced5"
    sha256 cellar: :any, high_sierra: "5e0fff326f0d0d5a7c09f20bb1612ba4034bec1cc3befd99977bfb5b587ca70b"
    sha256 cellar: :any, sierra:      "6eb891740171f0471d420da7e92df829dd64e108cdf115588a639f6be3906e0a"
    sha256 cellar: :any, el_capitan:  "37103d981777f9c30dda9add67a2cafc72b405ee7d10ac3a32b1f267b0b5cda5"
    sha256 cellar: :any, yosemite:    "4f8a2b4ddbcac88459c0f4b463e497a82e8d6a02b43419e29e2be8230c15123d"
  end

  disable! date: "2020-12-08", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "all", "check", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <libmill.h>

      void worker(int count, const char *text) {
          int i;
          for(i = 0; i != count; ++i) {
              printf("%s\\n", text);
              msleep(10);
          }
      }

      int main() {
          go(worker(4, "a"));
          go(worker(2, "b"));
          go(worker(3, "c"));
          msleep(100);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmill", "-o", "test"
    system "./test"
  end
end
