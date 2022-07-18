class Meek < Formula
  desc "Blocking-resistant pluggable transport for Tor"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/meek.git/snapshot/meek-0.37.0.tar.gz"
  sha256 "f5650e26638f94954d0b89892ac0f4241cfeb55c17f555ee890609544ea85474"
  license "CC0-1.0"
  revision 2
  head "https://git.torproject.org/pluggable-transports/meek.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/meek"
    sha256 cellar: :any_skip_relocation, mojave: "60373967ef2f5a6d69dcec0d9f2f13457e14baf831c441955c090d0261591676"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"meek-client"), "./meek-client"
    system "go", "build", *std_go_args(output: bin/"meek-server"), "./meek-server"
    man1.install "doc/meek-client.1"
    man1.install "doc/meek-server.1"
  end

  test do
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/meek-client 2>/dev/null", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/meek-server 2>/dev/null", 1)
  end
end
