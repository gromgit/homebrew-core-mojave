class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.2.tar.gz"
  sha256 "725af867fa3bece6ccd46e0722eb68fe72462b15faa15c8ada609b5b2a476b07"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/promtail"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "463007da6554f6e0a87de32e008e0692d6aa405b1f888e92fade18709effe30f"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args
      etc.install "promtail-local-config.yaml"
    end
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
