class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.6.0.tar.gz"
  sha256 "95a1cf6f24948031df114798a97eea2a71143bd38a4d07d9a758dda3924c1932"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpu_features"
    sha256 cellar: :any, mojave: "b43ba819b86698bd66282c6d5613178214fae27858bd2d15ab0f6154c826a73a"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install static lib too
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libcpu_features.a"
  end

  test do
    output = shell_output(bin/"list_cpu_features")
    assert_match(/^arch\s*:/, output)
    assert_match(/^brand\s*:/, output)
    assert_match(/^family\s*:/, output)
    assert_match(/^model\s*:/, output)
    assert_match(/^stepping\s*:/, output)
    assert_match(/^uarch\s*:/, output)
    assert_match(/^flags\s*:/, output)
  end
end
