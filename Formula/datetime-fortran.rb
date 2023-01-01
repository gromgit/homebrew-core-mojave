class DatetimeFortran < Formula
  desc "Fortran time and date manipulation library"
  homepage "https://github.com/wavebitscientific/datetime-fortran"
  url "https://github.com/wavebitscientific/datetime-fortran/releases/download/v1.7.0/datetime-fortran-1.7.0.tar.gz"
  sha256 "cff4c1f53af87a9f8f31256a3e04176f887cc3e947a4540481ade4139baf0d6f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/datetime-fortran"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "521f0012e2340646a071963871a2b57b4fb4fcdb7fb9094f7583ec551206bb10"
  end

  head do
    url "https://github.com/wavebitscientific/datetime-fortran.git"

    depends_on "autoconf"   => :build
    depends_on "automake"   => :build
    depends_on "pkg-config" => :build
  end

  depends_on "gcc" # for gfortran

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
    (pkgshare/"test").install "tests/datetime_tests.f90"
  end

  test do
    system "gfortran", "-I#{include}", pkgshare/"test/datetime_tests.f90",
                       "-L#{lib}", "-ldatetime", "-o", "test"
    system "./test"
  end
end
