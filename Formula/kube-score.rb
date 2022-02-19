class KubeScore < Formula
  desc "Kubernetes object analysis recommendations for improved reliability and security"
  homepage "https://kube-score.com"
  url "https://github.com/zegl/kube-score.git",
      tag:      "v1.14.0",
      revision: "3d6392471f65c47a1c617d78d9f84a53457c5f5d"
  license "MIT"
  head "https://github.com/zegl/kube-score.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kube-score"
    sha256 cellar: :any_skip_relocation, mojave: "9311cefaf3b88ef48da8eef128d749b3631d2e3660eed8ee4f3dd20f20e89089"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-score"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kube-score version")

    (testpath/"test.yaml").write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: node-port-service-with-ignore
        namespace: foospace
        annotations:
          kube-score/ignore: service-type
      spec:
        selector:
          app: my-app
        ports:
        - protocol: TCP
          port: 80
          targetPort: 8080
        type: NodePort
    EOS
    assert_match "The services selector does not match any pods", shell_output("#{bin}/kube-score score test.yaml", 1)
  end
end
