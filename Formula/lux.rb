class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.14.0.tar.gz"
  sha256 "3d485c9703851f3fb5cdee9b029b5b6855f84bfd29b44cae310a031a6fa8c00f"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lux"
    sha256 cellar: :any_skip_relocation, mojave: "5b0b2a4d352dd0d380033135455941f54506f28ba8d984f6e202d862d75a6824"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
