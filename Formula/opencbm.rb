class Opencbm < Formula
  desc "Provides access to various floppy drive formats"
  homepage "https://spiro.trikaliotis.net/opencbm"
  url "https://github.com/OpenCBM/OpenCBM/archive/v0.4.99.104.tar.gz"
  sha256 "5499cd1143b4a246d6d7e93b94efbdf31fda0269d939d227ee5bcc0406b5056a"
  license "GPL-2.0-only"
  head "https://git.code.sf.net/p/opencbm/code.git", branch: "master"

  livecheck do
    url :homepage
    regex(/<h1[^>]*?>VERSION v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/opencbm"
    sha256 mojave: "3b8828966b97e17f9a92128c9596110f4cd567def2a59c34421726c6b4e74137"
  end

  # cc65 is only used to build binary blobs included with the programs; it's
  # not necessary in its own right.
  depends_on "cc65" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    # This one definitely breaks with parallel build.
    ENV.deparallelize

    args = %W[
      -fLINUX/Makefile
      LIBUSB_CONFIG=#{Formula["libusb-compat"].bin}/libusb-config
      PREFIX=#{prefix}
      MANDIR=#{man1}
    ]

    system "make", *args
    system "make", "install-all", *args
  end

  test do
    system "#{bin}/cbmctrl", "--help"
  end
end
