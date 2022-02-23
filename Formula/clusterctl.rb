class Clusterctl < Formula
  desc "Home for the Cluster Management API work, a subproject of sig-cluster-lifecycle"
  homepage "https://cluster-api.sigs.k8s.io"
  url "https://github.com/kubernetes-sigs/cluster-api.git",
      tag:      "v1.1.2",
      revision: "3433f7b769b4e7f5cb899b2742a5a8a1a9f51b3e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/cluster-api.git", branch: "master"

  # Upstream creates releases on GitHub for the two most recent major/minor
  # versions (e.g., 0.3.x, 0.4.x), so the "latest" release can be incorrect. We
  # don't check the Git tags because, for this project, a version may not be
  # considered released until the GitHub release is created. The first-party
  # website doesn't clearly list the latest version and we have to isolate it
  # from a GitHub URL used in a curl command in the installation instructions.
  livecheck do
    url "https://cluster-api.sigs.k8s.io/user/quick-start.html"
    regex(%r{/cluster-api/releases/download/v?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/clusterctl"
    sha256 cellar: :any_skip_relocation, mojave: "841873de91255ddbfcb8b76f765b65d10864a6e7f49445d29ffbfcdfef764d9b"
  end

  depends_on "go" => :build

  def install
    # Don't dirty the git tree
    rm_rf ".brew_home"

    system "make", "clusterctl"
    prefix.install "bin"

    bash_output = Utils.safe_popen_read(bin/"clusterctl", "completion", "bash")
    (bash_completion/"clusterctl").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"clusterctl", "completion", "zsh")
    (zsh_completion/"_clusterctl").write zsh_output
  end

  test do
    output = shell_output("KUBECONFIG=/homebrew.config  #{bin}/clusterctl init --infrastructure docker 2>&1", 1)
    assert_match "Error: invalid kubeconfig file; clusterctl requires a valid kubeconfig", output
  end
end
