class Shtools < Formula
  desc "Spherical Harmonic Tools"
  homepage "https://shtools.github.io/SHTOOLS/"
  url "https://github.com/SHTOOLS/SHTOOLS/releases/download/v4.10.1/SHTOOLS-4.10.1.tar.gz"
  sha256 "f4fb5c86841fe80136b520d2040149eafd4bc2d49da6b914d8a843b812f20b61"
  license "BSD-3-Clause"
  head "https://github.com/SHTOOLS/SHTOOLS.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/shtools"
    sha256 cellar: :any_skip_relocation, mojave: "f19fcbaf5a6b6427a069c73fe6feba792f9577de5dfc8ff60f06e02084308b56"
  end

  depends_on "fftw"
  depends_on "gcc"
  depends_on "openblas"

  on_linux do
    depends_on "libtool" => :build
  end

  def install
    system "make", "fortran"
    system "make", "fortran-mp"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    cp_r "#{share}/examples/shtools", testpath
    system "make", "-C", "shtools/fortran",
                   "run-fortran-tests-no-timing",
                   "F95=gfortran",
                   "F95FLAGS=-m64 -fPIC -O3 -std=gnu -ffast-math",
                   "MODFLAG=-I#{HOMEBREW_PREFIX}/include",
                   "LIBPATH=#{HOMEBREW_PREFIX}/lib",
                   "LIBNAME=SHTOOLS",
                   "FFTW=-L #{HOMEBREW_PREFIX}/lib -lfftw3 -lm",
                   "LAPACK=-L #{Formula["openblas"].opt_lib} -lopenblas",
                   "BLAS="
  end
end
