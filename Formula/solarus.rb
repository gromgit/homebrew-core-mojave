class Solarus < Formula
  desc "Action-RPG game engine"
  homepage "https://www.solarus-games.org/"
  url "https://gitlab.com/solarus-games/solarus.git",
      tag:      "v1.6.5",
      revision: "3aec70b0556a8d7aed7903d1a3e4d9a18c5d1649"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/solarus"
    rebuild 1
    sha256 cellar: :any, mojave: "521706fe25d100a1af751adf0caded572bdf2c66142ffe653c132a858fa84c34"
  end

  depends_on "cmake" => :build
  depends_on "glm"
  depends_on "libmodplug"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "luajit-openresty"
  depends_on "physfs"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  on_linux do
    depends_on "gcc"
    depends_on "mesa"
    depends_on "openal-soft"
  end

  fails_with gcc: "5" # needs same GLIBCXX as mesa at runtime

  def install
    ENV.append_to_cflags "-I#{Formula["glm"].opt_include}"
    ENV.append_to_cflags "-I#{Formula["physfs"].opt_include}"
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DSOLARUS_ARCH=#{Hardware::CPU.arch}",
                    "-DSOLARUS_GUI=OFF",
                    "-DSOLARUS_TESTS=OFF",
                    "-DVORBISFILE_INCLUDE_DIR=#{Formula["libvorbis"].opt_include}",
                    "-DOGG_INCLUDE_DIR=#{Formula["libogg"].opt_include}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/solarus-run", "-help"
  end
end
