class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://vpn-kill-switch.com"
  url "https://github.com/vpn-kill-switch/killswitch/archive/v0.7.2.tar.gz"
  sha256 "21b5f755fd5f23f9785bab6815f83056b0291ea9200706debd490a69aa565558"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/killswitch"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "94a3d670c97b8d1c76f8af76baf808c75e7b5db47133f6a30025ce6e82c941fb"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on :macos

  def install
    system "go", "build", "-mod=readonly", "-ldflags", "-s -w -X main.version=#{version}",
           "-o", "#{bin}/killswitch", "cmd/killswitch/main.go"
  end

  test do
    assert_match "No VPN interface found", shell_output("#{bin}/killswitch 2>&1", 1)
  end
end
