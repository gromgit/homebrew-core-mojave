class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20220128.tgz"
  sha256 "42c1805cc529314e6a76326fe1b33e80c70862a44b01474da362e2f7db2d749c"
  license :public_domain

  livecheck do
    url "https://invisible-mirror.net/archives/byacc/"
    regex(/href=.*?byacc[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/byacc"
    sha256 cellar: :any_skip_relocation, mojave: "9b387471831f716749785b3077fa8a55ff167adccc707c463d9a398a2cf1608f"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
