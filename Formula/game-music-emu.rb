class GameMusicEmu < Formula
  desc "Videogame music file emulator collection"
  homepage "https://bitbucket.org/mpyne/game-music-emu"
  url "https://bitbucket.org/mpyne/game-music-emu/downloads/game-music-emu-0.6.3.tar.xz"
  sha256 "aba34e53ef0ec6a34b58b84e28bf8cfbccee6585cebca25333604c35db3e051d"
  license one_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2
  head "https://bitbucket.org/mpyne/game-music-emu.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/game-music-emu"
    rebuild 1
    sha256 cellar: :any, mojave: "0e12ce5afc217f5a6f082e94b914a6599ceb3eaf37fd94bb9eb266553b5456f7"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_UBSAN=OFF"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gme/gme.h>
      int main(void)
      {
        Music_Emu* emu;
        gme_err_t error;

        error = gme_open_data((void*)0, 0, &emu, 44100);

        if (error == gme_wrong_file_type) {
          return 0;
        } else {
          return -1;
        }
      }
    EOS

    if OS.mac?
      ubsan_libdir = Dir["#{MacOS::CLT::PKG_PATH}/usr/lib/clang/*/lib/darwin"].first
      rpath = "-Wl,-rpath,#{ubsan_libdir}"
    end

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", *(rpath if OS.mac?),
                   "-lgme", "-o", "test", *ENV.cflags.to_s.split
    system "./test"
  end
end
