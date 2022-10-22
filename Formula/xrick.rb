class Xrick < Formula
  desc "Clone of Rick Dangerous"
  homepage "https://www.bigorno.net/xrick/"
  url "https://www.bigorno.net/xrick/xrick-021212.tgz"
  # There is a repo at https://github.com/zpqrtbnk/xrick but it is organized
  # differently than the tarball
  sha256 "aa8542120bec97a730258027a294bd16196eb8b3d66134483d085f698588fc2b"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/xrick"
    sha256 mojave: "2f2f331dfb6592a2421cfe9ba6dfc1bc7f93a7cd6f6d2b92463848da77e6c484"
  end

  depends_on "sdl12-compat"

  uses_from_macos "zlib"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`:
    # scr_xrick.o:(.data.rel.local+0x18): multiple definition of `IMG_SPLASH'
    # Makefile override environment variables so we need to inreplace.
    inreplace "Makefile", "echo \"CFLAGS=", "\\0-fcommon " if OS.linux?

    inreplace "src/xrick.c", "data.zip", pkgshare/"data.zip"
    system "make"
    bin.install "xrick"
    man6.install "xrick.6.gz"
    pkgshare.install "data.zip"
  end

  test do
    assert_match "xrick [version ##{version}]", shell_output("#{bin}/xrick --help", 1)
  end
end
