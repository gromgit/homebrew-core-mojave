class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "e9c4ebb63fe37dcf77638f280e619776d4e93884d9063084432f18bff2020cfe"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/librem"
    sha256 cellar: :any, mojave: "f0f3cf123926649cd6bc9063b56d97e7baa30fbb8b79cf239521ea21e9ea415e"
  end

  depends_on "libre"

  def install
    libre = Formula["libre"]
    system "make", "install", "PREFIX=#{prefix}",
                              "LIBRE_MK=#{libre.opt_share}/re/re.mk",
                              "LIBRE_INC=#{libre.opt_include}/re",
                              "LIBRE_SO=#{libre.opt_lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <re/re.h>
      #include <rem/rem.h>
      int main() {
        return (NULL != vidfmt_name(VID_FMT_YUV420P)) ? 0 : 1;
      }
    EOS
    system ENV.cc, "test.c", "-L#{opt_lib}", "-lrem", "-o", "test"
    system "./test"
  end
end
