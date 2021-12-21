class Scs < Formula
  desc "Conic optimization via operator splitting"
  homepage "https://web.stanford.edu/~boyd/papers/scs.html"
  url "https://github.com/cvxgrp/scs/archive/v3.0.0.tar.gz"
  sha256 "95ab61495db72b18d6bb690cd2ae2ce88134d078c473da6cb8750857ea17f732"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/scs"
    sha256 cellar: :any, mojave: "a5cfa7dc6e70dde6d8d927d1cde66c1f33de7b64462083f675d83a390ab2f32a"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "test/problems/random_prob"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <rw.h>
      #include <scs.h>
      #include <util.h>
      int main() {
        ScsData *d; ScsCone *k; ScsSettings *stgs;
        ScsSolution *sol = scs_calloc(1, sizeof(ScsSolution));
        ScsInfo info;
        scs_int result;

        scs_read_data("#{pkgshare}/random_prob", &d, &k, &stgs);
        result = scs(d, k, stgs, sol, &info);

        scs_free_data(d, k, stgs); scs_free_sol(sol);
        return result - SCS_SOLVED;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsindir",
                   "-o", "testscsindir"
    system "./testscsindir"
    system ENV.cc, "test.c", "-I#{include}/scs", "-L#{lib}", "-lscsdir",
                   "-o", "testscsdir"
    system "./testscsdir"
  end
end
