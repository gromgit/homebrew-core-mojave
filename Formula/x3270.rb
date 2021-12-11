class X3270 < Formula
  desc "IBM 3270 terminal emulator for the X Window System and Windows"
  homepage "http://x3270.bgp.nu/"
  url "http://x3270.bgp.nu/download/04.01/suite3270-4.1ga10-src.tgz"
  sha256 "8216572d0a14d4d18e65db97f6e2dd1aeb66eed02b4d544c79ed8d34ea54be71"
  license "BSD-3-Clause"

  livecheck do
    url "https://x3270.miraheze.org/wiki/Downloads"
    regex(/href=.*?suite3270[._-]v?(\d+(?:\.\d+)+(?:ga\d+)?)(?:-src)?\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/x3270"
    rebuild 2
    sha256 mojave: "9fe2e8e3a13eabfa6d14c3522ca3f85d7da5b3719abbecbc8582d96ec7d475dc"
  end

  depends_on "readline"

  uses_from_macos "tcl-tk"

  def install
    # use BSD date options on macOS
    # https://sourceforge.net/p/x3270/bugs/24/
    inreplace "Common/mkversion.sh", "date -d@", "date -r" if OS.mac?

    args = %W[
      --prefix=#{prefix}
      --enable-c3270
      --enable-pr3287
      --enable-s3270
      --enable-tcl3270
    ]
    system "./configure", *args
    system "make", "install"
    system "make", "install.man"
  end

  test do
    system bin/"c3270", "--version"
  end
end
