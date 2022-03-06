class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.51/gource-0.51.tar.gz"
  sha256 "19a3f888b1825aa7ed46f52cebce5012e3c62439e3d281102f21814c7a58e79a"
  license "GPL-3.0-or-later"
  revision 2

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gource"
    rebuild 1
    sha256 mojave: "b18f97623d622baba2082e7c76b2dd5427f59d234322aa5b0b13bb2a05036876"
  end

  head do
    url "https://github.com/acaudwell/Gource.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "#{bin}/gource", "--help"
  end
end
