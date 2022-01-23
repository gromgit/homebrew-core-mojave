class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.49.2.tar.gz"
  sha256 "a9441633ad6dbf2cb8aa9ad7e5f29027373a4b0b7c5d6496682edca378070480"
  license "MIT"
  head "https://github.com/nicklockwood/SwiftFormat.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/swiftformat"
    sha256 cellar: :any_skip_relocation, mojave: "ee7276299afe536f32a9a24bec4bde420fa0e0cf120a4f4fcd0ff99137e88f8c"
  end

  depends_on xcode: ["10.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
        "-project", "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "-configuration", "Release",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
