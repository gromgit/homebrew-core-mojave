class Liqoctl < Formula
  desc "Is a CLI tool to install and manage Liqo-enabled clusters"
  homepage "https://liqo.io"
  url "https://github.com/liqotech/liqo/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "4a89c95613d6a2083987aa29bf76eac0d42ae894e422e3995d039fe8c7b3b2d9"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/liqoctl"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "2ac86d356e0bed1fa17077e4a36b66559ecb306e0c4127b3a5bceb451341b5fe"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/liqotech/liqo/pkg/liqoctl/version.liqoctlVersion=v#{version}
    ].join(" ")

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
      Error: no configuration provided, please set the environment variable KUBECONFIG
    EOS
    assert_match version.to_s, shell_output("#{bin}/liqoctl version")
  end
end
