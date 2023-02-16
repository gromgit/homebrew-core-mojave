class GrpcSwift < Formula
  desc "Swift language implementation of gRPC"
  homepage "https://github.com/grpc/grpc-swift"
  url "https://github.com/grpc/grpc-swift/archive/1.14.0.tar.gz"
  sha256 "643109e821be5097082a618b11f0fa6d57f858680d86e88a0e390e94fb85f21d"
  license "Apache-2.0"
  head "https://github.com/grpc/grpc-swift.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01ddbdddce5a7c7d1838e3ed8c0a708cd2223350c8160f898bfc2ab5e4018376"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80ac79e6099ce9901c53f11f8d339b27fdb9c3eed9878683a6d2bcd1e5fa8c2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a3daa8207218ee5399928c519d222df994f9d3f8a3347f2dca116a0976178db"
    sha256 cellar: :any_skip_relocation, ventura:        "0739d2dd76c068314629a2967eae9cce768d317db38c86f871002ecc05ccbf2f"
    sha256 cellar: :any_skip_relocation, monterey:       "4dc343da28f50817c5678897ffc9b676c0b3a88e857ec6fb84432a8970ac63d3"
    sha256 cellar: :any_skip_relocation, big_sur:        "14246f4ce3bd2b16579a35d4ce385bf0ab3de089102b6e599e45fc9c1b328f3e"
    sha256                               x86_64_linux:   "4484ed956a12e4e6fe25c093701caa982f3f4752175ea4b6c627bf3d9e3ef1bb"
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
