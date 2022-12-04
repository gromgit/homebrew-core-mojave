class Libvmaf < Formula
  desc "Perceptual video quality assessment based on multi-method fusion"
  homepage "https://github.com/Netflix/vmaf"
  url "https://github.com/Netflix/vmaf/archive/v2.3.1.tar.gz"
  sha256 "8d60b1ddab043ada25ff11ced821da6e0c37fd7730dd81c24f1fc12be7293ef2"
  license "BSD-2-Clause-Patent"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libvmaf"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "cc4f54a99eac7c0347ad59ce5a092ca2be80f61995a7c6e6d2e96e65f43374ce"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

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
