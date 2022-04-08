class YamlCpp < Formula
  desc "C++ YAML parser and emitter for YAML 1.2 spec"
  homepage "https://github.com/jbeder/yaml-cpp"
  url "https://github.com/jbeder/yaml-cpp/archive/yaml-cpp-0.7.0.tar.gz"
  sha256 "43e6a9fcb146ad871515f0d0873947e5d497a1c9c60c58cb102a97b47208b7c3"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/yaml-cpp"
    rebuild 1
    sha256 cellar: :any, mojave: "823aa9806e2606b8a6ed221959040296947484629d98e4a12af5b8e9eafbe8d7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args, "-DYAML_BUILD_SHARED_LIBS=ON",
                                          "-DYAML_CPP_BUILD_TESTS=OFF"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <yaml-cpp/yaml.h>
      int main() {
        YAML::Node node  = YAML::Load("[0, 0, 0]");
        node[0] = 1;
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{lib}", "-lyaml-cpp", "-o", "test"
    system "./test"
  end
end
