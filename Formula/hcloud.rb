class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.30.3.tar.gz"
  sha256 "3e5d1fa240c5d0ea46d209c66c315095f6daa884a9424e2a69b5dc312dafe4d6"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hcloud"
    sha256 cellar: :any_skip_relocation, mojave: "1e32b82052aa887412e4d3f8483c2d366a279be8b4eb96847a0da0235ff56e68"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    output = Utils.safe_popen_read(bin/"hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "zsh")
    (zsh_completion/"_hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "fish")
    (fish_completion/"hcloud.fish").write output
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
