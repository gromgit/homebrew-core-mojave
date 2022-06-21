class Harbour < Formula
  desc "Portable, xBase-compatible programming language and environment"
  homepage "https://harbour.github.io"
  license "GPL-2.0"
  revision 1
  head "https://github.com/harbour/core.git", branch: "master"

  # Missing a header that was deprecated by libcurl @ version 7.12.0 and
  # deleted sometime after Harbour 3.0.0 release.
  stable do
    patch :DATA
    url "https://downloads.sourceforge.net/project/harbour-project/source/3.0.0/harbour-3.0.0.tar.bz2"
    sha256 "4e99c0c96c681b40c7e586be18523e33db24baea68eb4e394989a3b7a6b5eaad"
  end

  livecheck do
    url :stable
    regex(%r{url=.*?/harbour[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/harbour"
    sha256 cellar: :any, mojave: "ab363c0560cd2762a3699255e14ffa78bf0654d6799e70fa6d847b4b85b653fc"
  end

  depends_on "jpeg"
  depends_on "libharu"
  depends_on "libpng"
  depends_on "libxdiff"
  depends_on "minizip"
  depends_on "pcre"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    # Delete files that cause vendored libraries for minizip and expat to be built.
    rm "contrib/hbmzip/3rd/minizip/minizip.hbp"
    rm "contrib/hbexpat/3rd/expat/expat.hbp"

    # Fix flat namespace usage.
    # Upstreamed here: https://github.com/harbour/core/pull/263.
    inreplace "config/darwin/clang.mk", "-flat_namespace -undefined warning", "-undefined dynamic_lookup"

    # The following optional dependencies are not being used at this time:
    # allegro, cairo, cups, freeimage, gd, ghostscript, libmagic, mysql, postgresql, qt@5, unixodbc
    # openssl can not included because the hbssl extension does not support OpenSSL 1.1.

    # The below dependencies are included because they will be built as vendored libraries by default.
    # The vendored version of liblzf is used instead of the Homebrew one because the Homebrew version
    # is missing header files and the extension will not build
    # The vendored version of libmxml is used because it needs config.h, which is not included in
    # the Homebrew version of libmxml.
    # The vendored version of minilzo is used because the Homebrew version of lzo does not include minilzo.
    ENV["HB_INSTALL_PREFIX"] = prefix
    ENV["HB_WITH_X11"] = "no"
    ENV["HB_WITH_JPEG"] = Formula["jpeg"].opt_include
    ENV["HB_WITH_LIBHARU"] = Formula["libharu"].opt_include
    ENV["HB_WITH_MINIZIP"] = Formula["minizip"].opt_include/"minizip"
    ENV["HB_WITH_PCRE"] = Formula["pcre"].opt_include
    ENV["HB_WITH_PNG"] = Formula["libpng"].opt_include
    ENV["HB_WITH_XDIFF"] = Formula["libxdiff"].opt_include

    if OS.mac?
      ENV["HB_COMPILER"] = ENV.cc
      ENV["HB_USER_DFLAGS"] = "-L#{MacOS.sdk_path}/usr/lib"
      ENV["HB_WITH_BZIP2"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_CURL"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_CURSES"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_EXPAT"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_SQLITE3"] = MacOS.sdk_path/"usr/include"
      ENV["HB_WITH_ZLIB"] = MacOS.sdk_path/"usr/include"
    else
      ENV["HB_WITH_BZIP2"] = Formula["bzip2"].opt_include
      ENV["HB_WITH_CURL"] = Formula["curl"].opt_include
      ENV["HB_WITH_CURSES"] = Formula["ncurses"].opt_include
      ENV["HB_WITH_EXPAT"] = Formula["expat"].opt_include
      ENV["HB_WITH_SQLITE3"] = Formula["sqlite"].opt_include
      ENV["HB_WITH_ZLIB"] = Formula["zlib"].opt_include
    end

    ENV.deparallelize

    system "make", "install"

    rm Dir[bin/"hbmk2.*.hbl"]
    rm bin/"contrib.hbr" if build.head?
    rm bin/"harbour.ucf" if build.head?
  end

  test do
    (testpath/"hello.prg").write <<~EOS
      procedure Main()
         OutStd( ;
            "Hello, world!" + hb_eol() + ;
            OS() + hb_eol() + ;
            Version() + hb_eol() )
         return
    EOS

    assert_match "Hello, world!", shell_output("#{bin}/hbmk2 hello.prg -run")
  end
end

__END__
diff --git a/contrib/hbcurl/core.c b/contrib/hbcurl/core.c
index 00caaa8..53618ed 100644
--- a/contrib/hbcurl/core.c
+++ b/contrib/hbcurl/core.c
@@ -53,8 +53,12 @@
  */

 #include <curl/curl.h>
-#include <curl/types.h>
-#include <curl/easy.h>
+#if LIBCURL_VERSION_NUM < 0x070A03
+#  include <curl/easy.h>
+#endif
+#if LIBCURL_VERSION_NUM < 0x070C00
+#  include <curl/types.h>
+#endif

 #include "hbapi.h"
 #include "hbapiitm.h"
