require "language/node"

class IosSim < Formula
  desc "Command-line application launcher for the iOS Simulator"
  homepage "https://github.com/ios-control/ios-sim"
  url "https://github.com/ios-control/ios-sim/archive/9.0.0.tar.gz"
  sha256 "8c72c8c5f9b0682c218678549c08ca01b3ac2685417fc2ab5b4b803d65a21958"
  license "Apache-2.0"
  head "https://github.com/ios-control/ios-sim.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ios-sim"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "0b21d8a5788ea43d0a8ba97fb21af255ced27620f57a8ad5a04dd2af2b3bf354"
  end

  depends_on :macos
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ios-sim", "--help"
  end
end
