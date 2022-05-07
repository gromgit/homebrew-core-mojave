class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://github.com/ViRb3/wgcf/archive/v2.2.14.tar.gz"
  sha256 "64b6e62cc9b7ca1b91757ee067e7c6adf923faff64e3daeebbf07ad817ce73aa"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/wgcf"
    sha256 cellar: :any_skip_relocation, mojave: "777f5a53db829d41e8ebad952fd1fb4111f018a5a7993146324ee03d795deb41"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "#{bin}/wgcf", "trace"
  end
end
