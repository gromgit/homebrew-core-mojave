class Envconsul < Formula
  desc "Launch process with environment variables from Consul and Vault"
  homepage "https://github.com/hashicorp/envconsul"
  url "https://github.com/hashicorp/envconsul.git",
      tag:      "v0.13.1",
      revision: "3111d811578b1c7f6c8af032a9d97234621e2b0a"
  license "MPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/envconsul"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "dddc3ce600aa02bd22f84c0538f805e2cd5f4186067243a1f2b0d8565ec2b6f4"
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
