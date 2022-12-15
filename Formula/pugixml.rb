class Pugixml < Formula
  desc "Light-weight C++ XML processing library"
  homepage "https://pugixml.org/"
  url "https://github.com/zeux/pugixml/releases/download/v1.13/pugixml-1.13.tar.gz"
  sha256 "40c0b3914ec131485640fa57e55bf1136446026b41db91c1bef678186a12abbe"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/pugixml"
    sha256 cellar: :any_skip_relocation, mojave: "7375a0b079429aac657ffc7cffe238e3448e434981bfc48178affe60f9b73ab0"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DPUGIXML_BUILD_SHARED_AND_STATIC_LIBS=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <pugixml.hpp>
      #include <cassert>
      #include <cstring>

      int main(int argc, char *argv[]) {
        pugi::xml_document doc;
        pugi::xml_parse_result result = doc.load_file("test.xml");

        assert(result);
        assert(strcmp(doc.child_value("root"), "Hello world!") == 0);
      }
    EOS

    (testpath/"test.xml").write <<~EOS
      <root>Hello world!</root>
    EOS

    system ENV.cxx, "test.cpp", "-o", "test", "-I#{include}",
                    "-L#{lib}", "-lpugixml"
    system "./test"
  end
end
