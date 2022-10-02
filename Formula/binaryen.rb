class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_110.tar.gz"
  sha256 "0f80250a02b94dd81bdedeae029eb805abf607fcdadcfee5ca8b5e6b77035601"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/binaryen"
    rebuild 1
    sha256 cellar: :any, mojave: "ec1eecfbec6cc2333a5803ec97272cf45839a8e9d33ae7690abb8b1c4dea2403"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_TESTS=false"
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", File.read("1.wast")
  end
end
