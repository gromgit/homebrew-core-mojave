class Libsbol < Formula
  desc "Read and write files in the Synthetic Biology Open Language (SBOL)"
  homepage "https://synbiodex.github.io/libSBOL"
  url "https://github.com/SynBioDex/libSBOL/archive/v2.3.2.tar.gz"
  sha256 "c85de13b35dec40c920ff8a848a91c86af6f7c7ee77ed3c750f414bbbbb53924"
  license "Apache-2.0"
  revision 2

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/libsbol"
    sha256 cellar: :any, mojave: "e9dafa0bea7c7d111904b6568b0fde726c1b7826e15ed28662c9c4b7bd0e4951"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "jsoncpp"
  depends_on "raptor"
  depends_on "rasqal"

  uses_from_macos "curl"
  uses_from_macos "libxslt"

  def install
    # upstream issue: https://github.com/SynBioDex/libSBOL/issues/215
    inreplace "source/CMakeLists.txt", "measure.h", "measurement.h"

    args = std_cmake_args
    args << "-DSBOL_BUILD_SHARED=TRUE"
    args << "-DRAPTOR_INCLUDE_DIR=#{Formula["raptor"].opt_include}/raptor2"
    args << "-DRASQAL_INCLUDE_DIR=#{Formula["rasqal"].opt_include}"

    if OS.mac? && (sdk = MacOS.sdk_path_if_needed)
      args << "-DCURL_LIBRARY=#{sdk}/usr/lib/libcurl.tbd"
      args << "-DLIBXSLT_INCLUDE_DIR=#{sdk}/usr/include/"
      args << "-DLIBXSLT_LIBRARIES=#{sdk}/usr/lib/libxslt.tbd"
    end

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "sbol/sbol.h"

      using namespace sbol;

      int main() {
        Document& doc = *new Document();
        doc.write("test.xml");
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11",
                    "-I/System/Library/Frameworks/Python.framework/Headers",
                    "-I#{Formula["raptor"].opt_include}/raptor2",
                    "-I#{include}", "-L#{lib}",
                    "-L#{Formula["jsoncpp"].opt_lib}",
                    "-L#{Formula["raptor"].opt_lib}",
                    "-ljsoncpp", "-lcurl", "-lraptor2", "-lsbol"
    system "./test"
  end
end
