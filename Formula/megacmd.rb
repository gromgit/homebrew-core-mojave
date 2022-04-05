class Megacmd < Formula
  desc "Command-line client for mega.co.nz storage service"
  homepage "https://github.com/t3rm1n4l/megacmd"
  url "https://github.com/t3rm1n4l/megacmd/archive/0.016.tar.gz"
  sha256 "def4cda692860c85529c8de9b0bdb8624a30f57d265f7e70994fc212e5da7e40"
  license "MIT"
  head "https://github.com/t3rm1n4l/megacmd.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/megacmd"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "f934cebd142f095b2142b97d2e732a6420876bc86efd9261204416183d0b1396"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"megacmd", "--version"
  end
end
