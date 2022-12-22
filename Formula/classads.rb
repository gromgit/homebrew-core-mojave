class Classads < Formula
  desc "Classified Advertisements (used by HTCondor Central Manager)"
  homepage "https://research.cs.wisc.edu/htcondor/classad/"
  url "https://ftp.cs.wisc.edu/condor/classad/c++/classads-1.0.10.tar.gz"
  sha256 "cde2fe23962abb6bc99d8fc5a5cbf88f87e449b63c6bca991d783afb4691efb3"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?classads[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/classads"
    rebuild 2
    sha256 cellar: :any, mojave: "5b60392cbf08c837b6d4e01823b9de8d3456962a14bde3944cae9ab61e4f674a"
  end

  depends_on "pcre"

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # Allow compilation on ARM, where finite() is not availalbe.
  # Reported by email on 2022-11-10
  patch :DATA

  def install
    # Run autoreconf on macOS to rebuild configure script so that it doesn't try
    # to build with a flat namespace.
    system "autoreconf", "--force", "--verbose", "--install" if OS.mac?
    system "./configure", "--enable-namespace", "--prefix=#{prefix}"
    system "make", "install"
  end
end

__END__
diff -pur classads-1.0.10/util.cpp classads-1.0.10-new/util.cpp
--- classads-1.0.10/util.cpp	2011-04-09 01:36:36
+++ classads-1.0.10-new/util.cpp	2022-11-10 11:16:47
@@ -430,7 +430,7 @@ int classad_isinf(double x) 
 #endif
 int classad_isinf(double x) 
 { 
-    if (finite(x) || x != x) {
+    if (isfinite(x) || x != x) {
         return 0;
     } else if (x > 0) {
         return 1;
