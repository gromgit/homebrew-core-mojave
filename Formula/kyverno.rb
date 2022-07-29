class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno.git",
      tag:      "v1.7.2",
      revision: "420ac57541a3767f052d57044f636b17d9e0c346"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/kyverno"
    sha256 cellar: :any_skip_relocation, mojave: "738838cc248e611f9e054d1ef657baad0b44288176f6d34cbe9199ad40de0ab4"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=#{Utils.git_head}
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/cli/kubectl-kyverno"

    (bash_completion/"kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "bash")
    (zsh_completion/"_kyverno").write Utils.safe_popen_read(bin/"kyverno", "completion", "zsh")
    (fish_completion/"kyverno.fish").write Utils.safe_popen_read(bin/"kyverno", "completion", "fish")
  end

  test do
    assert_match "Test Summary: 0 tests passed and 0 tests failed", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, "#{bin}/kyverno version"
  end
end
