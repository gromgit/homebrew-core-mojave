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
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "3802fa7bd3462a0a4cfd47dc08626e23872e93dd47a34acd5917e1e9d0cde1be"
  end

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/di"
  end
end
