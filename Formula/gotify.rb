class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "9013f4afdcc717932e71ab217e09daf4c48e153b23454f5e732ad0f74a8c8979"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gotify"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "a428a8fd0435451721d6cbd763ca332c104b6c83d00642cde248bf4bacaa5a49"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
