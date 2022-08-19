class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.10.0",
      revision: "3805ead385cbd7f3bf57d41facefbe0fe2e848c7"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/serf"
    sha256 cellar: :any_skip_relocation, mojave: "7605125182aec862fb8895eb25b433f8093b08a79001871f69d5ecd019edf83c"
  end

  depends_on "go" => :build

  uses_from_macos "zip" => :build

  def install
    ldflags = %W[
      -X github.com/hashicorp/serf/version.Version=#{version}
      -X github.com/hashicorp/serf/version.VersionPrerelease=
    ].join(" ")

    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/serf"
  end

  test do
    pid = fork do
      exec "#{bin}/serf", "agent"
    end
    sleep 1
    assert_match(/:7946.*alive$/, shell_output("#{bin}/serf members"))
  ensure
    system "#{bin}/serf", "leave"
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
