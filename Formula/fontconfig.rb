class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.1.tar.xz"
  sha256 "298e883f6e11d2c5e6d53c8a8394de58d563902cfab934e6be12fb5a5f361ef0"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?fontconfig[._-]v?(\d+\.\d+\.(?:\d|[0-8]\d+))\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fontconfig"
    sha256 cellar: :any_skip_relocation, mojave: "f459d9608aaa9472d0c4dad1de01695efb2e120486a64469ff518abf9700912f"
  end

  head do
    url "https://gitlab.freedesktop.org/fontconfig/fontconfig.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "gettext" => :build
    depends_on "json-c" => :build
    depends_on "util-linux"
  end

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max if MacOS.version >= :sierra

    system "autoreconf", "-iv" if build.head?
    ENV["UUID_CFLAGS"] = "-I#{Formula["util-linux"].include}" if OS.linux?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-docs",
                          "--enable-static",
                          "--with-add-fonts=#{font_dirs.join(",")}",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system "#{bin}/fc-cache", "-frv"
  end

  test do
    system "#{bin}/fc-list"
  end
end
