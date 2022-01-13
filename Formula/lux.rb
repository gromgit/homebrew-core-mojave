class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/v0.12.0.tar.gz"
  sha256 "f5bcbe1039219a299908fdd5a540052ef603ff5c8c21c0d64f44c53132c41cdd"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lux"
    sha256 cellar: :any_skip_relocation, mojave: "19d72ecea1af42517121cb51feef9cf49d44d384c21084b36223f5f7cd57d9b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://www.bilibili.com/video/av20203945"
  end
end
