class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.11.10.tar.gz"
  sha256 "c0cfaa3c2cb17ba085faf4f07176f0a6cea639f0f5e64ff1c5e89ceccc79cf9c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/cilium-cli"
    sha256 cellar: :any_skip_relocation, mojave: "6151ff61a3a6dac9dc12f31c7d3b87f4329e3477534506fd718c848c09189187"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    bash_output = Utils.safe_popen_read(bin/"cilium", "completion", "bash")
    (bash_completion/"cilium").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"cilium", "completion", "zsh")
    (zsh_completion/"_cilium").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"cilium", "completion", "fish")
    (fish_completion/"cilium.fish").write fish_output
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
