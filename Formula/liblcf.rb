class Liblcf < Formula
  desc "Library for RPG Maker 2000/2003 games data"
  homepage "https://easyrpg.org/"
  url "https://easyrpg.org/downloads/player/0.7.0/liblcf-0.7.0.tar.xz"
  sha256 "ed76501bf973bf2f5bd7240ab32a8ae3824dce387ef7bb3db8f6c073f0bc7a6a"
  license "MIT"
  revision 1
  head "https://github.com/EasyRPG/liblcf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/liblcf"
    sha256 cellar: :any, mojave: "cf0e031ba3bd45002305ed03375b0d7609b676d93cde6929c0b0bb8dd17369f4"
  end

  depends_on "cmake" => :build
  depends_on "icu4c"

  uses_from_macos "expat"

  def install
    args = std_cmake_args + ["-DLIBLCF_UPDATE_MIMEDB=OFF"]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "lcf/lsd/reader.h"
      #include <cassert>

      int main() {
        std::time_t const current = std::time(NULL);
        assert(current == lcf::LSD_Reader::ToUnixTimestamp(lcf::LSD_Reader::ToTDateTime(current)));
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-llcf", \
      "-o", "test"
    system "./test"
  end
end
