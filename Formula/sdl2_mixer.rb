class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.6.0/SDL2_mixer-2.6.0.tar.gz"
  sha256 "f94a4d3e878cb191c386a714be561838240012250fe17d496f4ff4341d59a391"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdl2_mixer"
    sha256 cellar: :any, mojave: "01a29809ef8d2efd568dec72cbe612589cce759419188150dd4d8cf70230929d"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libmodplug"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "sdl2"

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    if build.head?
      mkdir "build"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-flac
      --disable-music-flac-shared
      --disable-music-midi-fluidsynth
      --disable-music-midi-fluidsynth-shared
      --disable-music-mod-mikmod-shared
      --disable-music-mod-modplug-shared
      --disable-music-mp3-mpg123-shared
      --disable-music-ogg-shared
      --enable-music-mod-mikmod
      --enable-music-mod-modplug
      --enable-music-ogg
      --enable-music-mp3-mpg123
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_mixer.h>

      int main()
      {
          int success = Mix_Init(0);
          Mix_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-I#{Formula["sdl2"].opt_include}/SDL2",
           "test.c", "-L#{lib}", "-lSDL2_mixer", "-o", "test"
    system "./test"
  end
end
