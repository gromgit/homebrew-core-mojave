class Glog < Formula
  desc "Application-level logging library"
  homepage "https://github.com/google/glog"
  url "https://github.com/google/glog/archive/v0.6.0.tar.gz"
  sha256 "8a83bf982f37bb70825df71a9709fa90ea9f4447fb3c099e1d720a439d88bad6"
  license "BSD-3-Clause"
  head "https://github.com/google/glog.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glog"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "114c85e1251d6e7804a7d2fba6f7fe9ce571b90cc9c2c59e8d9712c225251b53"
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
