class Faiss < Formula
  desc "Efficient similarity search and clustering of dense vectors"
  homepage "https://github.com/facebookresearch/faiss"
  url "https://github.com/facebookresearch/faiss/archive/v1.7.2.tar.gz"
  sha256 "d49b4afd6a7a5b64f260a236ee9b2efb760edb08c33d5ea5610c2f078a5995ec"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/faiss"
    sha256 cellar: :any, mojave: "37d8833cef9a1b7d355d7e063c4fe7c43a1709eb6f88a71b9ed6397f6f2a5f7a"
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "openblas"

  def install
    args = *std_cmake_args + %w[
      -DFAISS_ENABLE_GPU=OFF
      -DFAISS_ENABLE_PYTHON=OFF
      -DBUILD_SHARED_LIBS=ON
    ]
    system "cmake", "-B", "build", ".", *args
    cd "build" do
      system "make"
      system "make", "install"
    end
    pkgshare.install "demos"
  end

  test do
    cp pkgshare/"demos/demo_imi_flat.cpp", testpath
    system ENV.cxx, "-std=c++11", "-L#{lib}", "-lfaiss", "demo_imi_flat.cpp", "-o", "test"
    assert_match "Query results", shell_output("./test")
  end
end
