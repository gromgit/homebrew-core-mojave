class Supermodel < Formula
  desc "Sega Model 3 arcade emulator"
  homepage "https://www.supermodel3.com/"
  url "https://www.supermodel3.com/Files/Supermodel_0.2a_Src.zip"
  sha256 "ecaf3e7fc466593e02cbf824b722587d295a7189654acb8206ce433dcff5497b"
  license "GPL-3.0-or-later"
  revision 1
  head "https://svn.code.sf.net/p/model3emu/code/trunk"

  livecheck do
    url "https://www.supermodel3.com/Download.html"
    regex(/href=.*?Supermodel[._-]v?(\d+(?:\.\d+)+[a-z]?)[._-]Src\.zip/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/supermodel"
    sha256 mojave: "3347700a0d8c6957951e46f0c7513a6084bbbdb38f708734cef8c652abf9976e"
  end

  depends_on "sdl12-compat"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    makefile_dir = build.head? ? "Makefiles/Makefile.OSX" : "Makefiles/Makefile.SDL.OSX.GCC"
    if OS.mac?
      inreplace makefile_dir do |s|
        # Set up SDL library correctly
        s.gsub! "-framework SDL", "`sdl-config --libs`"
        s.gsub!(/(\$\(COMPILER_FLAGS\))/, "\\1 -I#{Formula["sdl12-compat"].opt_prefix}/include")
      end
    else
      makefile_dir = "Makefiles/Makefile.SDL.UNIX.GCC"
    end

    inreplace makefile_dir do |s|
      # Fix missing label issue for auto-generated code
      s.gsub! %r{(\$\(OBJ_DIR\)/m68k\w+)\.o: \1.c (.*)\n(\s*\$\(CC\)) \$<}, "\\1.o: \\2\n\\3 \\1.c"
      # Add -std=c++14
      s.gsub! "$(CPPFLAGS)", "$(CPPFLAGS) -std=c++14" if OS.linux?
    end

    # Use /usr/local/var/supermodel for saving runtime files
    inreplace "Src/OSD/SDL/Main.cpp" do |s|
      s.gsub! %r{(Config|Saves|NVRAM)/}, "#{var}/supermodel/\\1/"
      s.gsub!(/(\w+\.log)/, "#{var}/supermodel/Logs/\\1")
    end

    system "make", "-f", makefile_dir
    bin.install "bin/Supermodel" => "supermodel"
    (var/"supermodel/Config").install "Config/Supermodel.ini"
    (var/"supermodel/Saves").mkpath
    (var/"supermodel/NVRAM").mkpath
    (var/"supermodel/Logs").mkpath
  end

  def caveats
    <<~EOS
      Config, Saves, and NVRAM are located in the following directory:
        #{var}/supermodel/
    EOS
  end

  test do
    system "#{bin}/supermodel", "-print-games"
  end
end
