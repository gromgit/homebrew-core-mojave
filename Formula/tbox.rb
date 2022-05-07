class Tbox < Formula
  desc "Glib-like multi-platform C library"
  homepage "https://tboox.org/"
  url "https://github.com/tboox/tbox/archive/v1.6.8.tar.gz"
  sha256 "f437a31caa769a980e2e38ecc5bf37f1e572325d5d60fd242b9d6d49174b66fd"
  license "Apache-2.0"
  head "https://github.com/tboox/tbox.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tbox"
    sha256 cellar: :any_skip_relocation, mojave: "9ced717fd0a36159e151dd83a62edc908bcdfe1e658804524ff3f52ac839464a"
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
