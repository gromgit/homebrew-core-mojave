class GrafanaAgent < Formula
  desc "Exporter for Prometheus Metrics, Loki Logs, and Tempo Traces"
  homepage "https://grafana.com/docs/agent/"
  url "https://github.com/grafana/agent/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "0de47be2e96fff1ddf55de6f53bff301a55b3a142af40bfb934c8c8b5189e9b3"
  license "Apache-2.0"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/grafana-agent"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "fe44c3711feb252501145307cd5f79f5a7b3ec780eca075e7d608eff21457c80"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd" => :build
  end

  def install
    ldflags = %W[
      -X github.com/grafana/agent/pkg/build.Branch=HEAD
      -X github.com/grafana/agent/pkg/build.Version=v#{version}
      -X github.com/grafana/agent/pkg/build.BuildUser=#{tap.user}
      -X github.com/grafana/agent/pkg/build.BuildDate=#{time.rfc3339}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/agent"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "-o", bin/"grafana-agentctl", "./cmd/agentctl"
  end

  def post_install
    (etc/"grafana-agent").mkpath
  end

  def caveats
    <<~EOS
      The agent uses a configuration file that you must customize before running:
        #{etc}/grafana-agent/config.yml
    EOS
  end

  service do
    run [opt_bin/"grafana-agent", "-config.file", etc/"grafana-agent/config.yml"]
    keep_alive true
    log_path var/"log/grafana-agent.log"
    error_log_path var/"log/grafana-agent.err.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafana-agent --version")
    assert_match version.to_s, shell_output("#{bin}/grafana-agentctl --version")

    port = free_port

    (testpath/"wal").mkpath

    (testpath/"grafana-agent.yaml").write <<~EOS
      server:
        log_level: info
        http_listen_port: #{port}
        grpc_listen_port: #{free_port}
    EOS

    system "#{bin}/grafana-agentctl", "config-check", "#{testpath}/grafana-agent.yaml"

    fork do
      exec bin/"grafana-agent", "-config.file=#{testpath}/grafana-agent.yaml",
        "-prometheus.wal-directory=#{testpath}/wal"
    end
    sleep 10

    output = shell_output("curl -s 127.0.0.1:#{port}/metrics")
    assert_match "agent_build_info", output
  end
end
