class Patchelf < Formula
  desc "Modify dynamic ELF executables"
  homepage "https://github.com/NixOS/patchelf"
  url "https://github.com/NixOS/patchelf/releases/download/0.14.3/patchelf-0.14.3.tar.bz2"
  sha256 "a017ec3d2152a19fd969c0d87b3f8b43e32a66e4ffabdc8767a56062b9aec270"
  license "GPL-3.0-or-later"
  head "https://github.com/NixOS/patchelf.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/patchelf"
    sha256 cellar: :any_skip_relocation, mojave: "5834a507ca2dcb0d36fa3c6b42a6de97c7827d49452943bb70827ec8f8aa67bd"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # Needs std::optional

  resource "homebrew-helloworld" do
    url "http://timelessname.com/elfbin/helloworld.tar.gz"
    sha256 "d8c1e93f13e0b7d8fc13ce75d5b089f4d4cec15dad91d08d94a166822d749459"
  end

  def install
    if OS.linux?
      # Fix ld.so path and rpath
      # see https://github.com/Homebrew/linuxbrew-core/pull/20548#issuecomment-672061606
      ENV["HOMEBREW_DYNAMIC_LINKER"] = File.readlink("#{HOMEBREW_PREFIX}/lib/ld.so")
      ENV["HOMEBREW_RPATH_PATHS"] = nil
    end

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    resource("homebrew-helloworld").stage do
      assert_equal "/lib/ld-linux.so.2\n", shell_output("#{bin}/patchelf --print-interpreter chello")
      assert_equal "libc.so.6\n", shell_output("#{bin}/patchelf --print-needed chello")
      assert_equal "\n", shell_output("#{bin}/patchelf --print-rpath chello")
      assert_equal "", shell_output("#{bin}/patchelf --set-rpath /usr/local/lib chello")
      assert_equal "/usr/local/lib\n", shell_output("#{bin}/patchelf --print-rpath chello")
    end
  end
end
