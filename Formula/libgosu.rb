class Libgosu < Formula
  desc "2D game development library"
  homepage "https://libgosu.org"
  url "https://github.com/gosu/gosu/archive/v1.4.3.tar.gz"
  sha256 "0dadad26ff3ecbc585ce052c3d89cacc980de62690ee62e30ae8a42b1b78d2d7"
  license "MIT"
  head "https://github.com/gosu/gosu.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libgosu"
    sha256 cellar: :any, mojave: "2168aa6913eefeaade7c3d471dcdbbd4be16b2a2d925443110f47bad09fe3ee7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  on_linux do
    depends_on "fontconfig"
    depends_on "gcc"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <stdlib.h>
      #include <Gosu/Gosu.hpp>

      class MyWindow : public Gosu::Window
      {
      public:
          MyWindow()
          :   Gosu::Window(640, 480)
          {
              set_caption(\"Hello World!\");
          }

          void update()
          {
              exit(0);
          }
      };

      int main()
      {
          MyWindow window;
          window.show();
      }
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lgosu", "-I#{include}", "-std=c++17"

    # Fails in Linux CI with "Could not initialize SDL Video: No available video device"
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system "./test"
  end
end
