class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https://kyma-project.io"
  url "https://github.com/kyma-project/cli/archive/2.2.0.tar.gz"
  sha256 "1c9eac608a1637732c3fae3492b8b4ec00a2a3d7c35a5572c80a9bd9ac8e09be"
  license "Apache-2.0"
  head "https://github.com/kyma-project/cli.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kyma-cli"
    sha256 cellar: :any_skip_relocation, mojave: "aa55685627487b980ea210142009030c9a0d3a7e0b7924de75dd3ef63074ae70"
  end

  depends_on "go" => :build

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
      shell_output("#{bin}/kyma deploy --kubeconfig ./kubeconfig 2>&1", 1)
  end
end
