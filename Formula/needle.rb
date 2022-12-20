class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  url "https://github.com/uber/needle/archive/v0.21.0.tar.gz"
  sha256 "e214b471319b0b3acc62a7105e06fc74b116a546ac5cce8cd4d3c18f0e6ff6a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "930af092bb21ad2fd58a84b2ee887f4712212248de113f0ef85866852bd70854"
    sha256 cellar: :any, arm64_monterey: "b461236f894b3b735b80f87b4c1808be13f5e054d214d2e0fe8673e6861d4c09"
    sha256 cellar: :any, ventura:        "37cfdaf73b74591acb2bd571dbea613e13790c0fbb548e6b99bea6ab46796c67"
    sha256 cellar: :any, monterey:       "325586b63584cfa4093e0a0fffbf1d6271605330f29671f3fe18b870edc96f5f"
  end

  depends_on xcode: ["14.0", :build]
  depends_on :macos

  def install
    # Avoid building a universal binary.
    swift_build_flags = (buildpath/"Makefile").read[/^SWIFT_BUILD_FLAGS=(.*)$/, 1].split
    %w[--arch arm64 x86_64].each do |flag|
      swift_build_flags.delete(flag)
    end

    system "make", "install", "BINARY_FOLDER_PREFIX=#{prefix}", "SWIFT_BUILD_FLAGS=#{swift_build_flags.join(" ")}"
    bin.install "./Generator/bin/needle"
    libexec.install "./Generator/bin/lib_InternalSwiftSyntaxParser.dylib"

    # lib_InternalSwiftSyntaxParser is taken from Xcode, so it's a universal binary.
    deuniversalize_machos(libexec/"lib_InternalSwiftSyntaxParser.dylib")
  end

  test do
    (testpath/"Test.swift").write <<~EOS
      import Foundation

      protocol ChildDependency: Dependency {}
      class Child: Component<ChildDependency> {}

      let child = Child(parent: self)
    EOS

    assert_match "Root\n", shell_output("#{bin}/needle print-dependency-tree #{testpath}/Test.swift")
    assert_match version.to_s, shell_output("#{bin}/needle version")
  end
end
