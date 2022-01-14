class Superlu < Formula
  desc "Solve large, sparse nonsymmetric systems of equations"
  homepage "https://portal.nersc.gov/project/sparse/superlu/"
  url "https://github.com/xiaoyeli/superlu/archive/v5.3.0.tar.gz"
  sha256 "3e464afa77335de200aeb739074a11e96d9bef6d0b519950cfa6684c4be1f350"
  license "BSD-3-Clause-LBNL"

  livecheck do
    url :homepage
    regex(/href=.*?superlu[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/superlu"
    sha256 mojave: "c67a33e9886d226aa13334482ec7246aa5fb501d7d4da716bff1c4394286ce07"
  end

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "openblas"

  def install
    args = std_cmake_args + %W[
      -Denable_internal_blaslib=NO
      -DTPL_BLAS_LIBRARIES=#{Formula["openblas"].opt_lib}/#{shared_library("libopenblas")}
      -DBUILD_SHARED_LIBS=YES
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Source and data for test
    pkgshare.install "EXAMPLE/dlinsol.c"
    pkgshare.install "EXAMPLE/g20.rua"
  end

  test do
    system ENV.cc, pkgshare/"dlinsol.c", "-o", "test",
                   "-I#{include}/superlu", "-L#{lib}", "-lsuperlu",
                   "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    assert_match "No of nonzeros in L+U = 11886",
                 shell_output("./test < #{pkgshare}/g20.rua")
  end
end
