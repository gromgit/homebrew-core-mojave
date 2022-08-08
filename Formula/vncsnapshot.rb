class Vncsnapshot < Formula
  desc "Command-line utility for taking VNC snapshots"
  homepage "https://sourceforge.net/projects/vncsnapshot/"
  url "https://downloads.sourceforge.net/project/vncsnapshot/vncsnapshot/1.2a/vncsnapshot-1.2a-src.tar.gz"
  sha256 "20f5bdf6939a0454bc3b41e87e41a5f247d7efd1445f4fac360e271ddbea14ee"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/vncsnapshot[._-]v?(\d+(?:\.\d+)+[a-z]?)-src\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vncsnapshot"
    sha256 cellar: :any, mojave: "18cc9d57e117ad19dcb8027574ef5a0c38e5ef09d8adfb77f1eed608fc5075af"
  end

  depends_on "jpeg-turbo"

  uses_from_macos "zlib"

  patch :DATA # remove old PPC __APPLE__ ifdef from sockets.cxx

  def install
    # From Ubuntu
    inreplace "rfb.h", "typedef unsigned long CARD32;",
                       "typedef unsigned int CARD32;"

    args = [
      "JPEG_INCLUDE=-I#{Formula["jpeg-turbo"].opt_include}",
      "JPEG_LIB=-L#{Formula["jpeg-turbo"].opt_lib} -ljpeg",
    ]
    if OS.linux?
      args << "ZLIB_INCLUDE=-I#{Formula["zlib"].opt_include}"
      args << "ZLIB_LIB=-L#{Formula["zlib"].opt_lib} -lz"
    end

    ENV.deparallelize
    system "make", *args
    bin.install "vncsnapshot", "vncpasswd"
    man1.install "vncsnapshot.man1" => "vncsnapshot.1"
  end
end

__END__
diff --git a/sockets.cxx b/sockets.cxx
index ecdf0db..6c827fa 100644
--- a/sockets.cxx
+++ b/sockets.cxx
@@ -38,9 +38,9 @@ typedef int socklen_t;
 #include <fcntl.h>
 #endif

-#ifdef __APPLE__
-typedef int socklen_t;
-#endif
+//#ifdef __APPLE__
+//typedef int socklen_t;
+//#endif

 extern "C" {
 #include "vncsnapshot.h"
