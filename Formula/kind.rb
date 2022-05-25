class Kind < Formula
  desc "Run local Kubernetes cluster in Docker"
  homepage "https://kind.sigs.k8s.io/"
  url "https://github.com/kubernetes-sigs/kind/archive/v0.14.0.tar.gz"
  sha256 "7850a3bb4c644622a1c643e63306ddcd76a5b729375df9bc97f87a82375b9439"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/kind.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kind"
    sha256 cellar: :any_skip_relocation, mojave: "ff35f792be3afaa9235a9045ef36e8be5c9c0de5fb3990c788c193a743fd918a"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    system "go", "build", *std_go_args

    # Install bash completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "bash")
    (bash_completion/"kind").write output

    # Install zsh completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "zsh")
    (zsh_completion/"_kind").write output

    # Install fish completion
    output = Utils.safe_popen_read("#{bin}/kind", "completion", "fish")
    (fish_completion/"kind.fish").write output
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    # Should error out as creating a kind cluster requires root
    status_output = shell_output("#{bin}/kind get kubeconfig --name homebrew 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", status_output
  end
end
