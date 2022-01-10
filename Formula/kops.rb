class Kops < Formula
  desc "Production Grade K8s Installation, Upgrades, and Management"
  homepage "https://kops.sigs.k8s.io/"
  url "https://github.com/kubernetes/kops/archive/v1.22.2.tar.gz"
  sha256 "b6c80827d9a2562743e6b88e23f5ad21bf80d3650acc6dc6009fcc0b3d42df0a"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kops.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kops"
    rebuild 3
    sha256 cellar: :any_skip_relocation, mojave: "a5d09d66de0f9b6ecc678c16be5e88b5935b74235791851fd1902f1961cd939d"
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    ENV["VERSION"] = version unless build.head?
    ENV["GOPATH"] = buildpath
    kopspath = buildpath/"src/k8s.io/kops"
    kopspath.install Dir["*"]
    system "make", "-C", kopspath
    bin.install "bin/kops"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "bash")
    (bash_completion/"kops").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "zsh")
    (zsh_completion/"_kops").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kops", "completion", "fish")
    (fish_completion/"kops.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kops version")
    assert_match "no context set in kubecfg", shell_output("#{bin}/kops validate cluster 2>&1", 1)
  end
end
