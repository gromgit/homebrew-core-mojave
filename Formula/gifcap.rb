class Gifcap < Formula
  desc "Capture video from an Android device and make a gif"
  homepage "https://github.com/outlook/gifcap"
  url "https://github.com/outlook/gifcap/archive/1.0.4.tar.gz"
  sha256 "32747a6cf77f7ea99380752ba35ecd929bb185167e5908cf910d2a92f05029ad"
  license "MIT"
  head "https://github.com/outlook/gifcap.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gifcap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f25f60b65c687a399b360d7a44fd439ec12177a86fcd3b3d77fe8b77dc95ba26"
  end

  depends_on "ffmpeg"

  def install
    bin.install "gifcap"
  end

  test do
    assert_match(/^usage: gifcap/, shell_output("#{bin}/gifcap --help").strip)
  end
end
