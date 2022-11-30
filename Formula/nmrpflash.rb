class Nmrpflash < Formula
  desc "Netgear Unbrick Utility"
  homepage "https://github.com/jclehner/nmrpflash"
  url "https://github.com/jclehner/nmrpflash/archive/refs/tags/v0.9.19.tar.gz"
  sha256 "cb0757d4d38b5061d8a71ccb853f117675d3de3ec4aaa4e9179f614bbbfac31d"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nmrpflash"
    sha256 cellar: :any_skip_relocation, mojave: "fd80d53c1808f22274ac5b388cd8400eaa8018f9f614fa476f3dd312bf72384a"
  end

  uses_from_macos "libpcap"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libnl"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "VERSION=#{version}"
  end

  test do
    system bin/"nmrpflash", "-L"
  end
end
