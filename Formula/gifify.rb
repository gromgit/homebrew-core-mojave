class Gifify < Formula
  desc "Turn movies into GIFs"
  homepage "https://github.com/jclem/gifify"
  url "https://github.com/jclem/gifify/archive/v4.0.tar.gz"
  sha256 "4cb967e8d0ba897bc91a60006e34299687f388dd47e05fd534f2eff8379fe479"
  license "MIT"
  head "https://github.com/jclem/gifify.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gifify"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "44c8f98b6187c88f2126c0d59d46d2a952866111c3667e3cba3711f42b1d18d8"
  end

  depends_on "ffmpeg"
  depends_on "imagemagick"

  uses_from_macos "bc"

  def install
    bin.install "gifify.sh" => "gifify"
  end

  test do
    system "ffmpeg", "-f", "lavfi", "-i", "testsrc", "-t", "1", "-c:v", "libx264", "test.m4v"
    system "#{bin}/gifify", "test.m4v"
  end
end
