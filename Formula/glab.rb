class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.24.1/cli-v1.24.1.tar.gz"
  sha256 "dc942f7806aa417714483bd5323bfcde9eceadd7ed33154f7a77038b416bdd95"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/glab"
    sha256 cellar: :any_skip_relocation, mojave: "1cd5a16c7f35e82d2c61b1ad99c0e0c7be52bb14fb346314634cef4f80431ec6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
