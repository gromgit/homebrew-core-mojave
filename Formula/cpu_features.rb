class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.7.0.tar.gz"
  sha256 "df80d9439abf741c7d2fdcdfd2d26528b136e6c52976be8bd0cd5e45a27262c0"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cpu_features"
    sha256 cellar: :any, mojave: "1f2a0194da09356f0a49b6c3df2aa4808abe43c74af6770d7e92e4ec8b0994ea"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
