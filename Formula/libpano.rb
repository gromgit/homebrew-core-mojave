class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.21/libpano13-2.9.21.tar.gz"
  version "13-2.9.21"
  sha256 "79e5a1452199305e2961462720ef5941152779c127c5b96fc340d2492e633590"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano(\d+-\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libpano"
    sha256 cellar: :any, mojave: "4b97e36a3a20e84e5858ad118d6dd6d933e24b8b6ee4b477e269951c9cf8e0ee"
  end

  depends_on "cmake" => :build
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  uses_from_macos "zlib"

  patch :DATA

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end

__END__
diff --git a/panorama.h b/panorama.h
index 70a9fae..2942993 100644
--- a/panorama.h
+++ b/panorama.h
@@ -53,8 +53,12 @@
 #define PT_BIGENDIAN 1
 #endif
 #else
+#if defined(__APPLE__)
+#include <machine/endian.h>
+#else
 #include <endian.h>
 #endif
+#endif
 #if defined(__BYTE_ORDER) && (__BYTE_ORDER == __BIG_ENDIAN)
 #define PT_BIGENDIAN 1
 #endif
