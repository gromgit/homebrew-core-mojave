class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.32.0.tar.gz"
  sha256 "d9bd6a78b57257306b45a64473d3302b0f274a3d2499e870d29f7a22a730f11c"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/direnv"
    sha256 cellar: :any_skip_relocation, mojave: "da15e015da75384e3f72ddf61d467c522a02e6f752cb7d0284aeaed4653bde4c"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
