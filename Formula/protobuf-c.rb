class ProtobufC < Formula
  desc "Protocol buffers library"
  homepage "https://github.com/protobuf-c/protobuf-c"
  url "https://github.com/protobuf-c/protobuf-c/releases/download/v1.4.1/protobuf-c-1.4.1.tar.gz"
  sha256 "4cc4facd508172f3e0a4d3a8736225d472418aee35b4ad053384b137b220339f"
  license "BSD-2-Clause"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/protobuf-c"
    rebuild 1
    sha256 cellar: :any, mojave: "c5e2a1dd0e5dec0a5712d0a1fd680539a9f51d3bfaf1037a67bc3f94a9d50bbb"
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  def install
    ENV.cxx11

    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testdata = <<~EOS
      syntax = "proto3";
      package test;
      message TestCase {
        string name = 4;
      }
      message Test {
        repeated TestCase case = 1;
      }
    EOS
    (testpath/"test.proto").write testdata
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--c_out=."
  end
end
