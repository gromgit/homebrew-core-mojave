class Digitemp < Formula
  desc "Read temperature sensors in a 1-Wire net"
  homepage "https://www.digitemp.com/"
  url "https://github.com/bcl/digitemp/archive/v3.7.2.tar.gz"
  sha256 "683df4ab5cc53a45fe4f860c698f148d34bcca91b3e0568a342f32d64d12ba24"
  license "GPL-2.0"
  head "https://github.com/bcl/digitemp.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/digitemp"
    rebuild 1
    sha256 cellar: :any, mojave: "8bc0b1dbf1fb2c479e5f1d068e087fa52fdb8ca6dc8bbdef0417daef4d1de4c6"
  end


  depends_on "libusb-compat"

  def install
    mkdir_p "build-serial/src"
    mkdir_p "build-serial/userial/ds9097"
    mkdir_p "build-serial/userial/ds9097u"
    mkdir_p "build-usb/src"
    mkdir_p "build-usb/userial/ds2490"
    system "make", "-C", "build-serial", "-f", "../Makefile", "SRCDIR=..", "ds9097", "ds9097u"
    system "make", "-C", "build-usb", "-f", "../Makefile", "SRCDIR=..", "ds2490"
    bin.install "build-serial/digitemp_DS9097"
    bin.install "build-serial/digitemp_DS9097U"
    bin.install "build-usb/digitemp_DS2490"
    man1.install "digitemp.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS9097.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS9097U.1"
    man1.install_symlink "digitemp.1" => "digitemp_DS2490.1"
  end

  # digitemp has no self-tests and does nothing without a 1-wire device,
  # so at least check the individual binaries compiled to what we expect.
  test do
    assert_match "Compiled for DS2490", shell_output("#{bin}/digitemp_DS2490 2>&1", 255)
    assert_match "Compiled for DS9097", shell_output("#{bin}/digitemp_DS9097 2>&1", 255)
    assert_match "Compiled for DS9097U", shell_output("#{bin}/digitemp_DS9097U 2>&1", 255)
  end
end
