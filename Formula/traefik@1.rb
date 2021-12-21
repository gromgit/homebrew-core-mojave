class TraefikAT1 < Formula
  desc "Modern reverse proxy (v1.7)"
  homepage "https://traefik.io/"
  url "https://github.com/traefik/traefik/archive/refs/tags/v1.7.34.tar.gz"
  sha256 "0f068c2720dadd66ce303863a80d2386a4d13b5475d4219ba3e65b8445c653f2"
  license "MIT"

  livecheck do
    url "https://github.com/traefik/traefik.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/traefik@1"
    sha256 cellar: :any_skip_relocation, mojave: "547ff4b53cb006800cf6c829d2d4a85e44468a583a3d7f1e9bca2059cb30dd56"
  end

  keg_only :versioned_formula

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "node@14" => :build
  depends_on "yarn" => :build
  depends_on :macos # Due to Python 2 for node-sass <= 4

  def install
    cd "webui" do
      system "yarn", "upgrade"
      system "yarn", "install"
      system "yarn", "run", "build"
    end
    system "go", "generate"
    system "go", "build", *std_go_args(output: bin/"traefik", ldflags: "-s -w"), "./cmd/traefik"
  end

  service do
    run [opt_bin/"traefik", "--configfile=#{etc/"traefik/traefik.toml"}"]
    keep_alive false
    working_dir var
    log_path var/"log/traefik.log"
    error_log_path var/"log/traefik.log"
  end

  test do
    web_port = free_port
    http_port = free_port

    (testpath/"traefik.toml").write <<~EOS
      [web]
        address = ":#{web_port}"
      [entryPoints.http]
        address = ":#{http_port}"
    EOS

    begin
      pid = fork do
        exec bin/"traefik", "--configfile=#{testpath}/traefik.toml"
      end
      sleep 5
      cmd = "curl -sIm3 -XGET http://127.0.0.1:#{http_port}/"
      assert_match "404 Not Found", shell_output(cmd)
      sleep 1
      cmd = "curl -sIm3 -XGET http://localhost:#{web_port}/dashboard/"
      assert_match "200 OK", shell_output(cmd)
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
