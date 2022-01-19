class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_105.tar.gz"
  sha256 "c5ec27c157d3b33ce4360607cc6afe565fa490094237895db2162b3a7d667da2"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/binaryen"
    sha256 cellar: :any, mojave: "98111eeb3a8244b9c468057b8164048f4976265b024213d4dfd7d7c02ae2df6b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", File.read("1.wast")
  end
end
