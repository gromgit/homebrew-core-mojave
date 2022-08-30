class K3sup < Formula
  desc "Utility to create k3s clusters on any local or remote VM"
  homepage "https://k3sup.dev"
  url "https://github.com/alexellis/k3sup.git",
      tag:      "0.12.3",
      revision: "c0a48331967e1c1e6b10dbd997b65c1496fbd32d"
  license "MIT"
  head "https://github.com/alexellis/k3sup.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/k3sup"
    sha256 cellar: :any_skip_relocation, mojave: "ed21704cd28944ebe1cc081b0b7ceaa9bc7f1f87bf7eb2293c455deae68d735f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/k3sup/cmd.Version=#{version}
      -X github.com/alexellis/k3sup/cmd.GitCommit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    (bash_completion/"k3sup").write Utils.safe_popen_read(bin/"k3sup", "completion", "bash")
    (zsh_completion/"_k3sup").write Utils.safe_popen_read(bin/"k3sup", "completion", "zsh")
    (fish_completion/"k3sup.fish").write Utils.safe_popen_read(bin/"k3sup", "completion", "fish")
  end

  test do
    output = shell_output("#{bin}/k3sup install 2>&1", 1).split("\n").pop
    assert_match "unable to load the ssh key", output
  end
end
