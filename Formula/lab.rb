class Lab < Formula
  desc "Git wrapper for GitLab"
  homepage "https://zaquestion.github.io/lab"
  url "https://github.com/zaquestion/lab/archive/v0.23.0.tar.gz"
  sha256 "8f20d5f1931e9b5daa0aa2d30fc3176d82dcca91b368905a1e1c05e2b36254b9"
  license "CC0-1.0"
  head "https://github.com/zaquestion/lab.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/lab"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "eb163e34d1ee4ceb50e0aac5641b6e83ac5eef2f7510920bf9f408e424fc52ad"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args(ldflags: ldflags)
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "bash")
    (bash_completion/"lab").write output
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "zsh")
    (zsh_completion/"_lab").write output
    output = Utils.safe_popen_read("#{bin}/lab", "completion", "fish")
    (fish_completion/"lab.fish").write output
  end

  test do
    ENV["LAB_CORE_USER"] = "test_user"
    ENV["LAB_CORE_HOST"] = "https://gitlab.com"
    ENV["LAB_CORE_TOKEN"] = "dummy"

    ENV["GIT_AUTHOR_NAME"] = "test user"
    ENV["GIT_AUTHOR_EMAIL"] = "test@example.com"
    ENV["GIT_COMMITTER_NAME"] = "test user"
    ENV["GIT_COMMITTER_EMAIL"] = "test@example.com"

    system "git", "init"
    %w[haunted house].each { |f| touch testpath/f }
    system "git", "add", "haunted", "house"
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert_match "haunted\nhouse", shell_output("#{bin}/lab ls-files").strip
  end
end
