class Exult < Formula
  desc "Recreation of Ultima 7"
  homepage "https://exult.sourceforge.io/"
  url "https://github.com/exult/exult/archive/v1.6.tar.gz"
  sha256 "6176d9feba28bdf08fbf60f9ebb28a530a589121f3664f86711ff8365c86c17a"
  license "GPL-2.0-or-later"
  head "https://github.com/exult/exult.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/exult"
    rebuild 2
    sha256 mojave: "780e0f95c37ebe59e3dad5d47dfaac7275c6a4fc98025b7eca100917407e32d7"
  end


  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sdl2"

  # Xcode 12 compile fix for 1.6.x branch - https://github.com/exult/exult/pull/61
  patch do
    url "https://github.com/exult/exult/commit/b98a9eb195bf8b3f55df56499d2a7c2c5d8809d0.patch?full_index=1"
    sha256 "c1c5b1e9e4994ecdfaba6285b86222123ee6b5590bcd8e7400871a4e65836fe0"
  end

  def install
    # Use ~/Library/... instead of /Library for the games
    inreplace "files/utils.cc" do |s|
      s.gsub!(/(gamehome_dir)\("\."\)/, '\1(home_dir)')
      s.gsub!(/(gamehome_dir) =/, '\1 +=')
    end

    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "EXULT_DATADIR=#{pkgshare}/data"
    system "make", "bundle"
    pkgshare.install "Exult.app/Contents/Resources/data"
    prefix.install "Exult.app"
    bin.write_exec_script "#{prefix}/Exult.app/Contents/MacOS/exult"
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
