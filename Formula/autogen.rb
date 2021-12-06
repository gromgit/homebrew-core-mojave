class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  sha256 "f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{href=.*?rel(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/autogen"
    sha256 mojave: "3af90b81d5384a91498725c95bc94b0db59c370edd9afad2b6785f46d296939f"
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

  uses_from_macos "libxml2"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # Fix guile detection, see https://sourceforge.net/p/autogen/bugs/196/
  patch :DATA

  def install
    # Uses GNU-specific mktemp syntax: https://sourceforge.net/p/autogen/bugs/189/
    inreplace %w[agen5/mk-stamps.sh build-aux/run-ag.sh config/mk-shdefs.in], "mktemp", "gmktemp"
    # Upstream bug regarding "stat" struct: https://sourceforge.net/p/autogen/bugs/187/
    system "./configure", "ac_cv_func_utimensat=no",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end

__END__
Index: autogen-5.18.16/agen5/guile-iface.h
===================================================================
--- autogen-5.18.16.orig/agen5/guile-iface.h
+++ autogen-5.18.16/agen5/guile-iface.h
@@ -9,16 +9,13 @@
 # error AutoGen does not work with this version of Guile
   choke me.
 
-#elif GUILE_VERSION < 203000
+#else
 # define AG_SCM_IS_PROC(_p)           scm_is_true( scm_procedure_p(_p))
 # define AG_SCM_LIST_P(_l)            scm_is_true( scm_list_p(_l))
 # define AG_SCM_PAIR_P(_p)            scm_is_true( scm_pair_p(_p))
 # define AG_SCM_TO_LONG(_v)           scm_to_long(_v)
 # define AG_SCM_TO_ULONG(_v)          ((unsigned long)scm_to_ulong(_v))
 
-#else
-# error unknown GUILE_VERSION
-  choke me.
 #endif
 
 #endif /* MUTATING_GUILE_IFACE_H_GUARD */
Index: autogen-5.18.16/configure
===================================================================
--- autogen-5.18.16.orig/configure
+++ autogen-5.18.16/configure
@@ -14798,7 +14798,7 @@ $as_echo "no" >&6; }
    PKG_CONFIG=""
  fi
 fi
-  _guile_versions_to_search="2.2 2.0 1.8"
+  _guile_versions_to_search="3.0 2.2 2.0 1.8"
   if test -n "$GUILE_EFFECTIVE_VERSION"; then
     _guile_tmp=""
     for v in $_guile_versions_to_search; do
