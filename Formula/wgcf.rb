class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.10.tar.gz"
  sha256 "2b7d2b2aedc7084e2d7d4efa104e6e0eb2ab3eb991f693ec9f38cdfb9c95e641"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wgcf"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "fbc931ac47be6437298d2c60240b57e244e3a6ab8d0848c9e7180c423382705d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
