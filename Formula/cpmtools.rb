class Cpmtools < Formula
  desc "Tools to access CP/M file systems"
  homepage "http://www.moria.de/~michael/cpmtools/"
  url "http://www.moria.de/~michael/cpmtools/files/cpmtools-2.23.tar.gz"
  sha256 "7839b19ac15ba554e1a1fc1dbe898f62cf2fd4db3dcdc126515facc6b929746f"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cpmtools[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpmtools"
    sha256 mojave: "1b0ba3e79bb923624726b71cf8c7f0be99417ec5fa1bb771cf8fc6eac4a47304"
  end

  depends_on "autoconf" => :build
  depends_on "libdsk"

  uses_from_macos "ncurses"

  def install
    # The ./configure script that comes with the 2.21 tarball is too old to work with Xcode 12
    system "autoconf", "--force"
    system "./configure", "--prefix=#{prefix}", "--with-libdsk"

    bin.mkpath
    man1.mkpath
    man5.mkpath

    system "make", "install"
  end

  test do
    # make a disk image
    image = testpath/"disk.cpm"
    system "#{bin}/mkfs.cpm", "-f", "ibm-3740", image

    # copy a file into the disk image
    src = testpath/"foo"
    src.write "a" * 128
    # Note that the "-T raw" is needed to make cpmtools work correctly when linked against libdsk:
    system "#{bin}/cpmcp", "-T", "raw", "-f", "ibm-3740", image, src, "0:foo"

    # check for the file in the cp/m directory
    assert_match "foo", shell_output("#{bin}/cpmls -T raw -f ibm-3740 #{image}")

    # copy the file back out of the image
    dest = testpath/"bar"
    system "#{bin}/cpmcp", "-T", "raw", "-f", "ibm-3740", image, "0:foo", dest
    assert_equal src.read, dest.read
  end
end
