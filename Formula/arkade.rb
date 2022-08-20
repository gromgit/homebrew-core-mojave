class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade.git",
      tag:      "0.8.34",
      revision: "b273819ddf3f78f5d23f5af204ed815638f97d56"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/arkade"
    sha256 cellar: :any_skip_relocation, mojave: "8cfffa641fc1ad3cf42cb88d7d7e3a97614bf9f5311d53052a0e36dda678d440"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/alexellis/arkade/cmd.Version=#{version}
      -X github.com/alexellis/arkade/cmd.GitCommit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "arkade" => "ark"

    (zsh_completion/"_arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "zsh")
    (bash_completion/"arkade").write Utils.safe_popen_read(bin/"arkade", "completion", "bash")
    (fish_completion/"arkade.fish").write Utils.safe_popen_read(bin/"arkade", "completion", "fish")
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match "Version: #{version}", shell_output(bin/"arkade version")
    assert_match "Info for app: openfaas", shell_output(bin/"arkade info openfaas")
  end
end
