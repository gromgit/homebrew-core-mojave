class Hatari < Formula
  desc "Atari ST/STE/TT/Falcon emulator"
  homepage "https://hatari.tuxfamily.org"
  url "https://download.tuxfamily.org/hatari/2.4.1/hatari-2.4.1.tar.bz2"
  sha256 "2a5da1932804167141de4bee6c1c5d8d53030260fe7fe7e31e5e71a4c00e0547"
  license "GPL-2.0-or-later"
  head "https://git.tuxfamily.org/hatari/hatari.git", branch: "master"

  livecheck do
    url "https://download.tuxfamily.org/hatari/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hatari"
    sha256 cellar: :any, mojave: "53d52786676e1b92b53903a11e5a2993196810231dc38e7cbdda202713f165a6"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "python@3.10"
  depends_on "sdl2"

  # Download EmuTOS ROM image
  resource "emutos" do
    url "https://downloads.sourceforge.net/project/emutos/emutos/1.2/emutos-1024k-1.2.zip"
    sha256 "65933ffcda6cba87ab013b5e799c3a0896b9a7cb2b477032f88f091ab8578b2a"
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
        (prefix/"Hatari.app/Contents/Resources").install "etos1024k.img" => "tos.img"
      else
        pkgshare.install "etos1024k.img" => "tos.img"
      end
    end
  end

  test do
    assert_match "Hatari v#{version} -", shell_output("#{bin}/hatari -v", 1)
  end
end
