class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/harness/drone-cli.git",
      tag:      "v1.6.2",
      revision: "24bea58512640de52ef16c45f48645e255d8b46c"
  license "Apache-2.0"
  head "https://github.com/harness/drone-cli.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/drone-cli"
    sha256 cellar: :any_skip_relocation, mojave: "80b1eef6a1defaa0141f3a322d49ccd510d64ca1c3472f9686f15befa28269ac"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(output: bin/"drone", ldflags: ldflags), "drone/main.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
