class Tcpsplit < Formula
  desc "Break a packet trace into some number of sub-traces"
  homepage "https://www.icir.org/mallman/software/tcpsplit/"
  url "https://www.icir.org/mallman/software/tcpsplit/tcpsplit-0.2.tar.gz"
  sha256 "885a6609d04eb35f31f1c6f06a0b9afd88776d85dec0caa33a86cef3f3c09d1d"

  livecheck do
    url :homepage
    regex(/href=.*?tcpsplit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tcpsplit"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "eeff74f0d03242916801c415a47df8c20ce5778ed9ca0fd4b93981a8231a6e37"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    bin.install "tcpsplit"
  end

  test do
    system "#{bin}/tcpsplit", "--version"
  end
end
