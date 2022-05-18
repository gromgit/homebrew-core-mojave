# Jigdo is dead upstream. It consists of two components: Jigdo, a GTK+ using GUI,
# which is LONG dead and completely unfunctional, and jigdo-lite, a command-line
# tool that has been on life support and still works. Only build the CLI tool.
class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "https://www.einval.com/~steve/software/jigdo/"
  url "http://atterer.org/sites/atterer/files/2009-08/jigdo/jigdo-0.7.3.tar.bz2"
  sha256 "875c069abad67ce67d032a9479228acdb37c8162236c0e768369505f264827f0"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  revision 7

  livecheck do
    url "https://www.einval.com/~steve/software/jigdo/download/"
    regex(/href=.*?jigdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/jigdo"
    sha256 mojave: "1c5c4f636fe41af834da150ff46bdd5170baa240c0e2bca501adcdb68f44415e"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_macos do
    # Use MacPorts patch for compilation on 10.9. Remove when updating to 0.8+.
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e101570/jigdo/patch-src-compat.hh.diff"
      sha256 "a21aa8bcc5a03a6daf47e0ab4e04f16e611e787a7ada7a6a87c8def738585646"
    end
  end

  on_linux do
    # Use Fedora patch for compilation with GCC. Remove when updating to 0.8+.
    patch do
      url "https://src.fedoraproject.org/rpms/jigdo/raw/27c01e27168b62157e98c7ffad1aa0b4aad405e9/f/jigdo-0.7.3-gcc43.patch"
      sha256 "57e13ca6c283cb086d1c5ceb5ed3562fab548fa19e1d14ecc045c3a23fa7d44a"
    end
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-x11",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/jigdo-file -v")
  end
end
