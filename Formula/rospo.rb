require "language/node"

class Rospo < Formula
  desc "🐸 Simple, reliable, persistent ssh tunnels with embedded ssh server"
  homepage "https://github.com/ferama/rospo"
  url "https://github.com/ferama/rospo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "967c0bb1d7a10686e93131e6cbbf586774f4f9f7f0bc52b5e6c3a62639a4c31c"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rospo"
    sha256 cellar: :any_skip_relocation, mojave: "8350cf0b873dc31b5f81ebba27ba533df86650883f6e039ea16afc0d0e31a625"
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
