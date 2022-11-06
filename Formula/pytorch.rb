class Pytorch < Formula
  desc "Tensors and dynamic neural networks"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.12.1",
      revision: "664058fa83f1d8eede5d66418abff6e20bd76ca8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pytorch"
    sha256 cellar: :any_skip_relocation, mojave: "6ce4e7001d25d65ea1167bf15c4cbcbc1deb23d22d8152d42e4927b0fb10ebac"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "eigen"
  depends_on "libuv"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python-typing-extensions"
  depends_on "pyyaml"

  on_macos do
    depends_on "libomp"
  end

  # Update fbgemm to a version that works with macOS on Intel.
  # Remove with next release.
  resource "fbgemm" do
    url "https://github.com/pytorch/FBGEMM.git",
    revision: "0d98c261561524cce92e37fe307ea6596664309a"
  end

  def install
    rm_r "third_party/fbgemm"

    resource("fbgemm").stage(buildpath/"third_party/fbgemm")

    # Remove with next release
    inreplace "cmake/Dependencies.cmake",
      'if("${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang" AND CMAKE_CXX_COMPILER_VERSION VERSION_GREATER 13.0.0)',
      "if(FALSE)"

    openssl_root = Formula["openssl@1.1"].opt_prefix
    python_exe = Formula["python@3.10"].opt_libexec/"bin/python"
    args = %W[
      -GNinja
      -DBLAS=OpenBLAS
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=ON
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DOPENSSL_ROOT_DIR=#{openssl_root}
      -DPYTHON_EXECUTABLE=#{python_exe}
      -DUSE_CUDA=OFF
      -DUSE_DISTRIBUTED=ON
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=ON
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
      -DUSE_SYSTEM_PYBIND11=ON
    ]
    # Remove when https://github.com/pytorch/pytorch/issues/67974 is addressed
    args << "-DUSE_SYSTEM_BIND11=ON"

    ENV["LDFLAGS"] = "-L#{buildpath}/build/lib"

    # Update references to shared libraries
    inreplace "torch/__init__.py" do |s|
      s.sub!(/here = os.path.abspath\(__file__\)/, "here = \"#{lib}\"")
      s.sub!(/get_file_path\('torch', 'bin', 'torch_shm_manager'\)/, "\"#{bin}/torch_shm_manager\"")
    end

    inreplace "torch/utils/cpp_extension.py", "_TORCH_PATH = os.path.dirname(os.path.dirname(_HERE))",
                                              "_TORCH_PATH = \"#{opt_prefix}\""

    system "cmake", "-B", "build", "-S", ".", *std_cmake_args, *args

    # Avoid references to Homebrew shims
    inreplace "build/caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

    system python_exe, *Language::Python.setup_install_args(prefix, python_exe)
  end

  test do
    # test that C++ libraries are available
    (testpath/"test.cpp").write <<~EOS
      #include <torch/torch.h>
      #include <iostream>

      int main() {
        torch::Tensor tensor = torch::rand({2, 3});
        std::cout << tensor << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}/torch/csrc/api/include",
                    "-L#{lib}", "-ltorch", "-ltorch_cpu", "-lc10"
    system "./test"

    # test that `torch` Python module is available
    python = Formula["python@3.10"]
    system python.opt_libexec/"bin/python", "-c", <<~EOS
      import torch
      torch.rand(5, 3)
    EOS
  end
end
