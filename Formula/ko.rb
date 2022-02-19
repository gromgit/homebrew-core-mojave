class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.10.0.tar.gz"
  sha256 "55431dcb5c3c82cbc3e636ead9d04d5798154abe1f601785b99923be35b3d2cf"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ko"
    sha256 cellar: :any_skip_relocation, mojave: "85fa03ad27cb07ff58a0af19f9dd1e50046d44584176a15e905fca386c376cd9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}")

    bash_output = Utils.safe_popen_read(bin/"ko", "completion", "bash")
    (bash_completion/"ko").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"ko", "completion", "zsh")
    (zsh_completion/"_ko").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"ko", "completion", "fish")
    (fish_completion/"ko.fish").write fish_output
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
