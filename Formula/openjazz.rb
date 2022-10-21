class Openjazz < Formula
  desc "Open source Jazz Jackrabit engine"
  homepage "http://www.alister.eu/jazz/oj/"
  url "https://github.com/AlisterT/openjazz/archive/20190106.tar.gz"
  sha256 "27da3ab32cb6b806502a213c435e1b3b6ecebb9f099592f71caf6574135b1662"
  license "GPL-2.0"
  revision 1
  head "https://github.com/AlisterT/openjazz.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openjazz"
    sha256 cellar: :any, mojave: "c243a671954834d5b31a1e4219fa1e9d889683a94c5b0e0b33b8f64fb3884ebf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libmodplug"
  depends_on "sdl12-compat"

  uses_from_macos "zlib"

  # From LICENSE.DOC:
  # "Epic MegaGames allows and encourages all bulletin board systems and online
  # services to distribute this game by modem as long as no files are altered
  # or removed."
  resource "shareware" do
    url "https://image.dosgamesarchive.com/games/jazz.zip"
    sha256 "ed025415c0bc5ebc3a41e7a070551bdfdfb0b65b5314241152d8bd31f87c22da"
  end

  # MSG_NOSIGNAL is only defined in Linux
  # https://github.com/AlisterT/openjazz/pull/7
  patch :DATA

  def install
    # the libmodplug include paths in the source don't include the libmodplug directory
    ENV.append_to_cflags "-I#{Formula["libmodplug"].opt_include}/libmodplug"

    system "autoreconf", "-ivf"
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{pkgshare}",
                          "--disable-dependency-tracking"
    system "make", "install"

    # Default game lookup path is the OpenJazz binary's location
    (bin/"OpenJazz").write <<~EOS
      #!/bin/sh

      exec "#{pkgshare}/OpenJazz" "$@"
    EOS

    resource("shareware").stage do
      pkgshare.install Dir["*"]
    end
  end

  def caveats
    <<~EOS
      The shareware version of Jazz Jackrabbit has been installed.
      You can install the full version by copying the game files to:
        #{pkgshare}
    EOS
  end
end

__END__
diff --git a/src/io/network.cpp b/src/io/network.cpp
index 8af8775..362118e 100644
--- a/src/io/network.cpp
+++ b/src/io/network.cpp
@@ -53,6 +53,9 @@
		#include <errno.h>
		#include <string.h>
	#endif
+ 	#ifdef __APPLE__
+ 		#define MSG_NOSIGNAL SO_NOSIGPIPE
+    #endif
 #elif defined USE_SDL_NET
	#include <arpa/inet.h>
 #endif
