class Anttweakbar < Formula
  desc "C/C++ library for adding GUIs to OpenGL apps"
  homepage "https://anttweakbar.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/anttweakbar/AntTweakBar_116.zip"
  version "1.16"
  sha256 "fbceb719c13ceb13b9fd973840c2c950527b6e026f9a7a80968c14f76fcf6e7c"

  livecheck do
    skip "Not maintained"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/anttweakbar"
    rebuild 2
    sha256 cellar: :any, mojave: "c49fd0db31acd9cb4913f245ed1fe90ef406903ceb526697b7fbd7ff70c9e2f1"
  end

  on_linux do
    depends_on "libxcursor"
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # See:
  # https://sourceforge.net/p/anttweakbar/code/ci/5a076d13f143175a6bda3c668e29a33406479339/tree/src/LoadOGLCore.h?diff=5528b167ed12395a60949d7c643262b6668f15d5&diformat=regular
  # https://sourceforge.net/p/anttweakbar/tickets/14/
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/62e79481/anttweakbar/anttweakbar.diff"
    sha256 "3be2cb71cc00a9948c8b474da7e15ec85e3d094ed51ad2fab5c8991a9ad66fc2"
  end

  def install
    makefile = OS.mac? ? "Makefile.osx" : "Makefile"
    system "make", "-C", "src", "-f", makefile
    lib.install shared_library("lib/libAntTweakBar"), "lib/libAntTweakBar.a"
    include.install "include/AntTweakBar.h"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <AntTweakBar.h>
      int main() {
        TwBar *bar; // TwBar is an internal structure of AntTweakBar
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lAntTweakBar", "-o", "test"
    system "./test"
  end
end
