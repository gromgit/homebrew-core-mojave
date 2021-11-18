class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.3.0.tar.gz"
  sha256 "d8dcc83f8e9686e6855da4c33d8c373f1735d87294edbd86ed662ba2f2f89277"
  license "BSD-2-Clause-Patent"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libvmaf"
    rebuild 1
    sha256 cellar: :any, mojave: "567811e298b9ce9591e0c03dc5256a726b53ab2c0fa373ab6f1705fee15b6bda"
  end

  depends_on "meson" => :build
  depends_on "nasm" => :build
  depends_on "ninja" => :build

  def install
    Dir.chdir("libvmaf") do
      system "meson", *std_meson_args, "build"
      system "ninja", "-vC", "build"
      system "ninja", "-vC", "build", "install"
    end
    pkgshare.install "model"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libvmaf/libvmaf.h>
      int main() {
        return 0;
      }
    EOS

    flags = [
      "-I#{HOMEBREW_PREFIX}/include/libvmaf",
      "-L#{lib}",
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
