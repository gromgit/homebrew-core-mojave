class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.6.1",
      revision: "7173d283c3a12f634ad5189c5a90ff495e1d266a"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fceux"
    sha256 cellar: :any, mojave: "4861b2f49a575c07f2571f0f4f6acf530b30f37f788d04f322ccc4052022cf46"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "minizip"
  depends_on "qt@5"
  depends_on "sdl2"
  depends_on "x264"

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
