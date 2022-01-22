class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  url "https://github.com/ldc-developers/ldc/releases/download/v1.28.1/ldc-1.28.1-src.tar.gz"
  sha256 "654958bca5378cd97819f2ef61d3f220aa652a9d2b5ff41d6f2109302ae6eb94"
  license "BSD-3-Clause"
  head "https://github.com/ldc-developers/ldc.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ldc"
    sha256 mojave: "c533be1523fd0e4f8c8e2d58df22371a590e08341c0140b1ad545a6bf1037e13"
  end

  depends_on "cmake" => :build
  depends_on "libconfig" => :build
  depends_on "pkg-config" => :build

  uses_from_macos "libxml2" => :build
  # CompilerSelectionError: ldc cannot be built with any available compilers.
  uses_from_macos "llvm" => [:build, :test]

  on_macos do
    depends_on "llvm"
  end

  on_linux do
    # When built with LLVM, errors with:
    # undefined reference to `std::__throw_bad_array_new_length()'
    depends_on "llvm@12"
  end

  fails_with :gcc

  resource "ldc-bootstrap" do
    on_macos do
      if Hardware::CPU.intel?
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.0/ldc2-1.28.0-osx-x86_64.tar.xz"
        sha256 "02472507de988c8b5dd83b189c6df3b474741546589496c2ff3d673f26b8d09a"
      else
        url "https://github.com/ldc-developers/ldc/releases/download/v1.28.0/ldc2-1.28.0-osx-arm64.tar.xz"
        sha256 "f9786b8c28d8af1fdd331d8eb889add80285dbebfb97ea47d5dd9110a7df074b"
      end
    end

    on_linux do
      # ldc 1.27 requires glibc 2.27, which is too new for Ubuntu 16.04 LTS.  The last version we can bootstrap with
      # is 1.26.  Change this when we migrate to Ubuntu 18.04 LTS.
      url "https://github.com/ldc-developers/ldc/releases/download/v1.26.0/ldc2-1.26.0-linux-x86_64.tar.xz"
      sha256 "06063a92ab2d6c6eebc10a4a9ed4bef3d0214abc9e314e0cd0546ee0b71b341e"
    end
  end

  def llvm
    deps.reject { |d| d.build? || d.test? }
        .map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.cxx11
    (buildpath/"ldc-bootstrap").install resource("ldc-bootstrap")

    # Fix ldc-bootstrap/bin/ldmd2: error while loading shared libraries: libxml2.so.2
    ENV.prepend_path "LD_LIBRARY_PATH", Formula["libxml2"].lib if OS.linux?

    args = %W[
      -DLLVM_ROOT_DIR=#{llvm.opt_prefix}
      -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
      -DD_COMPILER=#{buildpath}/ldc-bootstrap/bin/ldmd2
    ]
    args << "-DCMAKE_INSTALL_RPATH=#{rpath};@loader_path/#{llvm.opt_lib.relative_path_from(lib)}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Don't set CC=llvm_clang since that won't be in PATH,
    # nor should it be used for the test.
    ENV.method(DevelopmentTools.default_compiler).call

    (testpath/"test.d").write <<~EOS
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS
    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=thin", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldc2", "-flto=full", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
