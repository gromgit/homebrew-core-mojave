# Based on:
# Apple Open Source: https://opensource.apple.com/source/cvs/cvs-47/
# MacPorts: https://github.com/macports/macports-ports/blob/master/devel/cvs/Portfile
# Creating a useful testcase: https://mrsrl.stanford.edu/~brian/cvstutorial/

class Cvs < Formula
  desc "Version control system"
  homepage "https://www.nongnu.org/cvs/"
  url "https://ftp.gnu.org/non-gnu/cvs/source/feature/1.12.13/cvs-1.12.13.tar.bz2"
  sha256 "78853613b9a6873a30e1cc2417f738c330e75f887afdaf7b3d0800cb19ca515e"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]
  revision 4

  livecheck do
    url "https://ftp.gnu.org/non-gnu/cvs/source/feature/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cvs"
    sha256 cellar: :any, mojave: "4299cdca5c0493b7ae77957ced9fe359f601775e325fce83b43a226835592b3a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext"

  uses_from_macos "libxcrypt"
  uses_from_macos "zlib"

  on_linux do
    depends_on "vim" => :build # a text editor must be detected by the configure script
    depends_on "linux-pam"
  end

  patch :p0 do
    url "https://opensource.apple.com/tarballs/cvs/cvs-47.tar.gz"
    sha256 "643d871d6c5f3aaa1f7be626d60bd83bbdcab0f61196f51cb81e8c20e41f808a"
    patches = ["patches/PR5178707.diff",
               "patches/ea.diff",
               "patches/endian.diff",
               "patches/fixtest-client-20.diff",
               "patches/fixtest-recase.diff",
               "patches/i18n.diff",
               "patches/initgroups.diff",
               "patches/remove-info.diff",
               "patches/tag.diff",
               "patches/zlib.diff"]

    on_macos { patches << "patches/nopic.diff" }
    apply(*patches.compact)
  end

  patch do
    # Fixes error: 'Illegal instruction: 4'; '%n used in a non-immutable format string' on 10.13
    # Patches the upstream-provided gnulib on all platforms as is recommended
    on_macos do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/24118ec737c7d008420d4683a07129ed80a759eb/cvs/vasnprintf-high-sierra-fix.diff"
      sha256 "affa485332f66bb182963680f90552937bf1455b855388f7c06ef6a3a25286e2"
    end
    # Fixes error: %n in writable segment detected on Linux
    on_linux do
      url "https://gitweb.gentoo.org/repo/gentoo.git/plain/dev-vcs/cvs/files/cvs-1.12.13.1-fix-gnulib-SEGV-vasnprintf.patch?id=6c49fbac47ddb2c42ee285130afea56f349a2d40"
      sha256 "4f4b820ca39405348895d43e0d0f75bab1def93fb7a43519f6c10229a7c64952"
    end
  end

  # Fixes "cvs [init aborted]: cannot get working directory: No such file or directory" on Catalina.
  # Original patch idea by Jason White from stackoverflow
  patch :DATA

  def install
    # Do the same work as patches/remove-libcrypto.diff but by
    # changing autoconf's input instead of editing ./configure directly
    inreplace "m4/acx_with_gssapi.m4", "AC_SEARCH_LIBS([RC4]", "# AC_SEARCH_LIBS([RC4]"

    # Fix syntax error which breaks building against modern gettext
    inreplace "configure.in", "AM_GNU_GETTEXT_VERSION dnl", "AM_GNU_GETTEXT_VERSION(0.21) dnl"

    # Existing configure script needs updating for arm64 etc
    system "autoreconf", "--verbose", "--install", "--force"

    # Work around configure issues with Xcode 12
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--sysconfdir=#{etc}",
                          "--with-gssapi",
                          "--enable-pam",
                          "--enable-encryption",
                          "--with-external-zlib",
                          "--enable-case-sensitivity",
                          "--with-editor=vim",
                          "ac_cv_func_working_mktime=no"
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system "#{bin}/cvs", "-d", cvsroot, "init"

    mkdir "cvsexample" do
      ENV["CVSROOT"] = cvsroot
      system "#{bin}/cvs", "import", "-m", "dir structure", "cvsexample", "homebrew", "start"
    end
  end
end

__END__
--- cvs-1.12.13/lib/xgetcwd.c.orig      2019-10-10 22:52:37.000000000 -0500
+++ cvs-1.12.13/lib/xgetcwd.c   2019-10-10 22:53:32.000000000 -0500
@@ -25,8 +25,9 @@
 #include "xgetcwd.h"

 #include <errno.h>
+#include <unistd.h>

-#include "getcwd.h"
+/* #include "getcwd.h" */
 #include "xalloc.h"

 /* Return the current directory, newly allocated.
