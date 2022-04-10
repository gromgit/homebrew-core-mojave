class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.7.tar.gz"
  sha256 "fd21a5f65bcc0fc3c76e0f8865776e852de09ef6fbc3620e09ce96d2b2807e04"
  license "Zlib"
  head "https://github.com/glfw/glfw.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glfw"
    sha256 cellar: :any, mojave: "93d65f1da414e7999439dcd684561880aea5c414afe4aa718f70645047a3b0f5"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "freeglut"
    depends_on "libxcursor"
    depends_on "mesa"
  end

  def install
    args = std_cmake_args + %w[
      -DGLFW_USE_CHDIR=TRUE
      -DGLFW_USE_MENUBAR=TRUE
      -DBUILD_SHARED_LIBS=TRUE
    ]

    system "cmake", *args, "."
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #define GLFW_INCLUDE_GLU
      #include <GLFW/glfw3.h>
      #include <stdlib.h>
      int main()
      {
        if (!glfwInit())
          exit(EXIT_FAILURE);
        glfwTerminate();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test",
                   "-I#{include}", "-L#{lib}", "-lglfw"

    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
