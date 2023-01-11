class Hypre < Formula
  desc "Library featuring parallel multigrid methods for grid problems"
  homepage "https://computing.llnl.gov/projects/hypre-scalable-linear-solvers-multigrid-methods"
  url "https://github.com/hypre-space/hypre/archive/v2.26.0.tar.gz"
  sha256 "c214084bddc61a06f3758d82947f7f831e76d7e3edeac2c78bb82d597686e05d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/hypre-space/hypre.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hypre"
    sha256 cellar: :any_skip_relocation, mojave: "350f957171a9d34a916064773bd6575c13cf798ac722eb284bd61f4eb8e53718"
  end

  depends_on "gcc" # for gfortran
  depends_on "open-mpi"

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-MPI",
                            "--enable-bigint"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "HYPRE_struct_ls.h"
      int main(int argc, char* argv[]) {
        HYPRE_StructGrid grid;
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test"
    system "./test"
  end
end
