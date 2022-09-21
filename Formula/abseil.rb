class Abseil < Formula
  desc "C++ Common Libraries"
  homepage "https://abseil.io"
  url "https://github.com/abseil/abseil-cpp/archive/refs/tags/20220623.1.tar.gz"
  sha256 "91ac87d30cc6d79f9ab974c51874a704de9c2647c40f6932597329a282217ba8"
  license "Apache-2.0"
  head "https://github.com/abseil/abseil-cpp.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/abseil"
    rebuild 1
    sha256 cellar: :any, mojave: "8a28ebf92848d47fc028dccff14e5f5a2a06062a1cc400a8e51dbb3e58bd93f3"
  end

  depends_on "cmake" => :build

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
