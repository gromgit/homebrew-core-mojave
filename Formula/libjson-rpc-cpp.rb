class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.4.0.tar.gz"
  sha256 "8fef7628eadbc0271c685310082ef4c47f1577c3df2e4c8bd582613d1bd10599"
  license "MIT"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libjson-rpc-cpp"
    rebuild 1
    sha256 cellar: :any, mojave: "e7ba00ec373a5b2314f9b36d2f2c9c627b2b5fb4fe8f4cc10298ea4ddb8413d2"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args, "-DCOMPILE_EXAMPLES=OFF", "-DCOMPILE_TESTS=OFF"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
