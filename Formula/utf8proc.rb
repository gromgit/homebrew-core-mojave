class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.8.0.tar.gz"
  sha256 "a0a60a79fe6f6d54e7d411facbfcc867a6e198608f2cd992490e46f04b1bcecc"
  license all_of: ["MIT", "Unicode-DFS-2015"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/utf8proc"
    rebuild 1
    sha256 cellar: :any, mojave: "c9818cbf67002052c587629c4d4c3547c8731206b9533fa6cb7cc3c2e968709f"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>
      #include <utf8proc.h>

      int main() {
        const char *version = utf8proc_version();
        return strnlen(version, sizeof("1.3.1-dev")) > 0 ? 0 : -1;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lutf8proc", "-o", "test"
    system "./test"
  end
end
