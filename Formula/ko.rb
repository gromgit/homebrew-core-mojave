class Ko < Formula
  desc "Build and deploy Go applications on Kubernetes"
  homepage "https://github.com/google/ko"
  url "https://github.com/google/ko/archive/v0.9.3.tar.gz"
  sha256 "a31c9f6f3fd443599b854338f396f0e4c43a3d6ef7b1138f5df75a2c1c785c61"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ko"
    sha256 cellar: :any_skip_relocation, mojave: "3dee036c7d1b25ed7645acfef02786ae288acf95c9f0fd67e05a514367010ae6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags",
      "-s -w -X github.com/google/ko/pkg/commands.Version=#{version}"

    bash_output = Utils.safe_popen_read(bin/"ko", "completion")
    (bash_completion/"ko").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"ko", "completion", "--zsh")
    (zsh_completion/"_ko").write zsh_output
  end

  test do
    output = shell_output("#{bin}/ko login reg.example.com -u brew -p test 2>&1")
    assert_match "logged in via #{testpath}/.docker/config.json", output
  end
end
