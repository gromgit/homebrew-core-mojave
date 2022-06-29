class ErofsUtils < Formula
  desc "Utilities for Enhanced Read-Only File System"
  homepage "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git"
  url "https://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git/snapshot/erofs-utils-1.5.tar.gz"
  sha256 "2310fa4377b566bf943e8eef992db3990f759528d5973e700efe3e4cb115ec23"
  license "GPL-2.0-or-later"
  head "git://git.kernel.org/pub/scm/linux/kernel/git/xiang/erofs-utils.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/erofs-utils"
    sha256 cellar: :any, mojave: "4cdcd4b4c47e8d8caa05a67b5d00aff30318fc13e5dbff773298183febd845eb"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "util-linux" # for libuuid

  on_linux do
    depends_on "libfuse@2"
  end

  def install
    system "./autogen.sh"
    args = std_configure_args + %w[
      --disable-silent-rules
      --enable-lz4
      --disable-lzma
      --without-selinux
    ]

    # Enable erofsfuse only on Linux for now
    args << if OS.linux?
      "--enable-fuse"
    else
      "--disable-fuse"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"in/test1").write "G'day!"
    (testpath/"in/test2").write "Bonjour!"
    (testpath/"in/test3").write "Moien!"

    # Test mkfs.erofs can make a valid erofsimg.
    #   (Also tests that `lz4` support is properly linked.)
    system "#{bin}/mkfs.erofs", "--quiet", "-zlz4", "test.lz4.erofs", "in"
    assert_predicate testpath/"test.lz4.erofs", :exist?

    # Unfortunately, fsck.erofs doesn't support extraction for now, and
    # erofsfuse doesn't officially work on MacOS
  end
end
