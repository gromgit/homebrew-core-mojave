class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "https://opencore-amr.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-0.1.6.tar.gz"
  sha256 "483eb4061088e2b34b358e47540b5d495a96cd468e361050fae615b1809dc4a1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/opencore-amr[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/opencore-amr"
    sha256 cellar: :any, mojave: "1507156780269559b8b82b30a909a82813a023a726fd4922c26d21c567db52e3"
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <opencore-amrwb/dec_if.h>
      int main(void) {
        void *s = D_IF_init();
        D_IF_exit(s);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lopencore-amrwb", "-o", "test"
    system "./test"
  end
end
