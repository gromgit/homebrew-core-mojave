class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://github.com/lcdproc/lcdproc/releases/download/v0.5.9/lcdproc-0.5.9.tar.gz"
  sha256 "d48a915496c96ff775b377d2222de3150ae5172bfb84a6ec9f9ceab962f97b83"
  license "GPL-2.0"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lcdproc"
    sha256 mojave: "c1f0263c976162bb47d4ee8f0fd016a8a54a360ecc762b60af73157784788587"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libusb"
  depends_on "libusb-compat" # Remove when all drivers migrated https://github.com/lcdproc/lcdproc/issues/13

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lcdproc -v 2>&1")
  end
end
