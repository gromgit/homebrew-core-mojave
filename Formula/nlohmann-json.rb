class NlohmannJson < Formula
  desc "JSON for modern C++"
  homepage "https://github.com/nlohmann/json"
  url "https://github.com/nlohmann/json/archive/v3.11.1.tar.gz"
  sha256 "598becb62ee0e01cf32795073c8ae09b6e95335cd43a4417b785d93ce105b0d0"
  license "MIT"
  head "https://github.com/nlohmann/json.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "15def2b80847f87a5dfa4accca3a577004a380f57241ec5ec803e205cc5f8cd7"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DJSON_BuildTests=OFF", "-DJSON_MultipleHeaders=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <nlohmann/json.hpp>

      using nlohmann::json;

      int main() {
        json j = {
          {"pi", 3.141},
          {"name", "Niels"},
          {"list", {1, 0, 2}},
          {"object", {
            {"happy", true},
            {"nothing", nullptr}
          }}
        };
        std::cout << j << std::endl;
      }
    EOS

    system ENV.cxx, "test.cc", "-I#{include}", "-std=c++11", "-o", "test"
    std_output = <<~EOS
      {"list":[1,0,2],"name":"Niels","object":{"happy":true,"nothing":null},"pi":3.141}
    EOS
    assert_match std_output, shell_output("./test")
  end
end
