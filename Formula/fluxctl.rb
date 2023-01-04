class Fluxctl < Formula
  desc "Command-line tool to access Weave Flux, the Kubernetes GitOps operator"
  homepage "https://github.com/fluxcd/flux"
  url "https://github.com/fluxcd/flux.git",
      tag:      "1.25.4",
      revision: "95493343346f2000299996bab0fc49caf31201dd"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/fluxctl"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "55815d5dc69fcaf9edfc3537a2b223e6eb3dc97aeced10f7a1b3c4da47a494ed"
  end

  deprecate! date: "2022-11-08", because: :repo_archived

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/fluxctl"

    generate_completions_from_executable(bin/"fluxctl", "completion")
  end

  test do
    run_output = shell_output("#{bin}/fluxctl 2>&1")
    assert_match "fluxctl helps you deploy your code.", run_output

    version_output = shell_output("#{bin}/fluxctl version 2>&1")
    assert_match version.to_s, version_output

    # As we can't bring up a Kubernetes cluster in this test, we simply
    # run "fluxctl sync" and check that it 1) errors out, and 2) complains
    # about a missing .kube/config file.
    require "pty"
    require "timeout"
    r, _w, pid = PTY.spawn("#{bin}/fluxctl sync", err: :out)
    begin
      Timeout.timeout(5) do
        assert_match "Error: Could not load kubernetes configuration file", r.gets.chomp
        Process.wait pid
        assert_equal 1, $CHILD_STATUS.exitstatus
      end
    rescue Timeout::Error
      puts "process not finished in time, killing it"
      Process.kill("TERM", pid)
    end
  end
end
