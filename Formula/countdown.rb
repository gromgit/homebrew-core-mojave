class Countdown < Formula
  desc "Terminal countdown timer"
  homepage "https://github.com/antonmedv/countdown"
  url "https://github.com/antonmedv/countdown/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "51fe9d52c125b112922d5d12a0816ee115f8a8c314455b6b051f33e0c7e27fe1"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/countdown"
    sha256 cellar: :any_skip_relocation, mojave: "8e7299c4a35cba9ad3bd2cc132571e5fdbc5fbd9260ea048226dd037b8171d4b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    pipe_output bin/"countdown", "0m0s"
  end
end
