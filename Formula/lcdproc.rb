class Lcdproc < Formula
  desc "Display real-time system information on a LCD"
  homepage "http://www.lcdproc.org/"
  url "https://github.com/lcdproc/lcdproc/releases/download/v0.5.9/lcdproc-0.5.9.tar.gz"
  sha256 "d48a915496c96ff775b377d2222de3150ae5172bfb84a6ec9f9ceab962f97b83"
  license "GPL-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lcdproc"
    sha256 mojave: "2d92348df474d041b0f8c5a03c247decbb93e5adda417d6ad68f63f8e2453809"
  end

  depends_on "pkg-config" => :build
  depends_on "libftdi"
  depends_on "libhid"
  depends_on "libusb"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-drivers=all",
                          "--enable-libftdi=yes"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lcdproc -v 2>&1")
  end
end
