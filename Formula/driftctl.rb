class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.25.0.tar.gz"
  sha256 "b8b9230616db1c594a61bad87c47a602aa28afff4751ec5f2d7d20dd2dad3b78"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/driftctl"
    sha256 cellar: :any_skip_relocation, mojave: "9574deec4050bf164e78eb76892582d09724315401414d1a561df9066e113b89"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "bash")
    (bash_completion/"driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "zsh")
    (zsh_completion/"_driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "fish")
    (fish_completion/"driftctl.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Downloading terraform provider: aws",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
