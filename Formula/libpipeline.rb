class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "https://libpipeline.gitlab.io/libpipeline/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.7.tar.gz"
  sha256 "b8b45194989022a79ec1317f64a2a75b1551b2a55bea06f67704cb2a2e4690b0"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libpipeline/"
    regex(/href=.*?libpipeline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libpipeline"
    sha256 cellar: :any, mojave: "3e75617b611d64c42b426e2a7ecddd1b22065fbd344b2a4a0611591489795368"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <pipeline.h>
      int main() {
        pipeline *p = pipeline_new();
        pipeline_command_args(p, "echo", "Hello world", NULL);
        pipeline_command_args(p, "cat", NULL);
        return pipeline_run(p);
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lpipeline", "-o", "test"
    assert_match "Hello world", shell_output("./test")
  end
end
