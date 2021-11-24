class Lightgbm < Formula
  desc "Fast, distributed, high performance gradient boosting framework"
  homepage "https://github.com/microsoft/LightGBM"
  url "https://github.com/microsoft/LightGBM.git",
      tag:      "v3.3.1",
      revision: "d4851c3381495d9a065d49e848fbf291a408477d"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lightgbm"
    rebuild 1
    sha256 cellar: :any, mojave: "490a079a5fcecc8eaef97ba07135b4cebca0877dfa482fc9a269f83e129de78b"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", *std_cmake_args, "-DAPPLE_OUTPUT_DYLIB=ON", ".."
      system "make"
      system "make", "install"
    end
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples/regression"), testpath
    cd "regression" do
      system "#{bin}/lightgbm", "config=train.conf"
    end
  end
end
