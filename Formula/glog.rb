class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.5.0.tar.gz"
  sha256 "eede71f28371bf39aa69b45de23b329d37214016e2055269b3b5e7cfd40b59f5"
  license "BSD-3-Clause"
  head "https://github.com/google/glog.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glog"
    rebuild 1
    sha256 cellar: :any, mojave: "35b9eefdb3533766eef130362e588af4d29c8f8bdd8bfa31687f66d41b12cbf3"
  end


  depends_on "cmake" => :build
  depends_on "gflags"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <glog/logging.h>
      #include <iostream>
      #include <memory>
      int main(int argc, char* argv[])
      {
        google::InitGoogleLogging(argv[0]);
        LOG(INFO) << "test";
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}",
                    "-lglog", "-I#{Formula["gflags"].opt_lib}",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-o", "test"
    system "./test"
  end
end
