class Rswift < Formula
  desc "Get strong typed, autocompleted resources like images, fonts and segues"
  homepage "https://github.com/mac-cain13/R.swift"
  url "https://github.com/mac-cain13/R.swift/releases/download/v6.1.0/rswift-v6.1.0-source.tar.gz"
  sha256 "f4b4c3f8748358c569c219d7f506d3b34ea5af82c882ee4a23381f23c4d277c8"
  license "MIT"
  head "https://github.com/mac-cain13/R.swift.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rswift"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "04afe6ec87f5f5aad3cc66d425b1eb71107200f703ddf160f37445c954b58f78"
  end

  depends_on :macos # needs CoreGraphics, a macOS-only library
  depends_on xcode: "10.2"

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/rswift"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rswift --version")
    expected_output="[R.swift] Missing value for `PROJECT_FILE_PATH`"
    assert_match expected_output, shell_output("#{bin}/rswift generate #{testpath} 2>1&")
  end
end
