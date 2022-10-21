class SdlTtf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/release-1.2.html"
  revision 2

  stable do
    url "https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
    sha256 "724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7"

    # Fix broken TTF_RenderGlyph_Shaded()
    # https://bugzilla.libsdl.org/show_bug.cgi?id=1433
    patch do
      url "https://gist.githubusercontent.com/tomyun/a8d2193b6e18218217c4/raw/8292c48e751c6a9939db89553d01445d801420dd/sdl_ttf-fix-1433.diff"
      sha256 "4c2e38bb764a23bc48ae917b3abf60afa0dc67f8700e7682901bf9b03c15be5f"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdl_ttf"
    sha256 cellar: :any, mojave: "08c7d7caeb1d476ad2016d45355605b6a556b67110dbce516e441fd09db58625"
  end

  head do
    url "https://github.com/libsdl-org/SDL_ttf.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  # Commented out while this formula still has dependents.
  # deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "sdl12-compat"

  def install
    ENV.append "LDFLAGS", "-liconv" if OS.mac?
    inreplace "SDL_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args, "--disable-sdltest"
    system "make", "install"
  end
end
