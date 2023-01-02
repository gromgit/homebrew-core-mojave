class Direnv < Formula
  desc "Load/unload environment variables based on $PWD"
  homepage "https://direnv.net/"
  url "https://github.com/direnv/direnv/archive/v2.32.2.tar.gz"
  sha256 "352b3a65e8945d13caba92e13e5666e1854d41749aca2e230938ac6c64fa8ef9"
  license "MIT"
  head "https://github.com/direnv/direnv.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/direnv"
    sha256 cellar: :any_skip_relocation, mojave: "e3f066d40c0ac045c4ad25ac2f7007acea642ec93500dc8577744cb8e88e189f"
  end

  depends_on "go" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"direnv", "status"
  end
end
