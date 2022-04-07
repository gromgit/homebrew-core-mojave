require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "ed036506d58826f5494e7e67038c137e6735fa4ccc199cd18c9dae3da41a46b8"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rospo"
    sha256 cellar: :any_skip_relocation, mojave: "4cc873f193e07f851e75637081d16d0885f5c4e34254546260ec2c8b333f65bd"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    chdir "pkg/web/ui" do
      system "npm", "install", *Language::Node.local_npm_install_args
      system "npm", "run", "build"
    end
    system "go", "build", *std_go_args(ldflags: "-s -w -X 'github.com/ferama/rospo/cmd.Version=#{version}'")
  end

  test do
    system "rospo", "-v"
    system "rospo", "keygen", "-s"
    assert_predicate testpath/"identity", :exist?
    assert_predicate testpath/"identity.pub", :exist?
  end
end
