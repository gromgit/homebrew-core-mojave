class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.0.2.tar.gz"
  sha256 "3a43180ab9dee3e50799c2bd5bb728be532e4867d80fa5c2e4a8beab86e5611d"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  depends_on "go" => :build
  depends_on macos: :catalina

  def install
    ldflags = %W[
      -s -w
      -X github.com/kyma-project/cli/cmd/kyma/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin/"kyma", ldflags: ldflags), "./cmd"
  end

  test do
    touch testpath/"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}/kyma install --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
