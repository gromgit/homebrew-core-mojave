require "language/node"

class ImageoptimCli < Formula
  desc "CLI for ImageOptim, ImageAlpha and JPEGmini"
  homepage "https://jamiemason.github.io/ImageOptim-CLI/"
  url "https://github.com/JamieMason/ImageOptim-CLI/archive/3.0.7.tar.gz"
  sha256 "ed1a36ccb0e960152eda6b3d4c422ee355c8cf8271f1f8e71141a286c4d647e5"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/imageoptim-cli"
    sha256 cellar: :any_skip_relocation, mojave: "633de8d348a6618d839ff4e16694c8634d59accafe13488cd72c88f44386cbe4"
  end

  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on arch: :x86_64 # Installs pre-built x86-64 binaries
  depends_on :macos

  def install
    Language::Node.setup_npm_environment
    system "yarn"
    system "npm", "run", "build"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/imageoptim -V").chomp
  end
end
