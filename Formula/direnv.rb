class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.29.0.tar.gz"
  sha256 "a0ceb76a58a6ca81a8669a9ef2631fbad41d7c1a27cc0ec738c71c6d71f9751f"
  license "MIT"
  head "https://github.com/direnv/direnv.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/direnv"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "17475fc5efa8b01bd69406b2c93e7e9ad3099c436390725178a73649872cac27"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
