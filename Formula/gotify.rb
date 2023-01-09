class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.2.2.tar.gz"
  sha256 "d44d0058a87684db8c61a9952a84327f7bab102d6a4a16547f7be18b9a9c052c"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gotify"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "8814a64a358220eee948f83522f41c123d3e961c3c63f68846ae74511d597444"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}
                                       -X main.BuildDate=#{time.iso8601}
                                       -X main.Commit=N/A")
  end

  test do
    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
