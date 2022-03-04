class AvroCpp < Formula
  desc "Data serialization system"
  homepage "https://avro.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  mirror "https://archive.apache.org/dist/avro/avro-1.11.0/cpp/avro-cpp-1.11.0.tar.gz"
  sha256 "ef70ca8a1cfeed7017dcb2c0ed591374deab161b86be6ca4b312bc24cada9c56"
  license "Apache-2.0"
  revision 1

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/avro-cpp"
    rebuild 1
    sha256 cellar: :any, mojave: "d42a24990906d92688cde14a209d01edaae393c99b7cac6f45bb2af989656e82"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"cpx.json").write <<~EOS
      {
          "type": "record",
          "name": "cpx",
          "fields" : [
              {"name": "re", "type": "double"},
              {"name": "im", "type" : "double"}
          ]
      }
    EOS
    (testpath/"test.cpp").write <<~EOS
      #include "cpx.hh"

      int main() {
        cpx::cpx number;
        return 0;
      }
    EOS
    system "#{bin}/avrogencpp", "-i", "cpx.json", "-o", "cpx.hh", "-n", "cpx"
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
