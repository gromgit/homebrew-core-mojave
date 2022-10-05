class Onscripter < Formula
  desc "NScripter-compatible visual novel engine"
  homepage "https://onscripter.osdn.jp/onscripter.html"
  url "https://onscripter.osdn.jp/onscripter-20220816.tar.gz"
  sha256 "e2bea400a51777e91a10e6a30e2bb4060e30fe7eb1d293c659b4a9668742d5d5"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?onscripter[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/onscripter"
    sha256 cellar: :any, mojave: "ed8fde161936a9c522400ec99bc931d9e372284380ae8edc3b3ee8eb75a930bc"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "lua"
  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "sdl_ttf"
  depends_on "smpeg"

  def install
    # Configuration is done through editing of Makefiles.
    # Comment out optional libavifile dependency on Linux as it is old and unmaintained.
    inreplace "Makefile.Linux" do |s|
      s.gsub!("DEFS += -DUSE_AVIFILE", "#DEFS += -DUSE_AVIFILE")
      s.gsub!("INCS += `avifile-config --cflags`", "#INCS += `avifile-config --cflags`")
      s.gsub!("LIBS += `avifile-config --libs`", "#LIBS += `avifile-config --libs`")
      s.gsub!("TARGET += simple_aviplay$(EXESUFFIX)", "#TARGET += simple_aviplay$(EXESUFFIX)")
      s.gsub!("EXT_OBJS += AVIWrapper$(OBJSUFFIX)", "#EXT_OBJS += AVIWrapper$(OBJSUFFIX)")
    end

    incs = [
      `pkg-config --cflags sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --cflags`.chomp,
      "-I#{Formula["jpeg-turbo"].include}",
      "-I#{Formula["lua"].opt_include}/lua",
    ]

    libs = [
      `pkg-config --libs sdl SDL_ttf SDL_image SDL_mixer`.chomp,
      `smpeg-config --libs`.chomp,
      "-L#{Formula["jpeg-turbo"].opt_lib} -ljpeg",
      "-lbz2",
      "-L#{Formula["lua"].opt_lib} -llua",
    ]

    defs = %w[
      -DUSE_CDROM
      -DUSE_LUA
      -DUTF8_CAPTION
      -DUTF8_FILESYSTEM
    ]
    defs << "-DMACOSX" if OS.mac?

    ext_objs = ["LUAHandler.o"]

    k = %w[INCS LIBS DEFS EXT_OBJS]
    v = [incs, libs, defs, ext_objs].map { |x| x.join(" ") }
    args = k.zip(v).map { |x| x.join("=") }
    platform = OS.mac? ? "MacOSX" : "Linux"
    system "make", "-f", "Makefile.#{platform}", *args
    bin.install %w[onscripter sardec nsadec sarconv nsaconv]
  end

  test do
    assert shell_output("#{bin}/onscripter -v").start_with? "ONScripter version #{version}"
  end
end
