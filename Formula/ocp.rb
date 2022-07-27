class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.99.tar.xz"
  sha256 "d00165e206403b876b18edfc264abc8b6ce3d772be7e784fe4d358e37e57affd"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ocp"
    rebuild 1
    sha256 mojave: "24e986b7884065ccbd3fe38f74e75a2ee00a4d0a83508a9cd92fbc8bfafb53d3"
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_catalina :or_newer do
    depends_on "sdl2"
  end

  on_system :linux, macos: :mojave_or_older do
    depends_on "sdl"
  end

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-14.0.02/unifont-14.0.02.tar.gz"
    sha256 "401bb9c3741372c1316fec87c392887037e9e828fae64fd7bee2775bbe4545f7"
  end

  def install
    ENV.deparallelize

    # Required for SDL2
    resource("unifont").stage do |r|
      cd "font/precompiled" do
        share.install "unifont-#{r.version}.ttf" => "unifont.ttf"
        share.install "unifont_csur-#{r.version}.ttf" => "unifont_csur.ttf"
        share.install "unifont_upper-#{r.version}.ttf" => "unifont_upper.ttf"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-desktop_file_install
      --with-unifontdir=#{share}
    ]

    args << if MacOS.version < :catalina
      "--without-sdl2"
    else
      "--without-sdl"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
