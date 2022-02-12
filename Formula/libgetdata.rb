class Libgetdata < Formula
  desc "Reference implementation of the Dirfile Standards"
  homepage "https://getdata.sourceforge.io/"
  # TODO: Check if extra `make` call can be removed at version bump.
  url "https://downloads.sourceforge.net/project/getdata/getdata/0.11.0/getdata-0.11.0.tar.xz"
  sha256 "d16feae0907090047f5cc60ae0fb3500490e4d1889ae586e76b2d3a2e1c1b273"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgetdata"
    sha256 cellar: :any, mojave: "0d8b912bf5dacca40602f9f15234c785b43112204629d43f983b3d7212e70984"
  end

  depends_on "libtool"

  uses_from_macos "perl"
  uses_from_macos "zlib"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-fortran",
                          "--disable-fortran95",
                          "--disable-php",
                          "--disable-python",
                          "--without-liblzma",
                          "--without-libzzip"

    ENV.deparallelize # can't open file: .libs/libgetdatabzip2-0.11.0.so (No such file or directory)
    system "make"
    # The Makefile seems to try to install things in the wrong order.
    # Remove this when the following PR is merged/resolved and lands in a release:
    # https://github.com/ketiltrout/getdata/pull/6
    system "make", "-C", "bindings/perl", "install-nodist_perlautogetdataSCRIPTS"
    system "make", "install"
  end

  test do
    assert_match "GetData #{version}", shell_output("#{bin}/checkdirfile --version", 1)
  end
end
