class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.20.0.tar.gz"
  sha256 "5b5d849b558c97e41fb7aaab4a7692fb0d6569fd8e9bca7c8b553f24d3f2fb41"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/driftctl"
    sha256 cellar: :any_skip_relocation, mojave: "b6251b90a9a10b22d86d08a9ba4d0af643e760f8ee166ecf131026198fe465b1"
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
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
