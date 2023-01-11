class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https://github.com/ipmitool/ipmitool"
  url "https://github.com/ipmitool/ipmitool/archive/refs/tags/IPMITOOL_1_8_19.tar.gz"
  sha256 "48b010e7bcdf93e4e4b6e43c53c7f60aa6873d574cbd45a8d86fa7aaeebaff9c"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ipmitool"
    rebuild 1
    sha256 mojave: "192e611ca7df21e13467d6d713cb5439918f738b8a32eb028148e84c286bc8e5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "readline"
  end

  # Patch to fix build on ARM
  # https://github.com/ipmitool/ipmitool/issues/332
  patch do
    url "https://github.com/ipmitool/ipmitool/commit/a45da6b4dde21a19e85fd87abbffe31ce9a8cbe6.patch?full_index=1"
    sha256 "98787263c33fe11141a6b576d52f73127b223394c3d2c7b1640d4adc075f14d5"
  end

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--disable-intf-usb"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Test version print out
    system bin/"ipmitool", "-V"
  end
end
