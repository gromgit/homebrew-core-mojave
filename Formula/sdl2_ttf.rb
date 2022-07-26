class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://github.com/libsdl-org/SDL_ttf"
  url "https://github.com/libsdl-org/SDL_ttf/releases/download/release-2.20.0/SDL2_ttf-2.20.0.tar.gz"
  sha256 "874680232b72839555a558b48d71666b562e280f379e673b6f0c7445ea3b9b8a"
  license "Zlib"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdl2_ttf"
    sha256 cellar: :any, mojave: "4d455ce737c173caf5e7866e13fd4ad7ca060cbf00c2002bf9fb360485c257d8"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "sdl2"

  def install
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    # `--enable-harfbuzz` is the default, but we pass it
    # explicitly to generate an error when it isn't found.
    system "./configure", "--disable-freetype-builtin",
                          "--disable-harfbuzz-builtin",
                          "--enable-harfbuzz",
                          *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_ttf.h>

      int main()
      {
          int success = TTF_Init();
          TTF_Quit();
          return success;
      }
    EOS
    system ENV.cc, "test.c", "-I#{Formula["sdl2"].opt_include}/SDL2", "-L#{lib}", "-lSDL2_ttf", "-o", "test"
    system "./test"
  end
end
