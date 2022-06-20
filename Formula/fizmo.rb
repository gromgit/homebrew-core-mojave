class Fizmo < Formula
  desc "Z-Machine interpreter"
  homepage "https://fizmo.spellbreaker.org"
  url "https://fizmo.spellbreaker.org/source/fizmo-0.8.5.tar.gz"
  sha256 "1c259a29b21c9f401c12fc24d555aca4f4ff171873be56fb44c0c9402c61beaa"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url "https://fizmo.spellbreaker.org/download/"
    regex(%r{href=.*?/fizmo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fizmo"
    sha256 mojave: "566b3940f0746d7e553210a8913c4d49e184a3eecd94500eeae01f8e9da2cf25"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libsndfile"
  depends_on "libx11"
  depends_on "sdl2"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/fizmo-console", "--help"
    # Unable to test headless ncursew client
    # https://github.com/Homebrew/homebrew-games/pull/366
    # system "#{bin}/fizmo-ncursesw", "--help"
    system "#{bin}/fizmo-sdl2", "--help"
  end
end
