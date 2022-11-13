# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp5
# - lablgtk
#
# Applications that really shouldn't break on a compiler update are:
# - coq
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  stable do
    url "https://caml.inria.fr/pub/distrib/ocaml-4.14/ocaml-4.14.0.tar.xz"
    sha256 "36abd8cca53ff593d5e7cd8b98eee2f1f36bd49aaf6ff26dc4c4dd21d861ac2b"

    # Remove use of -flat_namespace. Upstreamed at
    # https://github.com/ocaml/ocaml/pull/10723
    # We embed a patch here so we don't have to regenerate configure.
    patch :DATA
  end

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ocaml"
    rebuild 1
    sha256 cellar: :any, mojave: "2c23259ba2367c371d4bc4c91d3fa5387c22dcb672aae704d966be0415d11d6e"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --enable-debug-runtime
      --mandir=#{man}
    ]
    system "./configure", *args
    system "make", "world.opt"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/ocaml 2>&1", "let x = 1 ;;")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end

__END__
--- a/configure
+++ b/configure
@@ -14087,7 +14087,7 @@ if test x"$enable_shared" != "xno"; then :
   case $host in #(
   *-apple-darwin*) :
     mksharedlib="$CC -shared \
-                   -flat_namespace -undefined suppress -Wl,-no_compact_unwind \
+                   -undefined dynamic_lookup -Wl,-no_compact_unwind \
                    \$(LDFLAGS)"
       supports_shared_libraries=true ;; #(
   *-*-mingw32) :
