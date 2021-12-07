class Fceux < Formula
  desc "All-in-one NES/Famicom Emulator"
  homepage "https://fceux.com/"
  url "https://github.com/TASEmulators/fceux.git",
      tag:      "fceux-2.5.0",
      revision: "6c3a31a4f2c09be297a32f510e74b383f858773b"
  license "GPL-2.0-only"
  head "https://github.com/TASEmulators/fceux.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fceux"
    rebuild 2
    sha256 cellar: :any, mojave: "b0a3af3dd81cac7f256f0915965b75c56756bf3ff3c92a8e4d34e0c9ecf3015f"
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
