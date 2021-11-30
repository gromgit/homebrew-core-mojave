class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.10.tar.gz"
  sha256 "2b7d2b2aedc7084e2d7d4efa104e6e0eb2ab3eb991f693ec9f38cdfb9c95e641"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
