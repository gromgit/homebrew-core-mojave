class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.11.2.tar.gz"
  sha256 "000045afa2eaee9a6af475a41fb60541b39e2e7bfb7b985ff7b1040b6bc2c58c"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ko"
    sha256 cellar: :any_skip_relocation, mojave: "ee4ee6a6511ba6dfeaa7918412cfeb71457cbd7f13a8bf9d733ba3cd7ef86ee3"
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
