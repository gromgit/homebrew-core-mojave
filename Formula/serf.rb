class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      tag:      "v0.9.8",
      revision: "a2bba5676d6e37953715ea10e583843793a0c507"
  license "MPL-2.0"
  head "https://github.com/hashicorp/serf.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/serf"
    sha256 cellar: :any_skip_relocation, mojave: "7f8cf5be62ef74dc36f66127f283c88d20505f9d21a554356842e1cb3b3032aa"
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
