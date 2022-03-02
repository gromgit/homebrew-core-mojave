class Libconfig < Formula
  desc "Configuration file processing library"
  homepage "https://hyperrealm.github.io/libconfig/"
  url "https://github.com/hyperrealm/libconfig/archive/v1.7.3.tar.gz"
  sha256 "68757e37c567fd026330c8a8449aa5f9cac08a642f213f2687186b903bd7e94e"
  license "LGPL-2.1-or-later"
  head "https://github.com/hyperrealm/libconfig.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libconfig"
    rebuild 1
    sha256 cellar: :any, mojave: "fd0793bfdc7a5d02015f0d3e5a0562005ff4cc0afc630071321ad77f3f89e4ae"
  end


  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "texinfo" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libconfig.h>
      int main() {
        config_t cfg;
        config_init(&cfg);
        config_destroy(&cfg);
        return 0;
      }
    EOS
    system ENV.cc, testpath/"test.c", "-I#{include}",
           "-L#{lib}", "-lconfig", "-o", testpath/"test"
    system "./test"
  end
end
