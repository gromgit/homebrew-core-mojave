class PetscComplex < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (complex)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.16.2.tar.gz"
  sha256 "7ab257ae150d4837ac8d3872a1d206997962578785ec2427639ceac46d131bbc"
  license "BSD-2-Clause"

  livecheck do
    formula "petsc"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/petsc-complex"
    sha256 mojave: "479988e6ebbe3d2e5fe838062faf96b7b8a52d810c83b5c3d291f3033b81a800"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=complex",
                          "--with-x=0",
                          "--CC=mpicc",
                          "--CXX=mpicxx",
                          "--F77=mpif77",
                          "--FC=mpif90",
                          "MAKEFLAGS=$MAKEFLAGS"
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm_f lib/"petsc/conf/configure-hash"

    if OS.mac?
      inreplace lib/"petsc/conf/petscvariables", Superenv.shims_path, ""
    elsif File.readlines("#{lib}/petsc/conf/petscvariables").grep(Superenv.shims_path.to_s).any?
      inreplace lib/"petsc/conf/petscvariables", Superenv.shims_path, ""
    end
  end

  test do
    test_case = "#{share}/petsc/examples/src/ksp/ksp/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
