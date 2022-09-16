class Glui < Formula
  desc "C++ user interface library"
  homepage "https://glui.sourceforge.io/"
  url "https://github.com/libglui/glui/archive/2.37.tar.gz"
  sha256 "f7f6983f7410fe8dfaa032b2b7b1aac2232ec6a400a142b73f680683dad795f8"
  license "Zlib"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glui"
    sha256 cellar: :any_skip_relocation, mojave: "ba99bfb121e8476dbd3f28feb3e41e946c1e094c476b3d93c47e000f09e3abe7"
  end

  on_linux do
    depends_on "freeglut"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # Fix compiler warnings in glui.h. Merged into master on November 28, 2016.
  patch do
    url "https://github.com/libglui/glui/commit/fc9ad76733034605872a0d1323bb19cbc23d87bf.patch?full_index=1"
    sha256 "b1afada854f920692ab7cb6b6292034f3488936c4332e3e996798ee494a3fdd7"
  end

  def install
    system "make", "setup"
    system "make", "lib/libglui.a"
    lib.install "lib/libglui.a"
    include.install "include/GL"
  end

  test do
    if OS.mac?
      (testpath/"test.cpp").write <<~EOS
        #include <cassert>
        #include <GL/glui.h>
        int main() {
          GLUI *glui = GLUI_Master.create_glui("GLUI");
          assert(glui != nullptr);
          return 0;
        }
      EOS
      system ENV.cxx, "-framework", "GLUT", "-framework", "OpenGL", "-I#{include}",
        "-L#{lib}", "-lglui", "-std=c++11", "test.cpp"
      system "./a.out"
    else
      (testpath/"test.cpp").write <<~EOS
        #include <cassert>
        #include <GL/glui.h>
        #include <GL/glut.h>
        int main(int argc, char **argv) {
          glutInit(&argc, argv);
          GLUI *glui = GLUI_Master.create_glui("GLUI");
          assert(glui != nullptr);
          return 0;
        }
      EOS
      system ENV.cxx, "-I#{include}", "-std=c++11", "test.cpp",
        "-L#{lib}", "-lglui", "-lglut", "-lGLU", "-lGL"
      if ENV["DISPLAY"]
        # Fails without X display: freeglut (./a.out): failed to open display ''
        system "./a.out"
      end
    end
  end
end
