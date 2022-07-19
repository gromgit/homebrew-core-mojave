class Rush < Formula
  desc "GNU's Restricted User SHell"
  homepage "https://www.gnu.org/software/rush/"
  url "https://ftp.gnu.org/gnu/rush/rush-2.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/rush/rush-2.3.tar.xz"
  sha256 "8cae258247cd2623e856ea5e2c62cd7f09e9e3e043e6fc63bbd1abec3d3fdd93"
  license "GPL-3.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rush"
    sha256 mojave: "6256ccafd84e65f63108d57112c28dd560c08bfb225013e8b081286a9ab9acf7"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/rush", "-h"
  end
end
