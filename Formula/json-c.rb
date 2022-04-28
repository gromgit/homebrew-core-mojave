class JsonC < Formula
  desc "JSON parser for C"
  homepage "https://github.com/json-c/json-c/wiki"
  url "https://github.com/json-c/json-c/archive/refs/tags/json-c-0.16-20220414.tar.gz"
  version "0.16"
  sha256 "3ecaeedffd99a60b1262819f9e60d7d983844073abc74e495cb822b251904185"
  license "MIT"
  head "https://github.com/json-c/json-c.git", branch: "master"

  livecheck do
    url :stable
    regex(/^json-c[._-](\d+(?:\.\d+)+)(?:[._-]\d{6,8})?$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/json-c"
    sha256 cellar: :any, mojave: "f97b7bc4981d46e786fe6414885a8bb680b6df0520fd9cc8564f8c5d5e9f5e2f"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <stdio.h>
      #include <json-c/json.h>

      int main() {
        json_object *obj = json_object_new_object();
        json_object *value = json_object_new_string("value");
        json_object_object_add(obj, "key", value);
        printf("%s\n", json_object_to_json_string(obj));
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-ljson-c", "-o", "test"
    assert_equal '{ "key": "value" }', shell_output("./test").chomp
  end
end
