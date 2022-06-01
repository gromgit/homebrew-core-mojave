class Ddcctl < Formula
  desc "DDC monitor controls (brightness) for Mac OSX command-line"
  homepage "https://github.com/kfix/ddcctl"
  url "https://github.com/kfix/ddcctl/archive/refs/tags/v1.tar.gz"
  sha256 "1b6eddd0bc20594d55d58832f2d2419ee899e74ffc79c389dcdac55617aebb90"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ddcctl"
    sha256 cellar: :any_skip_relocation, mojave: "a735acd6dec0b3a861e30ee973f0f62cc4f8f2a5d4d5c22c3efafaaeffefcadb"
  end

  depends_on :macos

  def install
    bin.mkpath
    system "make", "install", "INSTALL_DIR=#{bin}"
  end

  test do
    output = shell_output("#{bin}/ddcctl -d 100 -b 100", 1)
    assert_match(/found \d external display/, output)
  end
end
