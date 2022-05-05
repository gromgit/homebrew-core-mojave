class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.3.1/hatari-2.3.1.tar.bz2"
  sha256 "44a2f62ca995e38d9e0874806956f0b9c3cc84ea89e0169a63849b63cd3b64bd"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.tuxfamily.org/hatari/hatari.git", branch: "master"

  livecheck do
    url "https://download.tuxfamily.org/hatari/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hatari"
    rebuild 1
    sha256 cellar: :any, mojave: "f67f9712586f5ae40207c548b059b90a75dc97cb461b22075615955055d6d966"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "portaudio"
  depends_on "python@3.10"
  depends_on "sdl2"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.0.1/emutos-512k-1.0.1.zip"
    sha256 "96c698aa0fc0f51ecdb0f8b53484df9de273215467b5de3f44d245821dff795e"
  end

  def install
    # Set .app bundle destination
    inreplace "src/CMakeLists.txt", "/Applications", prefix
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
      "-DPYTHON_EXECUTABLE=#{Formula["python@3.10"].opt_bin}/python3"
    system "cmake", "--build", "build"
    if OS.mac?
      prefix.install "build/src/Hatari.app"
      bin.write_exec_script "#{prefix}/Hatari.app/Contents/MacOS/hatari"
    else
      system "cmake", "--install", "build"
    end
    resource("emutos").stage do
      if OS.mac?
        (prefix/"Hatari.app/Contents/Resources").install "etos512k.img" => "tos.img"
      else
        pkgshare.install "etos512k.img" => "tos.img"
      end
    end
  end

  test do
    assert_match "Hatari v#{version} -", shell_output("#{bin}/hatari -v", 1)
  end
end
