class Vcluster < Formula
  desc "Creates fully functional virtual k8s cluster inside host k8s cluster's namespace"
  homepage "https://www.vcluster.com"
  url "https://github.com/loft-sh/vcluster.git",
      tag:      "v0.7.1",
      revision: "dc0ff6f96e9c96fe2caa77e79c2dffc921b4fd49"
  license "Apache-2.0"
  head "https://github.com/loft-sh/vcluster.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vcluster"
    sha256 mojave: "a5be4ce4fc749d3e25c19f299505c4b0a5948a48e0174406e99f372e3d3e19a4"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ldflags = %W[
      -s -w
      -X main.commitHash=#{Utils.git_head}
      -X main.buildDate=#{time.iso8601}
      -X main.version=#{version}
    ]
    system "go", "build", "-mod", "vendor", *std_go_args(ldflags: ldflags), "./cmd/vclusterctl/main.go"
    (zsh_completion/"_vcluster").write Utils.safe_popen_read(bin/"vcluster", "completion", "zsh")
    (bash_completion/"vcluster").write Utils.safe_popen_read(bin/"vcluster", "completion", "bash")
  end

  test do
    help_output = "vcluster root command"
    assert_match help_output, shell_output("#{bin}/vcluster --help")

    create_output = "there is an error loading your current kube config "\
                    "(invalid configuration: no configuration has been provided, "\
                    "try setting KUBERNETES_MASTER environment variable), "\
                    "please make sure you have access to a kubernetes cluster and the command "\
                    "`kubectl get namespaces` is working"
    assert_match create_output, shell_output("#{bin}/vcluster create vcluster -n vcluster --create-namespace", 1)
  end
end
