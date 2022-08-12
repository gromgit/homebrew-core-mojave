class Frotz < Formula
  desc "Infocom-style interactive fiction player"
  homepage "https://661.org/proj/if/frotz/"
  url "https://gitlab.com/DavidGriffith/frotz/-/archive/2.54/frotz-2.54.tar.bz2"
  sha256 "bdf9131e6de49108c9f032200cea3cb4011e5ca0c9fbdbf5b0c05f7c56c81395"
  license "GPL-2.0-or-later"
  revision 1
  head "https://gitlab.com/DavidGriffith/frotz.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frotz"
    sha256 mojave: "54da27192a7979ff3d6a189d102b287d3cc781083af69d4874e7a72243dc67c1"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libao"
  depends_on "libmodplug"
  depends_on "libpng"
  depends_on "libsamplerate"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "ncurses"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  uses_from_macos "zlib"

  resource("testdata") do
    url "https://gitlab.com/DavidGriffith/frotz/-/raw/2.53/src/test/etude/etude.z5"
    sha256 "bfa2ef69f2f5ce3796b96f9b073676902e971aedb3ba690b8835bb1fb0daface"
  end

  def install
    args = %W[PREFIX=#{prefix} MANDIR=#{man} SYSCONFDIR=#{etc} ITALIC=]
    targets = %w[frotz dumb sdl]
    targets.each do |target|
      system "make", target, *args
    end
    ENV.deparallelize # install has race condition
    targets.each do |target|
      system "make", "install_#{target}", *args
    end
  end

  test do
    resource("testdata").stage do
      assert_match "TerpEtude", pipe_output("#{bin}/dfrotz etude.z5", ".")
    end
    assert_match "FROTZ", shell_output("#{bin}/frotz -v").strip
    assert_match "FROTZ", shell_output("#{bin}/sfrotz -v").strip
  end
end
