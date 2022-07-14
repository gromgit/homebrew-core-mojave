class Libdmtx < Formula
  desc "Data Matrix library"
  homepage "https://libdmtx.sourceforge.io"
  url "https://github.com/dmtx/libdmtx/archive/v0.7.7.tar.gz"
  sha256 "7aa62adcefdd6e24bdabeb82b3ce41a8d35f4a0c95ab0c4438206aecafd6e1a1"
  license "BSD-2-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libdmtx"
    sha256 cellar: :any, mojave: "51bc9f47862ce7ddbf0f6c358afb0ddc9efe84bf9de5bf8c7fa9aa7ea94d0a24"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
