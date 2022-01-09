class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.30.3.tar.gz"
  sha256 "7fb5431b98d57fb8c70218b4a0fab4b08f102790e7a92486f588bf3d5751ac3b"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/direnv"
    sha256 cellar: :any_skip_relocation, mojave: "7df773073a9a1953aeb756216aa9cc562f6168e7b909c68876eba28ff0af51eb"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
