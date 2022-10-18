class Abuse < Formula
  desc "Dark 2D side-scrolling platform game"
  homepage "http://abuse.zoy.org/"
  url "http://abuse.zoy.org/raw-attachment/wiki/download/abuse-0.8.tar.gz"
  sha256 "0104db5fd2695c9518583783f7aaa7e5c0355e27c5a803840a05aef97f9d3488"
  license all_of: [:public_domain, "GPL-2.0-or-later", "WTFPL"]
  revision 1
  head "svn://svn.zoy.org/abuse/abuse/trunk"

  livecheck do
    url "http://abuse.zoy.org/wiki/download"
    regex(/href=.*?abuse[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/abuse"
    sha256 cellar: :any, mojave: "0be9add7a4d7d0ae526a9cb89635652f97e2c56ab9aad39cccddaadca00c656c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libvorbis"
  depends_on "sdl12-compat"
  depends_on "sdl_mixer"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def startup_script
    <<~EOS
      #!/bin/bash
      #{libexec}/abuse-bin -datadir "#{pkgshare}" "$@"
    EOS
  end

  def install
    # Hack to work with newer versions of automake
    inreplace "bootstrap", "11 10 9 8 7 6 5", '$(seq -s " " 5 99)'

    # Add SDL.m4 to aclocal includes
    inreplace "bootstrap",
      "aclocal${amvers} ${aclocalflags}",
      "aclocal${amvers} ${aclocalflags} -I#{HOMEBREW_PREFIX}/share/aclocal"

    # undefined
    inreplace "src/net/fileman.cpp", "ushort", "unsigned short"
    inreplace "src/sdlport/setup.cpp", "UInt8", "uint8_t"

    # Fix autotools obsoletion notice
    inreplace "configure.ac", "AM_CONFIG_HEADER", "AC_CONFIG_HEADERS"

    # Re-enable OpenGL detection
    inreplace "configure.ac",
      "#error\t/* Error so the compile fails on OSX */",
      "#include <OpenGL/gl.h>"

    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--with-assetdir=#{pkgshare}",
                          "--with-sdl-prefix=#{Formula["sdl12-compat"].opt_prefix}"

    if OS.mac?
      # Use Framework OpenGL, not libGl
      %w[. src src/imlib src/lisp src/net src/sdlport].each do |p|
        inreplace "#{p}/Makefile", "-lGL", "-framework OpenGL"
      end
    end

    system "make"

    bin.install "src/abuse-tool"
    libexec.install "src/abuse" => "abuse-bin"
    pkgshare.install Dir["data/*"] - %w[data/Makefile data/Makefile.am data/Makefile.in]
    # Use a startup script to find the game data
    (bin/"abuse").write startup_script
  end

  def caveats
    <<~EOS
      Game settings and saves will be written to the ~/.abuse folder.
    EOS
  end

  test do
    # Fails in Linux CI with "Unable to initialise SDL : No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "#{bin}/abuse", "--help"
  end
end
