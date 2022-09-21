class Coredns < Formula
  desc "DNS server that chains plugins"
  homepage "https://coredns.io/"
  url "https://github.com/coredns/coredns/archive/v1.10.0.tar.gz"
  sha256 "0fa6631899c0ae93d1b557add54fb18587a5c55627b177eb9f31cdfdf8677184"
  license "Apache-2.0"
  head "https://github.com/coredns/coredns.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/coredns"
    sha256 cellar: :any_skip_relocation, mojave: "d02b80b3f2372d30b4c38740684ad9919fb6e0876bdeecac2d77ebc9e3b5febd"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "bind" => :test # for `dig`
  end

  def install
    system "make"
    bin.install "coredns"
  end

  plist_options startup: true

  service do
    run [opt_bin/"coredns", "-conf", etc/"coredns/Corefile"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/coredns.log"
    error_log_path var/"log/coredns.log"
  end

  test do
    port = free_port
    fork do
      exec bin/"coredns", "-dns.port=#{port}"
    end
    sleep(2)
    output = shell_output("dig @127.0.0.1 -p #{port} example.com.")
    assert_match(/example\.com\.\t\t0\tIN\tA\t127\.0\.0\.1\n/, output)
  end
end
