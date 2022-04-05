class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2e91ff96e1edc2d11dc76d7f869d7ec82d9e9f9c43be4cb9a7c1bd08aae62a08"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/liqoctl"
    sha256 cellar: :any_skip_relocation, mojave: "be2cd231858a7ce57e8fb5535a6a61fbd25c6b136f01c3ff4453e4ae2382ae1c"
  end

  depends_on "go@1.17" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/liqoctl"

    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "bash")
    (bash_completion/"liqoctl").write output
    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "zsh")
    (zsh_completion/"_liqoctl").write output
    output = Utils.safe_popen_read(bin/"liqoctl", "completion", "fish")
    (fish_completion/"liqoctl").write output
  end

  test do
    run_output = shell_output("#{bin}/liqoctl 2>&1")
    assert_match "liqoctl is a CLI tool to install and manage Liqo-enabled clusters.", run_output
    assert_match version.to_s, shell_output("#{bin}/liqoctl version")
  end
end
