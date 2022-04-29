class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "https://libpipeline.nongnu.org/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.6.tar.gz"
  sha256 "60fbb9e7dc398528e5f3a776af57bb28ca3fe5d9f0cd8a961ac6cebfe6e9b797"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libpipeline/"
    regex(/href=.*?libpipeline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libpipeline"
    sha256 cellar: :any, mojave: "d2a15bbcfd45c7be495ba330b961897c02a4e359fb704a4ee6fdd17fbbe01571"
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
