class Mrboom < Formula
  desc "Eight player Bomberman clone"
  homepage "http://mrboom.mumblecore.org/"
  url "https://github.com/Javanaise/mrboom-libretro/releases/download/5.2/MrBoom-src-5.2.454d614.tar.gz"
  version "5.2"
  sha256 "50e4fe4bc74b23ac441499c756c4575dfe9faab9e787a3ab942a856ac63cf10d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mrboom"
    rebuild 1
    sha256 cellar: :any, mojave: "71d222c2c2e4f83545e05331190b9efbaf28370b5446da4fee1239f73e7f6eab"
  end

  depends_on "cmake" => :build
  depends_on "libmodplug"
  depends_on "minizip"
  depends_on "sdl2"
  depends_on "sdl2_mixer"

  def install
    if MacOS.version < :catalina
      inreplace "Makefile", "-I/usr/local/include", "-I#{HOMEBREW_PREFIX}/include/SDL2 -I#{HOMEBREW_PREFIX}/include"
    end
    system "make", "mrboom", "LIBSDL2=1"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=share/man/man6"
  end

  test do
    require "pty"
    require "expect"
    require "timeout"
    PTY.spawn(bin/"mrboom", "-m", "-f 0", "-z") do |r, _w, pid|
      sleep 15
      Process.kill "SIGINT", pid
      assert_match "monster", r.expect(/monster/, 10)[0]
    ensure
      begin
        Timeout.timeout(30) do
          Process.wait pid
        end
      rescue Timeout::Error
        Process.kill "KILL", pid
      end
    end
  end
end
