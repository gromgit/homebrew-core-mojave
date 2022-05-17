class Blis < Formula
  desc "BLAS-like Library Instantiation Software Framework"
  homepage "https://github.com/flame/blis"
  url "https://github.com/flame/blis/archive/0.9.0.tar.gz"
  sha256 "1135f664be7355427b91025075562805cdc6cc730d3173f83533b2c5dcc2f308"
  license "BSD-3-Clause"
  head "https://github.com/flame/blis.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/blis"
    sha256 cellar: :any, mojave: "29f7ffe5c482c0a528c0f80afd51e287033725ea6299d947f8fd59a700eea849"
  end

  uses_from_macos "python" => :build

  on_linux do
    depends_on "gcc" => [:build, :test]
  end

  fails_with gcc: "5"

  def install
    # https://github.com/flame/blis/blob/master/docs/ConfigurationHowTo.md
    ENV.runtime_cpu_detection
    config = if !build.bottle?
      "auto"
    elsif OS.mac?
      # For Apple Silicon, we can optimize using the dedicated "firestorm" config.
      # For Intel Macs, we build multiple Intel x86_64 to allow runtime optimization.
      Hardware::CPU.arm? ? "firestorm" : "intel64"
    else
      # For x86_64 Linux, we build full "x86_64" family with Intel and AMD processors.
      Hardware::CPU.arch
    end

    system "./configure", "--prefix=#{prefix}", "--enable-cblas", config
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <stdlib.h>
      #include <math.h>
      #include "blis/blis.h"

      int main(void) {
        int i;
        double A[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double B[6] = {1.0, 2.0, 1.0, -3.0, 4.0, -1.0};
        double C[9] = {.5, .5, .5, .5, .5, .5, .5, .5, .5};
        cblas_dgemm(CblasColMajor, CblasNoTrans, CblasTrans,
                    3, 3, 2, 1, A, 3, B, 3, 2, C, 3);
        for (i = 0; i < 9; i++)
          printf("%lf ", C[i]);
        printf("\\n");
        if (fabs(C[0]-11) > 1.e-5) abort();
        if (fabs(C[4]-21) > 1.e-5) abort();
        return 0;
      }
    EOS
    system ENV.cc, "-o", "test", "test.c", "-I#{include}", "-L#{lib}", "-lblis", "-lm"
    system "./test"
  end
end
