class Miniupnpc < Formula
  desc "UPnP IGD client library and daemon"
  homepage "https://miniupnp.tuxfamily.org"
  url "https://miniupnp.tuxfamily.org/files/download.php?file=miniupnpc-2.2.4.tar.gz"
  sha256 "481a5e4aede64e9ef29895b218836c3608d973e77a35b4f228ab1f3629412c4b"
  license "BSD-3-Clause"

  # We only match versions with only a major/minor since versions like 2.1 are
  # stable and versions like 2.1.20191224 are unstable/development releases.
  livecheck do
    url "https://miniupnp.tuxfamily.org/files/"
    regex(/href=.*?miniupnpc[._-]v?(\d+\.\d+(?>.\d{1,7})*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/miniupnpc"
    sha256 cellar: :any, mojave: "dea8da1586630e18fda7de8c77080e125d83804cfa06e18109c227d51cf33c2e"
  end

  def install
    system "make", "INSTALLPREFIX=#{prefix}", "install"
  end

  test do
    output = shell_output("#{bin}/upnpc --help 2>&1", 1)
    assert_match version.to_s, output
  end
end
