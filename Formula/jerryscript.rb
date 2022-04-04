class Jerryscript < Formula
  desc "Ultra-lightweight JavaScript engine for the Internet of Things"
  homepage "https://jerryscript.net"
  url "https://github.com/jerryscript-project/jerryscript/archive/v2.4.0.tar.gz"
  sha256 "5850947c23db6fbce032d15560551408ab155b16a94a7ac4412dc3bb85762d2d"
  license "Apache-2.0"
  head "https://github.com/jerryscript-project/jerryscript.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jerryscript"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "151d9e665115f61d6a09e57e828387cd59851a54b20d16df661883e7bf59c40b"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DCMAKE_BUILD_TYPE=MinSizeRel
      -DJERRY_CMDLINE=ON
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "make", "install"
    end
  end

  test do
    (testpath/"test.js").write "print('Hello, Homebrew!');"
    assert_equal "Hello, Homebrew!", shell_output("#{bin}/jerry test.js").strip

    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include "jerryscript.h"

      int main (void)
      {
        const jerry_char_t script[] = "1 + 2";
        const jerry_length_t script_size = sizeof(script) - 1;

        jerry_init(JERRY_INIT_EMPTY);
        jerry_value_t eval_ret = jerry_eval(script, script_size, JERRY_PARSE_NO_OPTS);
        bool run_ok = !jerry_value_is_error(eval_ret);
        if (run_ok) {
          printf("1 + 2 = %d\\n", (int) jerry_get_number_value(eval_ret));
        }

        jerry_release_value(eval_ret);
        jerry_cleanup();
        return (run_ok ? 0 : 1);
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}",
                   "-ljerry-core", "-ljerry-port-default", "-ljerry-ext", "-lm"
    assert_equal "1 + 2 = 3", shell_output("./test").strip, "JerryScript can add number"
  end
end
