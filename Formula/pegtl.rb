class Pegtl < Formula
  desc "Parsing Expression Grammar Template Library"
  homepage "https://github.com/taocpp/PEGTL"
  url "https://github.com/taocpp/PEGTL/archive/3.2.6.tar.gz"
  sha256 "0ad229e47e5e865c90788bb9865447804c72dcb171b7402f6f0fe8c78f3b2035"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e5bf7f8d54f0007d2e43e4cdb68c20fc996ef16a22ade4351b563fef1de3802f"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DPEGTL_BUILD_TESTS=OFF",
                            "-DPEGTL_BUILD_EXAMPLES=OFF",
                            "-DCMAKE_CXX_STANDARD=17"
      system "make", "install"
    end
    rm "src/example/pegtl/CMakeLists.txt"
    (pkgshare/"examples").install (buildpath/"src/example/pegtl").children
  end

  test do
    system ENV.cxx, pkgshare/"examples/hello_world.cpp", "-std=c++17", "-o", "helloworld"
    assert_equal "Good bye, homebrew!\n", shell_output("./helloworld 'Hello, homebrew!'")
  end
end
