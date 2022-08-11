class C2rust < Formula
  desc "Migrate C code to Rust"
  homepage "https://github.com/immunant/c2rust"
  url "https://github.com/immunant/c2rust/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "9ed1720672afb503db91b30cec1dedcf878841f57eaea4c7046839890990d8cd"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/c2rust"
    sha256 cellar: :any, mojave: "aa255a968f9aae85cf65f3548a85112c46940927a7ba054af6bfc66e4b469f91"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

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
