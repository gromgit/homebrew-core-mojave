class Tth < Formula
  desc "TeX/LaTeX to HTML converter"
  homepage "http://hutchinson.belmont.ma.us/tth/"
  url "http://hutchinson.belmont.ma.us/tth/tth_distribution/tth_4.16.tgz"
  sha256 "ff8b88c6dbb938f01fe6a224c396fc302ae5d89b9b6d97f207f7ae0c4e7f0a32"

  livecheck do
    url "http://hutchinson.belmont.ma.us/tth/Version"
    regex(/"v?(\d+(?:\.\d+)+)"/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/tth"
    sha256 cellar: :any_skip_relocation, mojave: "deaf6032ed49ddd5d783095332dc729df16d9bbc8b1905a0fc8fc2f26096b2c6"
  end

  def install
    system ENV.cc, "-o", "tth", "tth.c"
    bin.install %w[tth latex2gif ps2gif ps2png]
    man1.install "tth.1"
  end

  test do
    assert_match(/version #{version}/, pipe_output("#{bin}/tth", ""))
  end
end
