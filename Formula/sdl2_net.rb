class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://github.com/libsdl-org/SDL_net"
  url "https://github.com/libsdl-org/SDL_net/releases/download/release-2.2.0/SDL2_net-2.2.0.tar.gz"
  sha256 "4e4a891988316271974ff4e9585ed1ef729a123d22c08bd473129179dc857feb"
  license "Zlib"

  # NOTE: This should be updated to use the `GithubLatest` strategy if/when the
  # GitHub releases provide downloadable artifacts and the formula uses one as
  # the `stable` URL (like `sdl2_image`, `sdl2_mixer`, etc.).
  livecheck do
    url :head
    regex(/^release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdl2_net"
    rebuild 1
    sha256 cellar: :any, mojave: "725dbfa1e4ac2684ad7e43e5d5907bf4a423e5c65117e50332ee60311a073100"
  end

  head do
    url "https://github.com/libsdl-org/SDL_net.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    inreplace "SDL2_net.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_net.h>

      int main()
      {
          int success = SDLNet_Init();
          SDLNet_Quit();
          return success;
      }
    EOS

    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_net", "-o", "test"
    system "./test"
  end
end
