class Libslirp < Formula
  desc "General purpose TCP-IP emulator"
  homepage "https://gitlab.freedesktop.org/slirp/libslirp"
  url "https://gitlab.freedesktop.org/slirp/libslirp/-/archive/v4.7.0/libslirp-v4.7.0.tar.gz"
  sha256 "9398f0ec5a581d4e1cd6856b88ae83927e458d643788c3391a39e61b75db3d3b"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libslirp"
    rebuild 1
    sha256 cellar: :any, mojave: "3de6e8638756508abd5e5c9423841a03ea052fb332f4b11a30bd7cf165f17db5"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "meson", "build", "-Ddefault_library=both", *std_meson_args
    system "ninja", "-C", "build", "install", "all"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <string.h>
      #include <stddef.h>
      #include <slirp/libslirp.h>
      int main() {
        SlirpConfig cfg;
        memset(&cfg, 0, sizeof(cfg));
        cfg.version = 1;
        cfg.in_enabled = true;
        cfg.vhostname = "testServer";
        Slirp* ctx = slirp_new(&cfg, NULL, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lslirp", "-o", "test"
    system "./test"
  end
end
