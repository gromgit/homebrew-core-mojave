class Sdl12Compat < Formula
  desc "SDL 1.2 compatibility layer that uses SDL 2.0 behind the scenes"
  homepage "https://github.com/libsdl-org/sdl12-compat"
  url "https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.56.tar.gz"
  sha256 "f62f3e15f95aade366ee6c03f291e8825c4689390a6be681535259a877259c58"
  license all_of: ["Zlib", "MIT-0"]
  head "https://github.com/libsdl-org/sdl12-compat.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdl12-compat"
    sha256 cellar: :any, mojave: "08adecca68129ad11390f7058c083aab412d2757320d3970515c586b2b0aedb6"
  end

  depends_on "cmake" => :build
  depends_on "sdl2"

  conflicts_with "sdl", because: "sdl12-compat is a drop-in replacement for sdl"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DSDL2_PATH=#{Formula["sdl2"].opt_prefix}",
                    "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-rpath,#{Formula["sdl2"].opt_lib}",
                    "-DSDL12DEVEL=ON",
                    "-DSDL12TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (lib/"pkgconfig").install_symlink "sdl12_compat.pc" => "sdl.pc"
  end

  test do
    assert_predicate lib/shared_library("libSDL"), :exist?
    versioned_libsdl = "libSDL-1.2"
    versioned_libsdl << ".0" if OS.mac?
    assert_predicate lib/shared_library(versioned_libsdl), :exist?
    assert_predicate lib/"libSDLmain.a", :exist?
    assert_equal version.to_s, shell_output("#{bin}/sdl-config --version").strip

    (testpath/"test.c").write <<~EOS
      #include <SDL.h>

      int main() {
        SDL_Init(SDL_INIT_EVERYTHING);
        SDL_Quit();
        return 0;
      }
    EOS
    flags = Utils.safe_popen_read(bin/"sdl-config", "--cflags", "--libs").split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
