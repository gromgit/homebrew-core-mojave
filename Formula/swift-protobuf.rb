class SwiftProtobuf < Formula
  desc "Plugin and runtime library for using protobuf with Swift"
  homepage "https://github.com/apple/swift-protobuf"
  url "https://github.com/apple/swift-protobuf/archive/1.20.1.tar.gz"
  sha256 "66d2cbffed3a5c289405630f39c4a80d696f762558872b3a27e9b33e409bcbf0"
  license "Apache-2.0"
  head "https://github.com/apple/swift-protobuf.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/swift-protobuf"
    sha256 cellar: :any_skip_relocation, mojave: "3c4cc6711ab302fe0a48c976c8ab71c6b4b82db8ec440be9fa6213164218d451"
  end

  depends_on xcode: ["8.3", :build]
  depends_on "protobuf"

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/protoc-gen-swift"
    doc.install "Documentation/PLUGIN.md"
  end

  test do
    (testpath/"test.proto").write <<~EOS
      syntax = "proto3";
      enum Flavor {
        CHOCOLATE = 0;
        VANILLA = 1;
      }
      message IceCreamCone {
        int32 scoops = 1;
        Flavor flavor = 2;
      }
    EOS
    system Formula["protobuf"].opt_bin/"protoc", "test.proto", "--swift_out=."
    assert_predicate testpath/"test.pb.swift", :exist?
  end
end
