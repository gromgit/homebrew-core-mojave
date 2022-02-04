class Vivid < Formula
  desc "Generator for LS_COLORS with support for multiple color themes"
  homepage "https://github.com/sharkdp/vivid"
  url "https://github.com/sharkdp/vivid/archive/v0.8.0.tar.gz"
  sha256 "e58e0936db25c81ff257775463f1d422d97c706aec2d0134e39b62151ded23cb"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vivid"
    sha256 cellar: :any_skip_relocation, mojave: "250445cd609a4083bf7657304bbd4e1e7c61f4c65fbd605723fccaf29220af2a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_includes shell_output("#{bin}/vivid preview molokai"), "archives.images: \e[4;38;2;249;38;114m*.bin\e[0m\n"
  end
end
