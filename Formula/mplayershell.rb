class Mplayershell < Formula
  desc "Improved visual experience for MPlayer on macOS"
  homepage "https://github.com/donmelton/MPlayerShell"
  url "https://github.com/donmelton/MPlayerShell/archive/0.9.3.tar.gz"
  sha256 "a1751207de9d79d7f6caa563a3ccbf9ea9b3c15a42478ff24f5d1e9ff7d7226a"
  license "MIT"
  head "https://github.com/donmelton/MPlayerShell.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/mplayershell"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "5d884bfd0e0a896e76fc7da8ac3b654a2301d7e140ebb36b8957d9a1ce892e34"
  end

  depends_on xcode: :build
  depends_on :macos
  depends_on "mplayer"

  def install
    xcodebuild "-arch", Hardware::CPU.arch,
               "-project", "MPlayerShell.xcodeproj",
               "-target", "mps",
               "-configuration", "Release",
               "clean", "build",
               "SYMROOT=build",
               "DSTROOT=build"
    bin.install "build/Release/mps"
    man1.install "Source/mps.1"
  end

  test do
    system "#{bin}/mps"
  end
end
