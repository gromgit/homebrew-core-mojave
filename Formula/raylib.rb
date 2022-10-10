class Raylib < Formula
  desc "Simple and easy-to-use library to learn videogames programming"
  homepage "https://www.raylib.com/"
  url "https://github.com/raysan5/raylib/archive/4.2.0.tar.gz"
  sha256 "676217604a5830cb4aa31e0ede0e4233c942e2fc5c206691bded58ebcd82a590"
  license "Zlib"
  head "https://github.com/raysan5/raylib.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/raylib"
    sha256 cellar: :any_skip_relocation, mojave: "3530d40c3ad73602fd09bd4034266d40be4d17d75c8e7cbb6df00cb98383d819"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxinerama"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON",
                         "-DMACOS_FATLIB=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_GAMES=OFF",
                         *std_cmake_args
    system "make", "install"
    system "make", "clean"
    system "cmake", ".", "-DBUILD_SHARED_LIBS=OFF",
                         "-DMACOS_FATLIB=OFF",
                         "-DBUILD_EXAMPLES=OFF",
                         "-DBUILD_GAMES=OFF",
                         *std_cmake_args
    system "make"
    lib.install "raylib/libraylib.a"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <raylib.h>
      int main(void)
      {
          int num = GetRandomValue(42, 1337);
          return 42 <= num && num <= 1337 ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS
    flags = if OS.mac?
      %w[
        -framework Cocoa
        -framework IOKit
        -framework OpenGL
      ]
    else
      %w[
        -lm
        -ldl
        -lGL
        -lpthread
      ]
    end
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lraylib", *flags
    system "./test"
  end
end
