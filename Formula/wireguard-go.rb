class WireguardGo < Formula
  desc "Userspace Go implementation of WireGuard"
  homepage "https://www.wireguard.com/"
  url "https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-0.0.20220117.tar.xz"
  sha256 "f4496b6db6c2f99ebbb744738dd6c93ebdbda0571b56cfb857916d20a696fe80"
  license "MIT"
  head "https://git.zx2c4.com/wireguard-go.git", branch: "master"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wireguard-go"
    sha256 cellar: :any_skip_relocation, mojave: "4ab6686c9e8c316ce0476a2533290714cf2384c42b67bb76166d780c4382b3aa"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    prog = "#{bin}/wireguard-go -f notrealutun 2>&1"
    on_macos do
      assert_match "be utun", pipe_output(prog)
    end

    on_linux do
      assert_match "Running wireguard-go is not required because this", pipe_output(prog)
    end
  end
end
