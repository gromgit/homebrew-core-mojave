class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v2.10.0.tar.gz"
  sha256 "4d2b6f8fc73efdbcb5a7b2a98d0b46ac6eb28ede5ae90f9596b49663eec623a9"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libre"
    sha256 cellar: :any, mojave: "6189a082365cb23b6de70a4d3da2027f84ad07a3698ed19a4aa4201cd9b0183d"
  end

  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    sysroot = "SYSROOT=#{MacOS.sdk_path}/usr" if OS.mac?
    system "make", *sysroot, "install", "PREFIX=#{prefix}", "RELEASE=1", "V=1"
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
