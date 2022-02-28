class LeafProxy < Formula
  desc "Lightweight and fast proxy utility"
  homepage "https://github.com/eycorsican/leaf"
  url "https://github.com/eycorsican/leaf/archive/v0.4.2.tar.gz"
  sha256 "7d0e25964f069db14b0d49f83ccb11795d09011162f08050c211cb2320acc325"
  license "Apache-2.0"
  head "https://github.com/eycorsican/leaf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/leaf-proxy"
    sha256 cellar: :any_skip_relocation, mojave: "ff952c71958c3330a6ce2b512883ab963972c3931cea10c64bb5239391701124"
  end

  depends_on "rust" => :build

  conflicts_with "leaf", because: "both install a `leaf` binary"

  resource "lwip" do
    url "https://github.com/eycorsican/lwip-leaf.git",
        revision: "86632e2747c926a75d32be8bd9af059aa38ae75e"
  end

  def install
    (buildpath/"leaf/src/proxy/tun/netstack/lwip").install resource("lwip")

    cd "leaf-bin" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"config.conf").write <<~EOS
      [General]
      dns-server = 8.8.8.8

      [Proxy]
      SS = ss, 127.0.0.1, #{free_port}, encrypt-method=chacha20-ietf-poly1305, password=123456
    EOS
    output = shell_output "#{bin}/leaf -c #{testpath}/config.conf -t SS"

    assert_match "dispatch to outbound SS failed", output
  end
end
