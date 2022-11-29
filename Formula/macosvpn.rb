class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/2.0.0.tar.gz"
  sha256 "bf91fad369d616907d675be39de7d0c6a78ac0a8c184b59c0af2b6b4a722ca74"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/macosvpn"
    sha256 cellar: :any_skip_relocation, mojave: "766c38712b1bce459579e43e4e8ae36f3488acd40cbb196c0584b0a69987c2f9"
  end

  depends_on xcode: ["11.1", :build]
  depends_on :macos

  def install
    xcodebuild "-arch", Hardware::CPU.arch, "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 2)
  end
end
