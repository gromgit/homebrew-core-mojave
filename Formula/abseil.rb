class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20220623.0.tar.gz"
  sha256 "4208129b49006089ba1d6710845a45e31c59b0ab6bff9e5788a87f55c5abd602"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/abseil"
    sha256 cellar: :any, mojave: "77446c4883862668ac7dfdc2c1dd367fa48d0425494d0d980abe4688d5df6583"
  end

  depends_on "cmake" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # C++17

  def install
    mkdir "build" do
      system "cmake", "..",
                      *std_cmake_args,
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      "-DCMAKE_CXX_STANDARD=17",
                      "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <string>
      #include <vector>
      #include "absl/strings/str_join.h"

      int main() {
        std::vector<std::string> v = {"foo","bar","baz"};
        std::string s = absl::StrJoin(v, "-");

        std::cout << "Joined string: " << s << "\\n";
      }
    EOS
    system ENV.cxx, "-std=c++17", "-I#{include}", "-L#{lib}", "-labsl_strings",
                    "test.cc", "-o", "test"
    assert_equal "Joined string: foo-bar-baz\n", shell_output("#{testpath}/test")
  end
end
