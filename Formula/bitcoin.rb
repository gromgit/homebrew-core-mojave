class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0.tar.gz"
  sha256 "d0e9d089b57048b1555efa7cd5a63a7ed042482045f6f33402b1df425bf9613b"
  license "MIT"
  revision 1
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/bitcoin"
    rebuild 1
    sha256 cellar: :any, mojave: "6271a8a6be8ceff7f3e90fb3a3a4df3a21de9ec070307a49a9572ed0207ee1d5"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost@1.76"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "zeromq"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"bitcoind"
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
