class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer/archive/1.7.0.tar.gz"
  sha256 "4a03e989dc81587061714ccc130268cc06ddaff256ea24b7492ca28dc855e8d6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/patriciogonzalezvivo/glslViewer.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glslviewer"
    rebuild 1
    sha256 cellar: :any, mojave: "1c8c64a2d0b7a062debe57518edeee3005f10d759cc569141fdf164f0205dc20"
  end

  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "glfw"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  # From miniaudio commit in https://github.com/patriciogonzalezvivo/glslViewer/tree/#{version}/include
  resource "miniaudio" do
    url "https://raw.githubusercontent.com/mackron/miniaudio/199d6a7875b4288af6a7b615367c8fdc2019b03c/miniaudio.h"
    sha256 "ee0aa8668db130ed92956ba678793f53b0bbf744e3f8584d994f3f2a87054790"
  end

  def install
    (buildpath/"include/miniaudio").install resource("miniaudio")
    system "make"
    bin.install "glslViewer"
  end

  test do
    system "#{bin}/glslViewer", "--help"
  end
end
