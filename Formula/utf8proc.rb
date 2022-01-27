class Utf8proc < Formula
  desc "Clean C library for processing UTF-8 Unicode data"
  homepage "https://juliastrings.github.io/utf8proc/"
  url "https://github.com/JuliaStrings/utf8proc/archive/v2.7.0.tar.gz"
  sha256 "4bb121e297293c0fd55f08f83afab6d35d48f0af4ecc07523ad8ec99aa2b12a1"
  license all_of: ["MIT", "Unicode-DFS-2015"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/utf8proc"
    rebuild 1
    sha256 cellar: :any, mojave: "8885da034ef7148b5a1415000d2b5c61acc9abafe885c14151175823ba6b8ce9"
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
