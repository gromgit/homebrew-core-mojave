class Mt32emu < Formula
  desc "Multi-platform software synthesiser"
  homepage "https://github.com/munt/munt"
  url "https://github.com/munt/munt/archive/refs/tags/libmt32emu_2_6_3.tar.gz"
  sha256 "a24ee0a8ae9aa4138ffb185f123768b23fbb8b5b3bebb07882f3ba2836ed4905"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^libmt32emu[._-]v?(\d+(?:[._-]\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mt32emu"
    sha256 cellar: :any, mojave: "1af0905ccc96f04e52f5a183a752546e91e960dd055087125d322a68935242cb"
  end

  depends_on "cmake" => :build
  depends_on "libsamplerate"
  depends_on "libsoxr"

  def install
    system "cmake", "-S", "mt32emu", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"mt32emu-test.c").write <<~EOS
      #include "mt32emu.h"
      #include <stdio.h>
      int main() {
        printf("%s", mt32emu_get_library_version_string());
      }
    EOS

    system ENV.cc, "mt32emu-test.c", "-I#{include}", "-L#{lib}", "-lmt32emu", "-o", "mt32emu-test"
    assert_match version.to_s, shell_output("./mt32emu-test")
  end
end
