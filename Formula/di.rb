class Di < Formula
  desc "Advanced df-like disk information utility"
  homepage "https://gentoo.com/di/"
  url "https://downloads.sourceforge.net/project/diskinfo-di/di-4.51.tar.gz"
  sha256 "79b2129c4aff27428695441175940a1717fa0fe2ec2f46d1b886ebb4921461bb"
  license "Zlib"

  livecheck do
    url :stable
    regex(%r{url=.*?/di[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/di"
    rebuild 4
    sha256 cellar: :any_skip_relocation, mojave: "5a2d45e8a00fca27121ca7faa622f25309a721eba5635f82acd01f4df89bfe38"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
