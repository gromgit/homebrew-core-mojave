class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://github.com/Kitware/CMake/releases/download/v3.21.4/cmake-3.21.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.21.4.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.21.4.tar.gz"
  sha256 "d9570a95c215f4c9886dd0f0564ca4ef8d18c30750f157238ea12669c2985978"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  # The "latest" release on GitHub has been an unstable version before, so we
  # check the Git tags instead.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cmake-docs"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "c93f57fb307869fd69d416b9c91f180be42b2b866304b70dc694fe88c185c7fc"
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
