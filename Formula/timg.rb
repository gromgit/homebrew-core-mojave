class Timg < Formula
  desc "Terminal image and video viewer"
  homepage "https://timg.sh/"
  url "https://github.com/hzeller/timg/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "7607efaffbed0b65b3c824956de421b155a4f14243e7a752b19454f88bf9d563"
  license "GPL-2.0-only"
  revision 1
  head "https://github.com/hzeller/timg.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/timg"
    rebuild 2
    sha256 cellar: :any, mojave: "dd3e59d705bbbb75e92c4de9a943fb9edbfdb32f485262db52e3ee658d7ad58e"
  end

  depends_on "cmake" => :build
  depends_on "ffmpeg"
  depends_on "graphicsmagick"
  depends_on "jpeg-turbo"
  depends_on "libexif"
  depends_on "libpng"
  depends_on "openslide"
  depends_on "webp"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/timg", "--version"
    system "#{bin}/timg", "-g10x10", test_fixtures("test.gif")
    system "#{bin}/timg", "-g10x10", test_fixtures("test.png")
    system "#{bin}/timg", "-pq", "-g10x10", "-o", testpath/"test-output.txt", test_fixtures("test.jpg")
    assert_match "38;2;255;38;0;49m", (testpath/"test-output.txt").read
  end
end
