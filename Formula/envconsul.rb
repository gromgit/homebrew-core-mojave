class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      tag:      "v0.13.0",
      revision: "c9c55c9bffa749227e3c3bcd44f93f1f5b0eafb9"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/envconsul"
    sha256 cellar: :any_skip_relocation, mojave: "452dfeff75d11bddc1196afd842eb1b69cbd746f008fe3ed82ca7aadbe2577e9"
  end

  depends_on "go" => :build
  depends_on "consul" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    port = free_port
    begin
      fork do
        exec "consul agent -dev -bind 127.0.0.1 -http-port #{port}"
        puts "consul started"
      end
      sleep 5

      system "consul", "kv", "put", "-http-addr", "127.0.0.1:#{port}", "homebrew-recipe-test/working", "1"
      output = shell_output("#{bin}/envconsul -consul-addr=127.0.0.1:#{port} " \
                            "-upcase -prefix homebrew-recipe-test env")
      assert_match "WORKING=1", output
    ensure
      system "consul", "leave", "-http-addr", "127.0.0.1:#{port}"
    end
  end
end
