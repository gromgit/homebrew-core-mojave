class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.1.0.tar.gz"
  sha256 "b367c695d2831958e7166921c3b356d5dfa51b1ecee505b97416ba39d1b6c17a"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cfitsio"
    sha256 cellar: :any, mojave: "427e277300bdc41d3cddac8629646bf29542cb5e4275d3fde4eb697d64473798"
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-reentrant"
    system "make", "shared"
    system "make", "install"
    (pkgshare/"testprog").install Dir["testprog*"]
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    system ENV.cc, "testprog.c", "-o", "testprog", "-I#{include}",
                   "-L#{lib}", "-lcfitsio"
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end
