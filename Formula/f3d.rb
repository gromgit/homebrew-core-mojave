class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://kitware.github.io/F3D/"
  url "https://gitlab.kitware.com/f3d/f3d/-/archive/v1.1.0/f3d-v1.1.0.tar.gz"
  sha256 "93aa9759efcc4e77beac4568280aaeaca21bfb233d3c9f60262207ca595bde79"
  license "BSD-3-Clause"
  revision 3

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/f3d"
    rebuild 1
    sha256 cellar: :any, mojave: "3e667725c8971914aba14b3bcd8189be305adc038e8d0646d89a105c89956812"
  end

  depends_on "cmake" => :build
  depends_on "vtk"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # vtk is built with GCC

  # Fix build with vtk 9.1.
  # https://gitlab.kitware.com/f3d/f3d/-/commit/816b09c1e95622d6dc0384cd544572f73deed12c
  patch do
    url "https://gitlab.kitware.com/f3d/f3d/-/commit/816b09c1e95622d6dc0384cd544572f73deed12c.diff"
    sha256 "425af94fc44916850f05a5ee12cb5d4d3047efe974fce8e43b1ac7364471d6fe"
  end

  def install
    args = std_cmake_args + %W[
      -DMACOSX_BUILD_BUNDLE:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DF3D_INSTALL_DEFAULT_CONFIGURATION_FILE:BOOL=ON
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    # create a simple OBJ file with 3 points and 1 triangle
    (testpath/"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}/f3d --verbose --no-render --geometry-only #{testpath}/test.obj 2>&1").strip
    assert_match(/Loading.+obj/, f3d_out)
    assert_match "Number of points: 3", f3d_out
    assert_match "Number of polygons: 1", f3d_out
  end
end
