class Httping < Formula
  desc "Ping-like tool for HTTP requests"
  homepage "https://github.com/folkertvanheusden/HTTPing"
  url "https://github.com/folkertvanheusden/HTTPing/archive/refs/tags/v2.9.tar.gz"
  sha256 "37da3c89b917611d2ff81e2f6c9e9de39d160ef0ca2cb6ffec0bebcb9b45ef5d"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/httping"
    sha256 cellar: :any, mojave: "8104095b2bdd63b15709d35f34547decf8ae1fb36ab36ed53bdf9c311c3109d0"
  end

  depends_on "gettext"
  depends_on "openssl@1.1"
  uses_from_macos "ncurses"

  def install
    # Reported upstream, see: https://github.com/folkertvanheusden/HTTPing/issues/4
    inreplace "utils.h", "useconds_t", "unsigned int"
    # Reported upstream, see: https://github.com/folkertvanheusden/HTTPing/issues/7
    inreplace %w[configure Makefile], "lncursesw", "lncurses"
    ENV.append "LDFLAGS", "-lintl" if OS.mac?
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"httping", "-c", "2", "-g", "https://brew.sh/"
  end
end
