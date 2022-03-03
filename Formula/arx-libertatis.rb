class ArxLibertatis < Formula
  desc "Cross-platform, open source port of Arx Fatalis"
  homepage "https://arx-libertatis.org/"
  url "https://arx-libertatis.org/files/arx-libertatis-1.2/arx-libertatis-1.2.tar.xz"
  sha256 "bacf7768c4e21c9166c7ea57083d4f20db0deb8f0ee7d96b5f2829e73a75ad0c"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://arx-libertatis.org/files/"
    regex(%r{href=["']?arx-libertatis[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arx-libertatis"
    sha256 mojave: "7be6387b0c8a3f1f6845fc6814a4029fb7d41f83c2b655c6c3e4398e5bf4468e"
  end

  head do
    url "https://github.com/arx/ArxLibertatis.git"

    resource "arx-libertatis-data" do
      url "https://github.com/arx/ArxLibertatisData.git"
    end
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "glm" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "innoextract"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openal-soft"
  end

  conflicts_with "rnv", because: "both install `arx` binaries"

  def install
    args = std_cmake_args

    # Install prebuilt icons to avoid inkscape and imagemagick deps
    if build.head?
      (buildpath/"arx-libertatis-data").install resource("arx-libertatis-data")
      args << "-DDATA_FILES=#{buildpath}/arx-libertatis-data"
    end

    mkdir "build" do
      system "cmake", "..", *args,
                            "-DBUILD_CRASHREPORTER=OFF",
                            "-DSTRICT_USE=ON",
                            "-DWITH_OPENGL=glew",
                            "-DWITH_SDL=2"
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      This package only contains the Arx Libertatis binary, not the game data.
      To play Arx Fatalis you will need to obtain the game from GOG.com and
      install the game data with:

        arx-install-data /path/to/setup_arx_fatalis.exe
    EOS
  end

  test do
    system "#{bin}/arx", "-h"
  end
end
