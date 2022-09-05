class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v4.0/bmon-4.0.tar.gz"
  sha256 "02fdc312b8ceeb5786b28bf905f54328f414040ff42f45c83007f24b76cc9f7a"
  license "BSD-2-Clause"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bmon"
    rebuild 2
    sha256 cellar: :any, mojave: "417675db08dc2ec8dfdfe9987e4d0c5f52a1c96f06cb3672c7fec2d7f113370e"
  end

  head do
    url "https://github.com/tgraf/bmon.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libnl"
  end

  def install
    # Workaround for https://github.com/tgraf/bmon/issues/89 build issue:
    inreplace "include/bmon/bmon.h", "#define __unused__", "//#define __unused__"
    inreplace %w[src/in_proc.c src/out_curses.c], "__unused__", ""

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"bmon", "-o", "ascii:quitafter=1"
  end
end
