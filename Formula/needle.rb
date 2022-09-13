class Needle < Formula
  desc "Compile-time safe Swift dependency injection framework with real code"
  homepage "https://github.com/uber/needle"
  # TODO: Check if a GitHub tarball is sufficient here.
  url "https://github.com/uber/needle.git",
      tag:      "v0.19.0",
      revision: "9d15211866bd307c7bfef789fe77ce1e97aeb978"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_monterey: "0cdbc53949504cdb3d0d723af00bf452731c3891c6eca10a89edfb9871c7bd08"
    sha256 cellar: :any, arm64_big_sur:  "97cb4f17a1642708c59a07eca04d36b377d2a1f0ca0a71aa595b66935875e1a5"
    sha256 cellar: :any, monterey:       "f99d8fc72e9588b310cc7e44895722214edccc536b2a1646bcbd35d63425675d"
    sha256 cellar: :any, big_sur:        "ab1412e10cbe5098cba3bd3729dd9c2189c0f9a24edb865b76e2c9d0174ba85e"
  end

  depends_on xcode: ["13.0", :build] # Swift 5.5+
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
