class RosaCli < Formula
  desc "RedHat OpenShift Service on AWS (ROSA) command-line interface"
  homepage "https://www.openshift.com/products/amazon-openshift"
  url "https://github.com/openshift/rosa/archive/refs/tags/v1.1.11.tar.gz"
  sha256 "71c88a42088ffb091bedfd1396732805a49293c1632921bd05fe8785297a4bd0"
  license "Apache-2.0"
  head "https://github.com/openshift/rosa.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+\.\d+\.\d+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/rosa-cli"
    sha256 cellar: :any_skip_relocation, mojave: "9129d1b4292a9a6517e2b8823a508b4509bc00671a3a77e18ff82e6a8bec7697"
  end

  depends_on "go" => :build
  depends_on "awscli"

  def install
    system "go", "build", *std_go_args(output: bin/"rosa"), "./cmd/rosa"
    (bash_completion/"rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion", "bash")
    (zsh_completion/"_rosa").write Utils.safe_popen_read("#{bin}/rosa", "completion", "zsh")
    (fish_completion/"rosa.fish").write Utils.safe_popen_read("#{bin}/rosa", "completion", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rosa version")
    assert_match "Not logged in, run the 'rosa login' command", shell_output("#{bin}/rosa create cluster 2<&1", 1)
  end
end
