class Minikube < Formula
  desc "Run a Kubernetes cluster locally"
  homepage "https://minikube.sigs.k8s.io/"
  url "https://github.com/kubernetes/minikube.git",
      tag:      "v1.24.0",
      revision: "76b94fb3c4e8ac5062daf70d60cf03ddcc0a741b"
  license "Apache-2.0"
  head "https://github.com/kubernetes/minikube.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/minikube"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "37e9074cf7f510335b739b27e66f4db84ed6c3d94b9dfdd4b5e794003bd1cdfa"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "kubernetes-cli"

  def install
    system "make"
    bin.install "out/minikube"

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "bash")
    (bash_completion/"minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "zsh")
    (zsh_completion/"_minikube").write output

    output = Utils.safe_popen_read("#{bin}/minikube", "completion", "fish")
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
