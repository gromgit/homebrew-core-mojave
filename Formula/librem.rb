class Librem < Formula
  desc "Toolkit library for real-time audio and video processing"
  homepage "https://github.com/baresip/rem"
  url "https://github.com/baresip/rem/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "7f4ad245eb9fb07a82890022d1c721c93ee2e299acb88a7e775ca541f7a09892"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/librem"
    sha256 cellar: :any, mojave: "8d5f964f2416eaad54b2e45bb89dbb3d7e2bbe6053748423e12207987407e55c"
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
