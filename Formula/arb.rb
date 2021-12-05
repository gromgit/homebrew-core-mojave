class Arb < Formula
  desc "C library for arbitrary-precision interval arithmetic"
  homepage "https://arblib.org"
  url "https://github.com/fredrik-johansson/arb/archive/2.21.1.tar.gz"
  sha256 "aecc9f55eb35a00a2490e9a7536a0babf8ac86bb13d32a4a95e1216f9f5cbfa8"
  license "LGPL-2.1-or-later"
  head "https://github.com/fredrik-johansson/arb.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arb"
    rebuild 2
    sha256 cellar: :any, mojave: "a30147a7806f3c843a98962109c961a369b0c2948c2eedf98f8bc935ecccbc8f"
  end

  depends_on "cmake" => :build
  depends_on "flint"
  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <arb.h>

      int main()
      {
          slong prec;
          arb_t x, y;
          arb_init(x); arb_init(y);

          for (prec = 64; ; prec *= 2)
          {
              arb_const_pi(x, prec);
              arb_set_si(y, -10000);
              arb_exp(y, y, prec);
              arb_add(x, x, y, prec);
              arb_sin(y, x, prec);
              if (arb_rel_accuracy_bits(y) >= 53) {
                  arb_printn(y, 15, 0); printf("\\n");
                  break;
              }
          }

          arb_clear(x); arb_clear(y);
          flint_cleanup();
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["flint"].opt_include}",
           "-L#{lib}", "-L#{Formula["flint"].opt_lib}",
           "-larb", "-lflint", "-o", "test"
    assert_match %r{\[-?\d+\.\d+e-\d+ \+/- \d+\.\d+e-\d+\]}, shell_output("./test")
  end
end
