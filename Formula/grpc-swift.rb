class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.8.2.tar.gz"
  sha256 "84643fb635aee686dba1887824de71a04ab5dd38bac9d7fafd1991e8d778c564"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc69bd52b26588b694ec63a3c176cf07b6477c45f8a4012a65ebcc8f4644e97d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49a539ab346c24ac3816a022eb0ad10d769544740a63ac2251c9f2f662624c16"
    sha256 cellar: :any_skip_relocation, monterey:       "d033b5f73063f443b7407385c4e0940010acfdbdb96dc2cc276813c80d2c4bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "784cebca195442c0d801268501387c35b8c12ccd32debccf35c26f2083fa29a6"
    sha256                               x86_64_linux:   "acd08bce8b97ff11d619cb851c4b6bfae985ef2980618cde1442c73b56f63fe3"
  end

  depends_on xcode: ["12.5", :build]
  depends_on "protobuf"
  depends_on "swift-protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "protoc-gen-grpc-swift"
    bin.install ".build/release/protoc-gen-grpc-swift"
  end

  test do
    (testpath/"echo.proto").write <<~EOS
      syntax = "proto3";
      service Echo {
        rpc Get(EchoRequest) returns (EchoResponse) {}
        rpc Expand(EchoRequest) returns (stream EchoResponse) {}
        rpc Collect(stream EchoRequest) returns (EchoResponse) {}
        rpc Update(stream EchoRequest) returns (stream EchoResponse) {}
      }
      message EchoRequest {
        string text = 1;
      }
      message EchoResponse {
        string text = 1;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "echo.proto", "--grpc-swift_out=."
    assert_predicate testpath/"echo.grpc.swift", :exist?
  end
end
