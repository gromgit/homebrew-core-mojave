class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.6.7.tar.gz"
  sha256 "7bedfc46036f0bb99d4d81b5a344fa8c24ada2372029b6cbe0c2c475469b2b70"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tbox"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0b6541bf024d3099d95efd17ba7de7e1e074d5b48a5944d4f331a072c82d1fd4"
  end

  depends_on "xmake" => :build

  def install
    system "xmake", "config", "--charset=y", "--demo=n", "--small=y", "--xml=y"
    system "xmake"
    system "xmake", "install", "-o", prefix
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <tbox/tbox.h>
      int main()
      {
        if (tb_init(tb_null, tb_null))
        {
          tb_trace_i("hello tbox!");
          tb_exit();
        }
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-ltbox", "-lm", "-pthread", "-o", "test"
    assert_equal "hello tbox!\n", shell_output("./test")
  end
end
