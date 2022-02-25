class Alembic < Formula
  desc "Open computer graphics interchange framework"
  homepage "http://alembic.io"
  url "https://github.com/alembic/alembic/archive/1.8.3.tar.gz"
  sha256 "b0bc74833bff118a869e81e6acb810a58797e77ef63143954b2f8e817c7f65cb"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/alembic/alembic.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/alembic"
    sha256 cellar: :any, mojave: "5e23354c808c6d76be61764ad7f091dad4520c57627f308c88eec42dd0472f44"
  end

  depends_on "cmake" => :build
  depends_on "hdf5"
  depends_on "imath"
  depends_on "szip"

  uses_from_macos "zlib"

  def install
    cmake_args = std_cmake_args + %w[
      -DUSE_PRMAN=OFF
      -DUSE_ARNOLD=OFF
      -DUSE_MAYA=OFF
      -DUSE_PYALEMBIC=OFF
      -DUSE_HDF5=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "prman/Tests/testdata/cube.abc"
  end

  test do
    assert_match "root", shell_output("#{bin}/abcls #{pkgshare}/cube.abc")
  end
end
