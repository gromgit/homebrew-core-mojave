class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.3/libdvdcss-1.4.3.tar.bz2"
  sha256 "233cc92f5dc01c5d3a96f5b3582be7d5cee5a35a52d3a08158745d3d86070079"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.videolan.org/pub/libdvdcss/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libdvdcss"
    rebuild 1
    sha256 cellar: :any, mojave: "ecc66fc961aae236cfd38556d05dbfe84d61b63e73d8d206db2cf3a532dfef72"
  end

  head do
    url "https://code.videolan.org/videolan/libdvdcss.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
