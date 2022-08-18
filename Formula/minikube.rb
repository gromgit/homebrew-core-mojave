class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.26.1",
      revision: "62e108c3dfdec8029a890ad6d8ef96b6461426dc"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/minikube"
    sha256 cellar: :any_skip_relocation, mojave: "147cc3d2ff6186776860ca88bc6eaaff615ca89a1f92797ddaa3efe398b68b6c"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read(bin/"minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read(bin/"minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output

    output = Utils.safe_popen_read(bin/"minikube", "completion", "fish")
    (fish_completion/"minikube.fish").write output
  end

  test do
    output = shell_output("#{bin}/minikube version")
    assert_match "version: v#{version}", output

    (testpath/".minikube/config/config.json").write <<~EOS
      {
        "vm-driver": "virtualbox"
      }
    EOS
    output = shell_output("#{bin}/minikube config view")
    assert_match "vm-driver: virtualbox", output
  end
end
