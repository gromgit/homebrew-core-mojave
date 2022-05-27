class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "2.1.2",
      revision: "c6eaf01456db4baa61f876762fdb2d8bf49727e4"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glslviewer"
    sha256 cellar: :any, mojave: "96a6cfc8cf6885177e8d6d08ada1e2b2402f25cf6a3acb4af903d390412053a1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@4"
  depends_on "glfw"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/2D/01_buffers/.", testpath
    pid = fork { exec "#{bin}/glslViewer", "00_ripples.frag", "-l" }
  ensure
    Process.kill("HUP", pid)
  end
end
