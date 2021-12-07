class Gojq < Formula
  desc "Pure Go implementation of jq"
  homepage "https://github.com/itchyny/gojq"
  url "https://github.com/itchyny/gojq.git",
      tag:      "v0.12.6",
      revision: "886515fe1b7e28bf5193778770619dce4787d85c"
  license "MIT"
  head "https://github.com/itchyny/gojq.git"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/gojq"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "950ee6e0ff835e59c9efcc28cd5a1bb5a62805ac4435dc1051fe36fa1d775f01"
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
