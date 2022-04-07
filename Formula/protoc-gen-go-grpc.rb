class ProtocGenGoGrpc < Formula
  desc "Protoc plugin that generates code for gRPC-Go clients"
  homepage "https://github.com/grpc/grpc-go"
  url "https://github.com/grpc/grpc-go/archive/cmd/protoc-gen-go-grpc/v1.2.0.tar.gz"
  sha256 "cbca93d6dce724248dfdea6303bf27ed24cc3ed9cf8f7485eb825682eab21284"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{cmd/protoc-gen-go-grpc/v?(\d+(?:\.\d+)+)}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/protoc-gen-go-grpc"
    sha256 cellar: :any_skip_relocation, mojave: "4226444f138ccfa2ecffe752bef68468b6c264c8d9b03de90628148a206691d6"
  end

  depends_on "go" => :build
  depends_on "protobuf"

  def install
    cd "cmd/protoc-gen-go-grpc" do
      system "go", "build", *std_go_args
    end
  end

  test do
    (testpath/"service.proto").write <<~EOS
      syntax = "proto3";

      option go_package = ".;proto";

      service Greeter {
        rpc Hello(HelloRequest) returns (HelloResponse);
      }

      message HelloRequest {}
      message HelloResponse {}
    EOS

    system "protoc", "--plugin=#{bin}/protoc-gen-go-grpc", "--go-grpc_out=.", "service.proto"

    assert_predicate testpath/"service_grpc.pb.go", :exist?
  end
end
