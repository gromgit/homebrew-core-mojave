class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "25d66108f827507d1a08dc15d4a2a6d994e0cc2368f2faa6778b3a48c0d15f2f"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libre"
    sha256 cellar: :any, mojave: "4e4fd183c0b002e752e5b05f41dab1568f7af310c62e4226a9190d6a3435ffbb"
  end

  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    sysroot = "SYSROOT=#{MacOS.sdk_path}/usr" if OS.mac?
    system "make", *sysroot, "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lre"
  end
end
