class Libmobi < Formula
  desc "C library for handling Kindle (MOBI) formats of ebook documents"
  homepage "https://github.com/bfabiszewski/libmobi"
  url "https://github.com/bfabiszewski/libmobi/releases/download/v0.11/libmobi-0.11.tar.gz"
  sha256 "6a7cbfb2b8f00849f02af3d913a694a0d7c7e7acb6b801625373f32e57db8051"
  license "LGPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libmobi"
    sha256 cellar: :any, mojave: "d5561a0802c95707625c9138452250be7d217c05e2a65be4b85e07a1a1dcbf0e"
  end

  uses_from_macos "libxml2"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mobi.h>
      int main() {
        MOBIData *m = mobi_init();
        if (m == NULL) {
          return 1;
        }
        mobi_free(m);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-L#{lib}", "-lmobi", "-o", "test"
    system "./test"
  end
end
