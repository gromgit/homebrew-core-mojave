class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.12.tar.gz"
  sha256 "6945b032b9376f10167c6602f0ae3767f301b9b200c1aa6d543a874d91afbbc0"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wgcf"
    sha256 cellar: :any_skip_relocation, mojave: "be0fb8049687dee0af20122fc3863dc2f38cc1924e46a6af34b4629b81ffd579"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
