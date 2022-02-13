class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.2",
      revision: "c685033a13127e8442549ff55b2554ed65ff3cfb"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fceux"
    sha256 cellar: :any, mojave: "122c3a920b606c37c907ecf2415e17dcc1360c2fdb27220c7b2c0cb6f04da07f"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "x264"

  on_linux do
    depends_on "gcc"
  end
  fails_with gcc: "5"

  def install
    ENV["CXXFLAGS"] = "-DPUBLIC_RELEASE=1" if build.stable?
    system "cmake", ".", *std_cmake_args
    system "make"
    cp "src/auxlib.lua", "output/luaScripts"
    libexec.install "src/fceux.app/Contents/MacOS/fceux"
    pkgshare.install ["output/luaScripts", "output/palettes", "output/tools"]
    (bin/"fceux").write <<~EOS
      #!/bin/bash
      LUA_PATH=#{pkgshare}/luaScripts/?.lua #{libexec}/fceux "$@"
    EOS
  end

  test do
    system "#{bin}/fceux", "--help"
  end
end
