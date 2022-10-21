class Nxengine < Formula
  desc "Rewrite of Cave Story (Doukutsu Monogatari)"
  homepage "https://nxengine.sourceforge.io/"
  url "https://nxengine.sourceforge.io/dl/nx-src-1006.tar.bz2"
  version "1.0.0.6"
  sha256 "cf9cbf15dfdfdc9936720a714876bb1524afbd2931e3eaa4c89984a40b21ad68"
  license "GPL-3.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/nxengine"
    sha256 cellar: :any, mojave: "66e16d690524bb03c7f21e8a53a157dc466d47e7e1aa1ebf1397f79aede31e55"
  end

  depends_on "sdl12-compat"
  depends_on "sdl_ttf"

  # Freeware Cave Story 1.0.0.6 pre-patched with Aeon Genesis English translation
  resource "game" do
    url "https://www.cavestory.org/downloads/cavestoryen.zip"
    sha256 "aa87fa30bee9b4980640c7e104791354e0f1f6411ee0d45a70af70046aa0685f"
  end

  def install
    # Remove unused linux header
    inreplace "platform/Linux/vbesync.c", "#include <libdrm\/drm\.h>", ""
    # Replacement of htole16 for OS X
    inreplace ["sound/org.cpp", "sound/pxt.cpp"] do |s|
      s.gsub! "endian.h", "libkern/OSByteOrder.h"
      s.gsub! "htole16", "OSSwapHostToLittleInt16"
    end
    # Use var/nxengine for extracted data files, without messing current directory
    inreplace "graphics/font.cpp",
              /(fontfile) = "(\w+\.(bmp|ttf))"/,
              "\\1 = \"#{var}/nxengine/\\2\""
    inreplace "platform.cpp",
              /(return .*fopen)\((fname), mode\);/,
              "char fn[256]; strcpy(fn, \"#{var}/nxengine/\"); strcat(fn, \\2); \\1(fn, mode);"
    inreplace "graphics/nxsurface.cpp",
              /(image = SDL_LoadBMP)\((pbm_name)\);/,
              "char fn[256]; strcpy(fn, \"#{var}/nxengine/\"); strcat(fn, \\2); \\1(fn);"
    inreplace "extract/extractpxt.cpp",
              /(mkdir)\((".+")/,
              "char dir[256]; strcpy(dir, \"#{var}/nxengine/\"); strcat(dir, \\2); \\1(dir"
    inreplace "extract/extractfiles.cpp" do |s|
      s.gsub!(/char \*dir = strdup\((fname)\);/,
             "char *dir = (char *)malloc(256); strcpy(dir, \"#{var}/nxengine/\"); strcat(dir, \\1);")
      s.gsub! "strchr", "strrchr"
    end

    system "make"
    bin.install "nx"
    pkgshare.install ["smalfont.bmp", "sprites.sif", "tilekey.dat"]
    resource("game").stage do
      pkgshare.install ["Doukutsu.exe", "data"]
    end
  end

  def post_install
    # Symlink original game data to a working directory in var
    (var/"nxengine").mkpath
    ln_sf Dir[pkgshare/"*"], "#{var}/nxengine/"
    # Use system font, avoiding any license issue
    ln_sf "/Library/Fonts/Courier New.ttf", "#{var}/nxengine/font.ttf"
  end

  def caveats
    <<~EOS
      When the game runs first time, it will extract data files into the following directory:
        #{var}/nxengine
    EOS
  end
end
