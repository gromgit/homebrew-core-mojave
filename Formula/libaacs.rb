class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.11.1/libaacs-0.11.1.tar.bz2"
  sha256 "a88aa0ebe4c98a77f7aeffd92ab3ef64ac548c6b822e8248a8b926725bea0a39"
  license "LGPL-2.1-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?libaacs[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libaacs"
    sha256 cellar: :any, mojave: "c8673953d879eb6c1134b4b5f31484d5ff44b28068e8bfca39cfec3a127448f7"
  end

  head do
    url "https://code.videolan.org/videolan/libaacs.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  uses_from_macos "flex" => :build

  # Fix missing include.
  patch :DATA

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "libaacs/aacs.h"
      #include <stdio.h>

      int main() {
        int major_v = 0, minor_v = 0, micro_v = 0;

        aacs_get_version(&major_v, &minor_v, &micro_v);

        printf("%d.%d.%d", major_v, minor_v, micro_v);
        return(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laacs",
                   "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/src/devtools/read_file.h b/src/devtools/read_file.h
index 953b2ef..d218417 100644
--- a/src/devtools/read_file.h
+++ b/src/devtools/read_file.h
@@ -20,6 +20,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <errno.h>
+#include <sys/types.h>

 static size_t _read_file(const char *name, off_t min_size, off_t max_size, uint8_t **pdata)
 {
