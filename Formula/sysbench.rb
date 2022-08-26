class Sysbench < Formula
  desc "System performance benchmark tool"
  homepage "https://github.com/akopytov/sysbench"
  url "https://github.com/akopytov/sysbench/archive/1.0.20.tar.gz"
  sha256 "e8ee79b1f399b2d167e6a90de52ccc90e52408f7ade1b9b7135727efe181347f"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/akopytov/sysbench.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sysbench"
    rebuild 1
    sha256 cellar: :any, mojave: "cca9b3c6563460dc1344b245c4c6b488680f360d3107ae3c6121f75bb2a6b41e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "luajit-openresty"
  depends_on "mysql-client"
  depends_on "openssl@1.1"

  uses_from_macos "vim" # needed for xxd

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--with-mysql", "--with-system-luajit"
    system "make", "install"
  end

  test do
    system "#{bin}/sysbench", "--test=cpu", "--cpu-max-prime=1", "run"
  end
end
