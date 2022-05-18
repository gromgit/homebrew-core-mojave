class Glslviewer < Formula
  desc "Live-coding console tool that renders GLSL Shaders"
  homepage "http://patriciogonzalezvivo.com/2015/glslViewer/"
  url "https://github.com/patriciogonzalezvivo/glslViewer.git",
      tag:      "2.0.5",
      revision: "788bb17bfa10759dd88def6979f1d16b31591ff6"
  license "BSD-3-Clause"
  head "https://github.com/patriciogonzalezvivo/glslViewer.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glslviewer"
    sha256 cellar: :any, mojave: "719e99c1cd0e5612632bc444e6b91f366d914f3e924f24a3d314e3210e8bfb94"
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
