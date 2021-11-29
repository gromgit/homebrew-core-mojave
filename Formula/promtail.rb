class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.1.tar.gz"
  sha256 "a26c22941b406b8c42e55091c23798301181df74063aaaf0f678acffc66d8c27"
  license "AGPL-3.0-only"

  livecheck do
    formula "loki"
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/promtail"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "f35c1bec402c98325c20c4cad01786b5db83355e241e73cfaf6e5780c3c2b80a"
  end

  depends_on "go" => :build

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
