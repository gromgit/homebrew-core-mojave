class Libxc < Formula
  desc "Library of exchange and correlation functionals for codes"
  homepage "https://tddft.org/programs/libxc/"
  url "https://gitlab.com/libxc/libxc/-/archive/5.2.2/libxc-5.2.2.tar.bz2"
  sha256 "484115929674d7b85d9361f4f8a821e3d1c6024e31b8fa41df916c09799891a9"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libxc"
    rebuild 1
    sha256 cellar: :any, mojave: "d1904c66d7296ebe630d40c1eec557e6523ed8069ce2e13ecb4dc3eace0774b5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=gfortran -E -x c",
                          "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <xc.h>
      int main()
      {
        int major, minor, micro;
        xc_version(&major, &minor, &micro);
        printf(\"%d.%d.%d\", major, minor, micro);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lxc", "-o", "ctest", "-lm"
    system "./ctest"

    (testpath/"test.f90").write <<~EOS
      program lxctest
        use xc_f03_lib_m
      end program lxctest
    EOS
    system "gfortran", "test.f90", "-L#{lib}", "-lxc", "-I#{include}",
                       "-o", "ftest"
    system "./ftest"
  end
end
