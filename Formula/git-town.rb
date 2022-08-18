class GitTown < Formula
  desc "High-level command-line interface for Git"
  homepage "https://www.git-town.com/"
  url "https://github.com/git-town/git-town/archive/v7.8.0.tar.gz"
  sha256 "a5c04923307ffe8e6cf6ec3ea720170e1565078af5eebba743556db855da8d03"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/git-town"
    sha256 cellar: :any_skip_relocation, mojave: "2be7ba6cbc0bf0a52b7666e9c62f6b232450aae4b273d7832b72588053f001f2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/git-town/git-town/v7/src/cmd.version=v#{version}
      -X github.com/git-town/git-town/v7/src/cmd.buildDate=#{time.strftime("%Y/%m/%d")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    (bash_completion/"git-town").write Utils.safe_popen_read(bin/"git-town", "completions", "bash")
    (zsh_completion/"_git-town").write Utils.safe_popen_read(bin/"git-town", "completions", "zsh")
    (fish_completion/"git-town.fish").write Utils.safe_popen_read(bin/"git-town", "completions", "fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-town version")

    system "git", "init"
    touch "testing.txt"
    system "git", "add", "testing.txt"
    system "git", "commit", "-m", "Testing!"

    system bin/"git-town", "config"
  end
end
