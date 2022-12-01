class Hysteria < Formula
  desc "Feature-packed proxy & relay tool optimized for lossy, unstable connections"
  homepage "https://hysteria.network/"
  url "https://github.com/apernet/hysteria.git",
    tag:      "v1.3.1",
    revision: "7a7fda67f2658dd1cad777689dcfa2bda2dcdeca"
  license "MIT"
  head "https://github.com/apernet/hysteria.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hysteria"
    sha256 cellar: :any_skip_relocation, mojave: "80729db2b89e85c84b8119527dbb86184d2691f4de538d60e162243fc31896e1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.appVersion=v#{version} -X main.appDate=#{time.rfc3339} -X main.appCommit=#{Utils.git_short_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./app/cmd"
  end

  service do
    run [opt_bin/"hysteria", "--config", etc/"hysteria/config.json"]
    run_type :immediate
    keep_alive true
  end

  test do
    (testpath/"config.json").write <<~EOS
      {
        "listen": ":36712",
        "acme": {
          "domains": [
            "your.domain.com"
          ],
          "email": "your@email.com"
        },
        "obfs": "8ZuA2Zpqhuk8yakXvMjDqEXBwY"
      }
    EOS
    output = pipe_output "#{opt_bin}/hysteria server -c #{testpath}/config.json"
    assert_includes output, "Server configuration loaded"
  end
end
