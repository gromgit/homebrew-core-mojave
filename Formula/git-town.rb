class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.6.0.tar.gz"
  sha256 "801d16047a5b74ccbe14f300c721289192d6c68115e97852b21a6eec4be71914"
  license "MIT"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/git-town/git-town/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system "#{bin}/git-town", "config"
  end
end
