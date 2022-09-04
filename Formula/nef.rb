class Nef < Formula
  desc "💊 steroids for Xcode Playgrounds"
  homepage "https://nef.bow-swift.io"
  url "https://github.com/bow-swift/nef/archive/0.7.1.tar.gz"
  sha256 "147b8723d65ababedd04abf2ea4445c2b16dd7c18814a92182ae61978eb1152e"
  license "Apache-2.0"

  bottle do
    sha256 mojave: "f27baf8ae2f171b8f7236ee399bb9df7da423c4ef81b68d7e0ece78df850d204" # fake mojave
  end

  depends_on :macos
  depends_on xcode: "13.1"

  def install
    system "make", "install", "prefix=#{prefix}", "version=#{version}"
  end

  test do
    system "#{bin}/nef", "markdown",
           "--project", "#{share}/tests/Documentation.app",
           "--output", "#{testpath}/nef"
    assert_path_exists "#{testpath}/nef/library/apis.md"
  end
end
