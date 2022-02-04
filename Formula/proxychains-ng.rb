class ProxychainsNg < Formula
  desc "Hook preloader"
  homepage "https://sourceforge.net/projects/proxychains-ng/"
  url "https://github.com/rofl0r/proxychains-ng/archive/v4.16.tar.gz"
  sha256 "5f66908044cc0c504f4a7e618ae390c9a78d108d3f713d7839e440693f43b5e7"
  license "GPL-2.0-or-later"
  head "https://github.com/rofl0r/proxychains-ng.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/proxychains-ng"
    sha256 mojave: "45ab6e6ea80284908734c6a99be9438a6d32875141ebbecb57f72fa3822fd90f"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make"
    system "make", "install"
    system "make", "install-config"
  end

  test do
    assert_match "config file found", shell_output("#{bin}/proxychains4 test 2>&1", 1)
  end
end
