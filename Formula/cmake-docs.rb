class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.22.1.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.22.1.tar.gz"
  sha256 "0e998229549d7b3f368703d20e248e7ee1f853910d42704aa87918c213ea82c0"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cmake-docs"
    sha256 cellar: :any_skip_relocation, mojave: "e09ed92fc6f26d382156ef9d2cd41b5a815b7a1f0011a60c85d11fab7fad41ac"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=share/doc/cmake",
                                                             "-DCMAKE_MAN_DIR=share/man",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
