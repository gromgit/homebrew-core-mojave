class Ppl < Formula
  desc "Parma Polyhedra Library: numerical abstractions for analysis, verification"
  homepage "https://www.bugseng.com/ppl"
  url "https://www.bugseng.com/products/ppl/download/ftp/releases/1.2/ppl-1.2.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/p/ppl/ppl_1.2.orig.tar.xz"
  sha256 "691f0d5a4fb0e206f4e132fc9132c71d6e33cdda168470d40ac3cf62340e9a60"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.bugseng.com/ppl-download"
    regex(/href=.*?ppl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ppl"
    rebuild 1
    sha256 mojave: "ea0dbe1fafcf324ce3e6f37abdf33350f3bdf38425b5530d710292510e107a23"
  end

  depends_on "gmp"

  on_linux do
    depends_on "m4" => :build
  end

  # Fix build failure with clang 5+.
  # https://www.cs.unipr.it/mantis/view.php?id=2128
  # http://www.cs.unipr.it/git/gitweb.cgi?p=ppl/ppl.git;a=commit;h=c39f6a07b51f89e365b05ba4147aa2aa448febd7
  # since 401 error on the `www.cs.unipr.it` links adopt the patch from macports
  # patch reference, https://github.com/macports/macports-ports/commit/e5de9cc65a8e91fcbb9a3d90911569169f0ccf88
  patch :DATA

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gmp=#{Formula["gmp"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <ppl_c.h>
      #ifndef PPL_VERSION_MAJOR
      #error "No PPL header"
      #endif
      int main() {
        ppl_initialize();
        return ppl_finalize();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lppl_c", "-lppl", "-o", "test"
    system "./test"
  end
end

__END__
diff --git a/src/Determinate_inlines.hh b/src/Determinate_inlines.hh
index c918b23..de672a0 100644
--- a/src/Determinate_inlines.hh
+++ b/src/Determinate_inlines.hh
@@ -289,8 +289,8 @@ operator()(Determinate& x, const Determinate& y) const {

 template <typename PSET>
 template <typename Binary_Operator_Assign>
-inline
-Determinate<PSET>::Binary_Operator_Assign_Lifter<Binary_Operator_Assign>
+inline typename
+Determinate<PSET>::template Binary_Operator_Assign_Lifter<Binary_Operator_Assign>
 Determinate<PSET>::lift_op_assign(Binary_Operator_Assign op_assign) {
   return Binary_Operator_Assign_Lifter<Binary_Operator_Assign>(op_assign);
 }
diff --git a/src/OR_Matrix_inlines.hh b/src/OR_Matrix_inlines.hh
index a5f2856..560f8d6 100644
--- a/src/OR_Matrix_inlines.hh
+++ b/src/OR_Matrix_inlines.hh
@@ -97,7 +97,7 @@ OR_Matrix<T>::Pseudo_Row<U>::Pseudo_Row(const Pseudo_Row<V>& y)

 template <typename T>
 template <typename U>
-inline OR_Matrix<T>::Pseudo_Row<U>&
+inline typename OR_Matrix<T>::template Pseudo_Row<U>&
 OR_Matrix<T>::Pseudo_Row<U>::operator=(const Pseudo_Row& y) {
   first = y.first;
 #if PPL_OR_MATRIX_EXTRA_DEBUG
