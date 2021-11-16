class Mupen64plus < Formula
  desc "Cross-platform plugin-based N64 emulator"
  homepage "https://www.mupen64plus.org/"
  url "https://github.com/mupen64plus/mupen64plus-core/releases/download/2.5/mupen64plus-bundle-src-2.5.tar.gz"
  sha256 "9c75b9d826f2d24666175f723a97369b3a6ee159b307f7cc876bbb4facdbba66"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, monterey:    "5199526084ae5a1708b1448c56134710bb50d7b1768441ec137b6ff0ac25a7da"
    sha256 cellar: :any, big_sur:     "5a9a16e37b0274e5c21b44f9b076f5b0b6140ff8017041f2cfb1c33963acfb9c"
    sha256 cellar: :any, catalina:    "999b60faedf8eb2299f854991995c44b81898de85a73ca0568902e5b63641e42"
    sha256 cellar: :any, mojave:      "c88a4d9a47cdcc6b995615d5fd4b061a7046ec72fac75560d79998b7abf60b78"
    sha256 cellar: :any, high_sierra: "4dc531259b558fe987eecd74d87afb70284d36ec4e0c3008de751b820f83e64b"
    sha256 cellar: :any, sierra:      "28006559bb0cc624432b1a8b0a7dfd08e9a5a3d59d7dbaf5cde64ac29dc747d1"
    sha256 cellar: :any, el_capitan:  "6d9d9900813b21abc89149ded185d4b74147a85c1a350d54511ee535acde171c"
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "sdl"

  resource "rom" do
    url "https://github.com/mupen64plus/mupen64plus-rom/raw/76ef14c876ed036284154444c7bdc29d19381acc/m64p_test_rom.v64"
    sha256 "b5fe9d650a67091c97838386f5102ad94c79232240f9c5bcc72334097d76224c"
  end

  def install
    # Prevent different C++ standard library warning
    inreplace Dir["source/mupen64plus-**/projects/unix/Makefile"],
              /(-mmacosx-version-min)=\d+\.\d+/,
              "\\1=#{MacOS.version}"

    # Fix build with Xcode 9 using upstream commit:
    # https://github.com/mupen64plus/mupen64plus-video-glide64mk2/commit/5ac11270
    # Remove in next version
    inreplace "source/mupen64plus-video-glide64mk2/src/Glide64/3dmath.cpp",
              "__builtin_ia32_storeups", "_mm_storeu_ps"

    args = ["install", "PREFIX=#{prefix}", "INSTALL_STRIP_FLAG=-S"]

    cd "source/mupen64plus-core/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-audio-sdl/projects/unix" do
      system "make", *args, "NO_SRC=1", "NO_SPEEX=1"
    end

    cd "source/mupen64plus-input-sdl/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-rsp-hle/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-video-glide64mk2/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-video-rice/projects/unix" do
      system "make", *args
    end

    cd "source/mupen64plus-ui-console/projects/unix" do
      system "make", *args
    end
  end

  test do
    resource("rom").stage do
      system bin/"mupen64plus", "--testshots", "1",
             "m64p_test_rom.v64"
    end
  end
end
