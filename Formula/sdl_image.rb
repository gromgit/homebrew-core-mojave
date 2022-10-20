class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://github.com/libsdl-org/SDL_image"
  license "Zlib"
  revision 9

  stable do
    url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
    sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"

    # Fix graphical glitching
    # https://github.com/Homebrew/homebrew-python/issues/281
    # https://trac.macports.org/ticket/37453
    patch :p0 do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/41996822/sdl_image/IMG_ImageIO.m.patch"
      sha256 "c43c5defe63b6f459325798e41fe3fdf0a2d32a6f4a57e76a056e752372d7b09"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/sdl_image"
    sha256 cellar: :any, mojave: "b7405efbd6663c24f1b17881ef2d99f71fa2dacf5270e39a7bb8da2755ef870e"
  end

  head do
    url "https://github.com/libsdl-org/SDL_image.git", branch: "SDL-1.2"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  # SDL 1.2 is deprecated, unsupported, and not recommended for new projects.
  # Commented out while this formula still has dependents.
  # deprecate! date: "2013-08-17", because: :deprecated_upstream

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "sdl12-compat"
  depends_on "webp"

  def install
    inreplace "SDL_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-imageio",
                          "--disable-jpg-shared",
                          "--disable-png-shared",
                          "--disable-sdltest",
                          "--disable-tif-shared",
                          "--disable-webp-shared"
    system "make", "install"
  end
end
