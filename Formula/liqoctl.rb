class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "cfc0f20625be8fdb2c30653f7b4b9c00332c6f3247cf7da0ad73c220723f5098"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/liqoctl"
    sha256 cellar: :any_skip_relocation, mojave: "1823aa833fe178ec3cc374b0a6f5099340f1fd2efbca377c04da303924c7c79a"
  end

  depends_on "go" => :build

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
    run_install_output = shell_output("#{bin}/liqoctl install kind 2>&1", 1)
    assert_match <<~EOS, run_install_output
      Error: no configuration provided, please set the environment variable KUBECONFIG
    EOS
    assert_match version.to_s, shell_output("#{bin}/liqoctl version")
  end
end
