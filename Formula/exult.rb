class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/v1.8.tar.gz"
  sha256 "dae6b7b08925d3db1dda3aca612bdc08d934ca04de817a008f305320e667faf9"
  license "GPL-2.0-or-later"
  head "https://github.com/exult/exult.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/exult"
    rebuild 2
    sha256 mojave: "53e38bc033717e0bd2b12a5aae9049263c113ea5bed9aae903df1d09ade9f9d8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "EXULT_DATADIR=#{pkgshare}/data"
    if OS.mac?
      system "make", "bundle"
      pkgshare.install "Exult.app/Contents/Resources/data"
      prefix.install "Exult.app"
      bin.write_exec_script "#{prefix}/Exult.app/Contents/MacOS/exult"
    else
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      This formula only includes the game engine; you will need to supply your own
      own legal copy of the Ultima 7 game files for the software to fully function.

      Update audio settings accordingly with configuration file:
        ~/Library/Preferences/exult.cfg

        To use CoreAudio, set `driver` to `CoreAudio`.
        To use audio pack, set `use_oggs` to `yes`.
    EOS
  end

  test do
    system "#{bin}/exult", "-v"
  end
end
