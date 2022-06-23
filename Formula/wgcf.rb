class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.15.tar.gz"
  sha256 "b12971018c40d0a04492a9da9e9fea393394291044045e0117ec292364de1b57"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wgcf"
    sha256 cellar: :any_skip_relocation, mojave: "a8832e8f941d33255717be52f53556e9f578a019c17706b9217b32daebb51996"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
