class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.32.1.tar.gz"
  sha256 "dc7df9a9e253e1124748aa74da94bf2b96f5a61d581c60d52d3f8e8dc86ecfde"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/direnv"
    sha256 cellar: :any_skip_relocation, mojave: "d7c24b7037aebb66b70d535c519ce522c088536fb859e6b210fce805faef065b"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
