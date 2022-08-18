class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.19.1.tar.gz"
  sha256 "4131a891d68352d20fed9701bcff2df148527de4b9e8d1facfcf867be7f4619e"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kubecm"
    sha256 cellar: :any_skip_relocation, mojave: "2a1b0aaf519fdaf270b631ad4d226379f9a4cb3eb13b415bd86b21e926bc27b2"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/cmd.kubecmVersion=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install bash completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "bash")
    (bash_completion/"kubecm").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "zsh")
    (zsh_completion/"_kubecm").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"kubecm", "completion", "fish")
    (fish_completion/"kubecm.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
