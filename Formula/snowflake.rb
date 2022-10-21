class Snowflake < Formula
  desc "Pluggable Transport using WebRTC, inspired by Flashproxy"
  homepage "https://www.torproject.org"
  url "https://gitweb.torproject.org/pluggable-transports/snowflake.git/snapshot/snowflake-2.3.1.tar.gz"
  sha256 "47e035ff08668317e719b982a924d048fad738e6081005971e895ddcc2283fba"
  license "BSD-3-Clause"
  head "https://git.torproject.org/pluggable-transports/snowflake.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/snowflake"
    sha256 cellar: :any_skip_relocation, mojave: "5b15ebfc569566f4b0666ab17b44fdc016fedd1b618a54ba1f3956ce88c66120"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"snowflake-broker"), "./broker"
    system "go", "build", *std_go_args(output: bin/"snowflake-client"), "./client"
    system "go", "build", *std_go_args(output: bin/"snowflake-proxy"), "./proxy"
    system "go", "build", *std_go_args(output: bin/"snowflake-server"), "./server"
    man1.install "doc/snowflake-client.1"
    man1.install "doc/snowflake-proxy.1"
  end

  test do
    assert_match "open /usr/share/tor/geoip: no such file", shell_output("#{bin}/snowflake-broker 2>&1", 1)
    assert_match "ENV-ERROR no TOR_PT_MANAGED_TRANSPORT_VER", shell_output("#{bin}/snowflake-client 2>&1", 1)
    assert_match "the --acme-hostnames option is required", shell_output("#{bin}/snowflake-server 2>&1", 1)
  end
end
