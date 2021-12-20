class Glfw < Formula
  desc "Multi-platform library for OpenGL applications"
  homepage "https://www.glfw.org/"
  url "https://github.com/glfw/glfw/archive/3.3.6.tar.gz"
  sha256 "ed07b90e334dcd39903e6288d90fa1ae0cf2d2119fec516cf743a0a404527c02"
  license "Zlib"
  head "https://github.com/glfw/glfw.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glfw"
    sha256 cellar: :any, mojave: "e2215645df5d2ff0159cc89eb0f67a51bcad33cb5cdafa1f09e76b6785093ea9"
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

    on_linux do
      # glfw does not work in headless mode
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]
    end

    system "./test"
  end
end
