class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.10",
      revision: "c1a3ebdcdcdfbdf0f9bf482c9885d53058e6f7a9"
  license "MIT"
  head "https://github.com/itchyny/gojq.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gojq"
    sha256 cellar: :any_skip_relocation, mojave: "125803a81200ee1c179e677ddf4fc1065f883fe9cb3da38c1be8ee9754c91c8d"
  end

  depends_on "go" => :build

  def install
    revision = Utils.git_short_head
    ldflags = %W[
      -s -w
      -X github.com/itchyny/gojq/cli.revision=#{revision}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/gojq"
    zsh_completion.install "_gojq"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/gojq .bar", '{"foo":1, "bar":2}')
  end
end
