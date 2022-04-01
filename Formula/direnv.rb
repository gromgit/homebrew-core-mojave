class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.31.0.tar.gz"
  sha256 "f82694202f584d281a166bd5b7e877565f96a94807af96325c8f43643d76cb44"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/direnv"
    sha256 cellar: :any_skip_relocation, mojave: "72c49f1e9bb7f41727aa2815ff01e209d82d3bc8e7001e64bd3598564b78752b"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
