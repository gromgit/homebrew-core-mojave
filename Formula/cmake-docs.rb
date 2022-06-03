class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.23.2/cmake-3.23.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.23.2.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.23.2.tar.gz"
  sha256 "f316b40053466f9a416adf981efda41b160ca859e97f6a484b447ea299ff26aa"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cmake-docs"
    sha256 cellar: :any_skip_relocation, mojave: "e587760890b596e6ac4ccba612f6677f0fdbf1f275d1c2d51f202f80a2b8501c"
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
