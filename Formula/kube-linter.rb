class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter/archive/0.3.0.tar.gz"
  sha256 "204140d9c6953ac4e8cc4d52306eeb2b2cb1b434d66b1638c7242d2721926b78"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kube-linter"
    sha256 cellar: :any_skip_relocation, mojave: "b75c29eace4cffa52555e2680e7dce5e4230f1aa8113f9d57ee5e6ccac6f3bc2"
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
