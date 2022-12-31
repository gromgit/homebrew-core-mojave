class Csfml < Formula
  # Don't update CSFML until there's a corresponding SFML release
  desc "SMFL bindings for C"
  homepage "https://www.sfml-dev.org/"
  url "https://github.com/SFML/CSFML/archive/2.5.1.tar.gz"
  sha256 "0c6693805b700c53552565149405a041a00dbe898c2efb828e91999ab8b6b1d4"
  license "Zlib"
  head "https://github.com/SFML/CSFML.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/csfml"
    rebuild 1
    sha256 cellar: :any, mojave: "5d8e70d636ad184743cf77efa2a3c26289a93a8d39b32c3e0785184c98e0d7d7"
  end

  depends_on "cmake" => :build
  depends_on "sfml"

  def install
    system "cmake", ".", "-DCMAKE_MODULE_PATH=#{Formula["sfml"].share}/SFML/cmake/Modules/", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SFML/Window.h>

      int main (void)
      {
        sfWindow * w = sfWindow_create (sfVideoMode_getDesktopMode (), "Test", 0, NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcsfml-window", "-o", "test"
    # Disable this part of the test on Linux because display is not available.
    system "./test" if OS.mac?
  end
end
