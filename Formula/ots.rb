class Ots < Formula
  desc "🔐 Share end-to-end encrypted secrets with others via a one-time URL"
  homepage "https://ots.sniptt.com"
  url "https://github.com/sniptt-official/ots/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "77101725c2f88a67ec6e4a076c232826c4af265cf0c1348c388ccedcbc4c6492"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/ots"
    sha256 cellar: :any_skip_relocation, mojave: "a7b0f0ea55ad0eeabbdc6667c299e3a4ac67b4b585a4a41c88cb105619a33b41"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sniptt-official/ots/build.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    output = shell_output("#{bin}/ots --version")
    assert_match "ots version #{version}", output

    error_output = shell_output("#{bin}/ots new -x 900h 2>&1", 1)
    assert_match "Error: expiry must be less than 7 days", error_output
  end
end
