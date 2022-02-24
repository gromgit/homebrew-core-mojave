class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.13.0.tar.gz"
  sha256 "4fe99247a718dc1038cb6b9b1808c8e836bbf6a8464afefddf4bf8a161b08236"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lux"
    sha256 cellar: :any_skip_relocation, mojave: "3e6622b2333f6d343fac11430f65e4d73630ce72c4c67351d9ae35c059097e81"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
