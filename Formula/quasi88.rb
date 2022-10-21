class Quasi88 < Formula
  desc "PC-8801 emulator"
  homepage "https://www.eonet.ne.jp/~showtime/quasi88/"
  url "https://www.eonet.ne.jp/~showtime/quasi88/release/quasi88-0.6.4.tgz"
  sha256 "2c4329f9f77e02a1e1f23c941be07fbe6e4a32353b5d012531f53b06996881ff"
  revision 1

  livecheck do
    url "https://www.eonet.ne.jp/~showtime/quasi88/download.html"
    regex(/href=.*?quasi88[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/quasi88"
    sha256 cellar: :any, mojave: "9957b7c1b71662c2858219da0974c486c7c95af0ce9255691f6c322b25d6091f"
  end

  depends_on "sdl12-compat"

  def install
    args = %W[
      X11_VERSION=
      SDL_VERSION=1
      ARCH=macosx
      SOUND_SDL=1
      LD=#{ENV.cxx}
      CXX=#{ENV.cxx}
      CXXLIBS=
    ]
    system "make", *args
    bin.install "quasi88.sdl" => "quasi88"
  end

  def caveats
    <<~EOS
      You will need to place ROM and disk files.
      Default arguments for the directories are:
        -romdir ~/quasi88/rom/
        -diskdir ~/quasi88/disk/
        -tapedir ~/quasi88/tape/
    EOS
  end

  test do
    system "#{bin}/quasi88", "-help"
  end
end
