class Apr < Formula
  desc "Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-1.7.0.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-1.7.0.tar.bz2"
  sha256 "e2e148f0b2e99b8e5c6caa09f6d4fb4dd3e83f744aa72a952f94f5a14436f7ea"
  license "Apache-2.0"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/apr"
    rebuild 1
    sha256 cellar: :any, mojave: "3be9db7b52ba7d20a3aeb614197f358de22c51499d673a4188394dfdb872023a"
  end

  keg_only :provided_by_macos, "Apple's CLT provides apr"

  depends_on "autoconf@2.69" => :build

  on_linux do
    depends_on "util-linux"
  end

  # Apply r1871981 which fixes a compile error on macOS 11.0.
  # Remove with the next release, along with the autoconf call & dependency.
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7e2246542543bbd3111a4ec29f801e6e4d538f88/apr/r1871981-macos11.patch"
    sha256 "8754b8089d0eb53a7c4fd435c9a9300560b675a8ff2c32315a5e9303408447fe"
  end

  # Apply r1882980+1882981 to fix implicit exit() declaration
  # Remove with the next release, along with the autoconf call & dependency.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/fa29e2e398c638ece1a72e7a4764de108bd09617/apr/r1882980%2B1882981-configure.patch"
    sha256 "24189d95ab1e9523d481694859b277c60ca29bfec1300508011794a78dfed127"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  # We patch `libtool.m4` directly because we call `autoconf`.
  patch :DATA

  def install
    # https://bz.apache.org/bugzilla/show_bug.cgi?id=57359
    # The internal libtool throws an enormous strop if we don't do...
    ENV.deparallelize

    # Needed to apply the patch.
    system "autoconf"

    system "./configure", *std_configure_args
    system "make", "install"

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # Remove at version/revision bump from version 1.7.0 revision 2.
    (libexec/"lib").install_symlink lib.glob(shared_library("*"))

    rm lib.glob("*.{la,exp}")

    # No need for this to point to the versioned path.
    inreplace bin/"apr-#{version.major}-config", prefix, opt_prefix

    # Avoid references to the Homebrew shims directory
    inreplace prefix/"build-#{version.major}/libtool", Superenv.shims_path, "/usr/bin" if OS.linux?
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apr-#{version.major}-config --prefix")
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <apr-#{version.major}/apr_version.h>
      int main() {
        printf("%s", apr_version_string());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lapr-#{version.major}", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end

__END__
diff --git a/build/libtool.m4 b/build/libtool.m4
index e86a682..c1c342f 100644
--- a/build/libtool.m4
+++ b/build/libtool.m4
@@ -1067,16 +1067,11 @@ _LT_EOF
       _lt_dar_allow_undefined='$wl-undefined ${wl}suppress' ;;
     darwin1.*)
       _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-    darwin*) # darwin 5.x on
-      # if running on 10.5 or later, the deployment target defaults
-      # to the OS version, if on x86, and 10.4, the deployment
-      # target defaults to 10.4. Don't you love it?
-      case ${MACOSX_DEPLOYMENT_TARGET-10.0},$host in
-	10.0,*86*-darwin8*|10.0,*-darwin[[91]]*)
-	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
-	10.[[012]][[,.]]*)
+    darwin*)
+      case ${MACOSX_DEPLOYMENT_TARGET},$host in
+	10.[[012]],*|,*powerpc*)
 	  _lt_dar_allow_undefined='$wl-flat_namespace $wl-undefined ${wl}suppress' ;;
-	10.*)
+	*)
 	  _lt_dar_allow_undefined='$wl-undefined ${wl}dynamic_lookup' ;;
       esac
     ;;
