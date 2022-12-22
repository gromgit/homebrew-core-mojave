class Alpine < Formula
  desc "News and email agent"
  homepage "https://alpineapp.email"
  url "https://alpineapp.email/alpine/release/src/alpine-2.26.tar.xz"
  # keep mirror even though `brew audit --strict --online` complains
  mirror "https://alpineapp.email/alpine/release/src/Old/alpine-2.26.tar.xz"
  sha256 "c0779c2be6c47d30554854a3e14ef5e36539502b331068851329275898a9baba"
  license "Apache-2.0"
  head "https://repo.or.cz/alpine.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?alpine[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/alpine"
    rebuild 2
    sha256 mojave: "7fa09207b6fdbac34f8b3cd0bcac2cf49e1dda80cb7b3736c78f4406adcfa8da"
  end

  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "openldap"

  on_linux do
    depends_on "linux-pam"
  end

  conflicts_with "macpine", because: "both install `alpine` binaries"

  # patch for macOS obtained from developer; see git commit
  # https://repo.or.cz/alpine.git/commitdiff/701aebc00aff0585ce6c96653714e4ba94834c9c
  patch :DATA

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@3"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@3
      --prefix=#{prefix}
      --with-bundled-tools
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-conf"
  end
end

__END__
--- a/configure
+++ b/configure
@@ -18752,6 +18752,26 @@
 fi
 
 
+
+# Check whether --with-local-password-cache was given.
+if test "${with_local_password_cache+set}" = set; then :
+  withval=$with_local_password_cache;
+     alpine_os_credential_cache=$withval
+
+fi
+
+
+
+# Check whether --with-local-password-cache-method was given.
+if test "${with_local_password_cache_method+set}" = set; then :
+  withval=$with_local_password_cache_method;
+     alpine_os_credential_cache_method=$withval
+
+fi
+
+
+alpine_cache_os_method="no"
+
 alpine_PAM="none"
 
 case "$host" in
@@ -18874,6 +18894,7 @@
 
 $as_echo "#define APPLEKEYCHAIN 1" >>confdefs.h
 
+	alpine_cache_os_method="yes"
 	;;
     esac
     if test -z "$alpine_c_client_bundled" ; then
@@ -19096,25 +19117,7 @@
 
 
 
-
-# Check whether --with-local-password-cache was given.
-if test "${with_local_password_cache+set}" = set; then :
-  withval=$with_local_password_cache;
-     alpine_os_credential_cache=$withval
-
-fi
-
-
-
-# Check whether --with-local-password-cache-method was given.
-if test "${with_local_password_cache_method+set}" = set; then :
-  withval=$with_local_password_cache_method;
-     alpine_os_credential_cache_method=$withval
-
-fi
-
-
-if test -z "$alpine_PASSFILE" ; then
+if test -z "$alpine_PASSFILE" -a "alpine_cache_os_method" = "no" ; then
   if test -z "$alpine_SYSTEM_PASSFILE" ; then
      alpine_PASSFILE=".alpine.pwd"
   else
@@ -25365,4 +25368,3 @@
   { $as_echo "$as_me:${as_lineno-$LINENO}: WARNING: unrecognized options: $ac_unrecognized_opts" >&5
 $as_echo "$as_me: WARNING: unrecognized options: $ac_unrecognized_opts" >&2;}
 fi
-
