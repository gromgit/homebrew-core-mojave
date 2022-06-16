class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://angband.github.io/angband/"
  url "https://github.com/angband/angband/releases/download/4.2.4/Angband-4.2.4.tar.gz"
  sha256 "a07c78c1dd05e48ddbe4d8ef5d1880fcdeab55fd05f1336d9cba5dd110b15ff3"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/angband/angband.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/angband"
    sha256 mojave: "1625c54466f46582faa4685b738247923d2d64c23076146cfff6b3428a5ca4a5"
  end

  uses_from_macos "expect" => :test
  uses_from_macos "ncurses"

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config" if OS.mac?
    args = %W[
      --prefix=#{prefix}
      --bindir=#{bin}
      --libdir=#{libexec}
      --enable-curses
      --disable-ncursestest
      --disable-sdltest
      --disable-x11
    ]
    args << "--with-ncurses-prefix=#{MacOS.sdk_path}/usr" if OS.mac?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    script = (testpath/"script.exp")
    script.write <<~EOS
      #!/usr/bin/expect -f
      set timeout 10
      spawn angband
      sleep 2
      send -- "\x18"
      sleep 2
      send -- "\x18"
      expect eof
    EOS
    system "expect", "-f", "script.exp"
  end
end
