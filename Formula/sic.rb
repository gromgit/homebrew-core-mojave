class Sic < Formula
  desc "Minimal multiplexing IRC client"
  homepage "https://tools.suckless.org/sic/"
  url "https://dl.suckless.org/tools/sic-1.3.tar.gz"
  sha256 "30478fab3ebc75f2eb5d08cbb5b2fedcaf489116e75a2dd7197e3e9c733d65d2"
  license "MIT"
  head "https://git.suckless.org/sic", branch: "master", using: :git

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?sic[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sic"
    sha256 cellar: :any_skip_relocation, mojave: "89373db152631c65f7cf4b00596028e55031bd74ce1aa956bb06361cf2623340"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end
end
