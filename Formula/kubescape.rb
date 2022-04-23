class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/armosec/kubescape"
  url "https://github.com/armosec/kubescape/archive/v2.0.152.tar.gz"
  sha256 "6132b81ebabcadca67fe87406f9be43d48af943f72af6217d80a41d14fbbcbe2"
  license "Apache-2.0"
  head "https://github.com/armosec/kubescape.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kubescape"
    sha256 cellar: :any_skip_relocation, mojave: "942b5d15a1c0d2c0f7c2050dc41f715ae68310be3df0f37bebb43740fedd69cf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/armosec/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"kubescape", "completion", "bash")
    (bash_completion/"kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "zsh")
    (zsh_completion/"_kubescape").write output
    output = Utils.safe_popen_read(bin/"kubescape", "completion", "fish")
    (fish_completion/"kubescape.fish").write output
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/b8fe8900ca1da10c85c9a203d9832b2ee33cc85f/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
