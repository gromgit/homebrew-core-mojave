class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.13.tar.gz"
  sha256 "bb26d29dfbb673dd46a5027b5f07e0329e108507c3394a69e45ccf57ce45c9fb"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wgcf"
    sha256 cellar: :any_skip_relocation, mojave: "57a0567e4d969ef28f975feab8cb52cc7088a753de104f40bd03647295f982e5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
