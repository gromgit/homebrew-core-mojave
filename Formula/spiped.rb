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
    sha256 cellar: :any, mojave: "96719318ceec728915ef628a28bc69f64da1f5066bb32436699bed94892476c2"
  end

  depends_on "bsdmake" => :build
  depends_on "openssl@1.1"

  def install
    man1.mkpath
    system "bsdmake", "BINDIR_DEFAULT=#{bin}", "MAN1DIR=#{man1}", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/spipe -v 2>&1")
  end
end
