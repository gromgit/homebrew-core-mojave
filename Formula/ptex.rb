class Ptex < Formula
  desc "Texture mapping system"
  homepage "https://ptex.us/"
  url "https://github.com/wdas/ptex/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "c8235fb30c921cfb10848f4ea04d5b662ba46886c5e32ad5137c5086f3979ee1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ptex"
    sha256 cellar: :any, mojave: "6f7f1d2149c68d2f60d9e90151a4eacaa5c0aba47a2dc7fc2ef8689cd3f4de2d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "zlib"

  resource "wtest" do
    url "https://raw.githubusercontent.com/wdas/ptex/v2.4.2/src/tests/wtest.cpp"
    sha256 "95c78f97421eac034401b579037b7ba4536a96f4b356f8f1bb1e87b9db752444"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("wtest").stage testpath
    system ENV.cxx, "wtest.cpp", "-o", "wtest", "-I#{opt_include}", "-L#{opt_lib}", "-lPtex"
    system "./wtest"
    system bin/"ptxinfo", "-c", "test.ptx"
  end
end
