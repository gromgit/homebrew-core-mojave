class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.4.0.tar.gz"
  sha256 "5397d913e757fdf80f2ebd99c1b7264a41d85d72d7d8d079a2a8dd6040c3d5c9"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kube-linter"
    sha256 cellar: :any_skip_relocation, mojave: "4c61d5deeeb60be6c6a918594209d577afd6a664865bd9e9aac6c7b6d6425486"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X golang.stackrox.io/kube-linter/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/kube-linter"

    bash_output = Utils.safe_popen_read(bin/"kube-linter", "completion", "bash")
    (bash_completion/"kube-linter").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"kube-linter", "completion", "zsh")
    (zsh_completion/"_kube-linter").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"kube-linter", "completion", "fish")
    (fish_completion/"kube-linter.fish").write fish_output
  end

  test do
    (testpath/"pod.yaml").write <<~EOS
      apiVersion: v1
      kind: Pod
      metadata:
        name: homebrew-demo
      spec:
        securityContext:
          runAsUser: 1000
          runAsGroup: 3000
          fsGroup: 2000
        containers:
        - name: homebrew-test
          image: busybox:stable
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
            requests:
              memory: "64Mi"
              cpu: "250m"
          securityContext:
            readOnlyRootFilesystem: true
    EOS

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
    assert_equal version.to_s, shell_output("#{bin}/kube-linter version").chomp
  end
end
