class Libiscsi < Formula
  desc "Client library and utilities for iscsi"
  homepage "https://github.com/sahlberg/libiscsi"
  url "https://github.com/sahlberg/libiscsi/archive/1.19.0.tar.gz"
  sha256 "c7848ac722c8361d5064654bc6e926c2be61ef11dd3875020a63931836d806df"
  license "GPL-2.0"
  head "https://github.com/sahlberg/libiscsi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libiscsi"
    rebuild 1
    sha256 cellar: :any, mojave: "b975229f16a67203609fafc11ca55dfc8381c6f5c7945d5cb4cc7c1edba2d6f9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "cunit"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"iscsi-ls", "--help"
    system bin/"iscsi-test-cu", "--list"
  end
end
