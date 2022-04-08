class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20220316.tar.xz"
  sha256 "fd6759c116e358d311309e049cc2dcc390bc326710f5fc175e0217b755330c2a"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wireguard-go"
    sha256 cellar: :any_skip_relocation, mojave: "6648fe00bc9dfa18807d8b921ee1024be2030611d92d6bd5580d099277db5f87"
  end

  depends_on "go" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    prog = "#{bin}/wireguard-go -f notrealutun 2>&1"
    if OS.mac?
      assert_match "be utun", pipe_output(prog)
    else

      assert_match "Running wireguard-go is not required because this", pipe_output(prog)
    end
  end
end
