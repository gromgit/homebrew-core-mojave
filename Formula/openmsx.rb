class Openmsx < Formula
  desc "MSX emulator"
  homepage "https://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_17_0/openmsx-17.0.tar.gz"
  sha256 "70ec6859522d8e3bbc97227abb98c87256ecda555b016d1da85cdd99072ce564"
  license "GPL-2.0"
  head "https://github.com/openMSX/openMSX.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/RELEASE[._-]v?(\d+(?:[._]\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/openmsx"
    rebuild 1
    sha256 cellar: :any, mojave: "6deed251380c5875e969e3cbf5982d5d00ecd6a2736d9ee35e217d551a1f6ae4"
  end

  depends_on "python@3.10" => :build
  depends_on "freetype"
  depends_on "glew"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "theora"

  uses_from_macos "zlib"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # Hardcode prefix
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    inreplace "build/probe.py", "/usr/local", HOMEBREW_PREFIX

    # Help finding Tcl (https://github.com/openMSX/openMSX/issues/1082)
    ENV["TCL_CONFIG"] = "#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework" if OS.mac?

    system "./configure"
    system "make"

    if OS.mac?
      prefix.install Dir["derived/**/openMSX.app"]
      bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
    else
      system "make", "install"
    end
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
