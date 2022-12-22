class Btpd < Formula
  desc "BitTorrent Protocol Daemon"
  homepage "https://github.com/btpd/btpd"
  url "https://github.com/downloads/btpd/btpd/btpd-0.16.tar.gz"
  sha256 "296bdb718eaba9ca938bee56f0976622006c956980ab7fc7a339530d88f51eb8"
  license "BSD-2-Clause"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/btpd"
    rebuild 1
    sha256 cellar: :any, mojave: "cdd1900a85295f506f062c8d081138a58cbbb93eb7f20e1d248a0c4590a9fabc"
  end

  depends_on "openssl@3"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Torrents can be specified", pipe_output("#{bin}/btcli --help 2>&1")
  end
end
