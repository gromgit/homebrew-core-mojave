class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.46.0",
      revision: "a4189ba474f77b5b30eddc2e746f3878e8dd5e1d"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/frps"
    sha256 cellar: :any_skip_relocation, mojave: "078154cf569fba97a9fce0fe0176fdfc4af178a0f14e287f9967c6a71b1b0f0a"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.ini"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
