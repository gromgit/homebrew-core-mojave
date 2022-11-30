class Netmask < Formula
  desc "IP address netmask generation utility"
  homepage "https://github.com/tlby/netmask/blob/master/README"
  url "https://github.com/tlby/netmask/archive/refs/tags/v2.4.4.tar.gz"
  sha256 "7e4801029a1db868cfb98661bcfdf2152e49d436d41f8748f124d1f4a3409d83"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/netmask"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "038a077363a2084e99dc66366e3e257a07b58e542c4af18af69100f93cfb7940"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    system "./autogen"
    system "./configure"
    system "make"
    bin.install "netmask"
  end

  test do
    assert_equal "100.64.0.0/10", shell_output("#{bin}/netmask -c 100.64.0.0:100.127.255.255").strip
  end
end
