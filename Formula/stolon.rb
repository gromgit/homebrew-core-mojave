class Stolon < Formula
  desc "Cloud native PostgreSQL manager for high availability"
  homepage "https://github.com/sorintlab/stolon"
  url "https://github.com/sorintlab/stolon.git",
      tag:      "v0.17.0",
      revision: "dc942da234caf016a69df599d0bb455c0716f5b6"
  license "Apache-2.0"
  revision 1

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stolon"
    sha256 cellar: :any_skip_relocation, mojave: "62f639313e17e64512c3ff905db25cb171c57a3d46db346fc6002a9fcef996ac"
  end

  depends_on "go" => :build
  depends_on "consul" => :test
  depends_on "libpq"

  def install
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}",
                          "-trimpath", "-o", bin/"stolonctl", "./cmd/stolonctl"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}",
                          "-trimpath", "-o", bin/"stolon-keeper", "./cmd/keeper"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}",
                          "-trimpath", "-o", bin/"stolon-sentinel", "./cmd/sentinel"
    system "go", "build", "-ldflags", "-s -w -X github.com/sorintlab/stolon/cmd.Version=#{version}",
                          "-trimpath", "-o", bin/"stolon-proxy", "./cmd/proxy"
    prefix.install_metafiles
  end

  test do
    pid = fork do
      exec "consul", "agent", "-dev"
    end
    sleep 2

    assert_match "stolonctl version #{version}",
      shell_output("#{bin}/stolonctl version 2>&1")
    assert_match "nil cluster data: <nil>",
      shell_output("#{bin}/stolonctl status --cluster-name test --store-backend consul 2>&1", 1)
    assert_match "stolon-keeper version #{version}",
      shell_output("#{bin}/stolon-keeper --version 2>&1")
    assert_match "stolon-sentinel version #{version}",
      shell_output("#{bin}/stolon-sentinel --version 2>&1")
    assert_match "stolon-proxy version #{version}",
      shell_output("#{bin}/stolon-proxy --version 2>&1")

    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
