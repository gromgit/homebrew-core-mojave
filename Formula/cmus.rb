class Cmus < Formula
  desc "Music player with an ncurses based interface"
  homepage "https://cmus.github.io/"
  url "https://github.com/cmus/cmus/archive/v2.9.1.tar.gz"
  sha256 "6fb799cae60db9324f03922bbb2e322107fd386ab429c0271996985294e2ef44"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/cmus/cmus.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cmus"
    sha256 mojave: "b88a41bf03688e16e81db27742471c8a16aaa8a3a025ce3da8ca5fad16939d54"
  end

  depends_on "pkg-config" => :build
  depends_on "faad2"
  depends_on "ffmpeg"
  depends_on "flac"
  depends_on "libcue"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "mp4v2"
  depends_on "opusfile"

  fails_with gcc: "5" # ffmpeg is compiled with GCC

  def install
    system "./configure", "prefix=#{prefix}", "mandir=#{man}",
                          "CONFIG_WAVPACK=n", "CONFIG_MPC=n"
    system "make", "install"
  end

  test do
    system "#{bin}/cmus", "--plugins"
  end
end
