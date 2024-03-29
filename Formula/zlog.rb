class Zlog < Formula
  desc "High-performance C logging library"
  homepage "https://github.com/HardySimpson/zlog"
  url "https://github.com/HardySimpson/zlog/archive/1.2.16.tar.gz"
  sha256 "742401902f2134eb272c49631fe5c38d7aeb9a2ad56fa3ec3d15219b371ba655"
  license "LGPL-2.1-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/zlog"
    rebuild 1
    sha256 cellar: :any, mojave: "f26bcc31c8968d9a503a84edbb4427c7bb08055359b58a6e5be27e8855ebb08a"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    (testpath/"zlog.conf").write <<~EOS
      [formats]
      simple = "%m%n"
      [rules]
      my_cat.DEBUG    >stdout; simple
    EOS
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <zlog.h>
      int main() {
        int rc;
        zlog_category_t *c;

        rc = zlog_init("zlog.conf");
        if (rc) {
          printf("init failed!");
          return -1;
        }

        c = zlog_get_category("my_cat");
        if (!c) {
          printf("get cat failed!");
          zlog_fini();
          return -2;
        }

        zlog_info(c, "hello, zlog!");
        zlog_fini();

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lzlog", "-pthread", "-o", "test"
    assert_equal "hello, zlog!\n", shell_output("./test")
  end
end
