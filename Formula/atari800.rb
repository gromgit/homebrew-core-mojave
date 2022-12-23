class Atari800 < Formula
  desc "Atari 8-bit machine emulator"
  homepage "https://atari800.github.io/"
  url "https://github.com/atari800/atari800/releases/download/ATARI800_5_0_0/atari800-5.0.0-src.tgz"
  sha256 "eaa2df7b76646f1e49d5e564391707e5a4b56d961810cff6bc7c809bfa774605"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/ATARI800[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/atari800"
    rebuild 1
    sha256 cellar: :any, mojave: "a79f38044a50a8c9736112f8b3ec3b2f9882078510dbf68047ee5e0c9059e622"
  end

  depends_on "libpng"
  depends_on "sdl12-compat"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--disable-riodevice"
    system "make", "install"
  end

  test do
    assert_equal "Atari 800 Emulator, Version #{version}",
                 shell_output("#{bin}/atari800 -v", 3).strip
  end
end
