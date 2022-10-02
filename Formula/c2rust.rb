class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9ed1720672afb503db91b30cec1dedcf878841f57eaea4c7046839890990d8cd"
  license "BSD-3-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/c2rust"
    sha256 cellar: :any, mojave: "eace950e85f604e327c2e8b9107da5bf6c3253e7f5c94bae65380304b75abfb1"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm@14"

  fails_with gcc: "5"

  def install
    system "cargo", "install", *std_cargo_args(path: "c2rust")
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/qsort/.", testpath
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
    system "cmake", "--build", "build"
    system bin/"c2rust", "transpile", "build/compile_commands.json"
    assert_predicate testpath/"qsort.c", :exist?
  end
end
