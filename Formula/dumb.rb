class Dumb < Formula
  desc "IT, XM, S3M and MOD player library"
  homepage "https://dumb.sourceforge.io"
  url "https://github.com/kode54/dumb/archive/refs/tags/2.0.3.tar.gz"
  sha256 "99bfac926aeb8d476562303312d9f47fd05b43803050cd889b44da34a9b2a4f9"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/dumb"
    sha256 cellar: :any, mojave: "0aef7a4d8679d100c114c95ee357f3a8710966f5e4f2ca07557c21aa542d98f8"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "sdl2"

  def install
    args = std_cmake_args + %w[
      -DBUILD_ALLEGRO4=OFF
      -DBUILD_EXAMPLES=ON
    ]

    # Build shared library
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Build static library
    system "cmake", "-S", ".", "-B", "build", *args, "-DBUILD_SHARED_LIBS=OFF"
    system "cmake", "--build", "build"
    lib.install "build/libdumb.a"
  end

  test do
    assert_match "missing option <file>", shell_output("#{bin}/dumbplay 2>&1", 1)
  end
end
