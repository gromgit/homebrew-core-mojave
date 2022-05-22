class Spiped < Formula
  desc "Secure pipe daemon"
  homepage "https://www.tarsnap.com/spiped.html"
  url "https://www.tarsnap.com/spiped/spiped-1.6.2.tgz"
  sha256 "05d4687d12d11d7f9888d43f3d80c541b7721c987038d085f71c91bb06204567"

  livecheck do
    url :homepage
    regex(/href=.*?spiped[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/spiped"
    rebuild 1
    sha256 cellar: :any, mojave: "6311843c28307ca8e3e02bc2dc051a2f80c72f6b1e031e9bb74888c0bcdb5a37"
  end

  depends_on "openssl@1.1"

  on_macos do
    depends_on "bsdmake" => :build
  end

  def install
    man1.mkpath
    make = OS.mac? ? "bsdmake" : "make"
    system make, "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
