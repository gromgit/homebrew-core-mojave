class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby"
  url "https://github.com/getdnsapi/stubby/archive/v0.4.2.tar.gz"
  sha256 "1525934e8e6b476edc4e5668c566705e99927336db58aee20c1643517fc064ed"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/stubby.git", branch: "develop"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stubby"
    sha256 mojave: "cfccb20a36d21e708b82a6a43d9b27d2585b325a2d02beebf6765677184c3c45"
  end

  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "getdns"
  depends_on "libyaml"

  on_linux do
    depends_on "bind" => :test
  end

  def install
    system "cmake", "-DCMAKE_INSTALL_RUNSTATEDIR=#{HOMEBREW_PREFIX}/var/run/", \
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{HOMEBREW_PREFIX}/etc", ".", *std_cmake_args
    system "make", "install"
  end

  service do
    run [opt_bin/"stubby", "-C", etc/"stubby/stubby.yml"]
    keep_alive true
    run_type :immediate
  end

  test do
    assert_predicate etc/"stubby/stubby.yml", :exist?
    (testpath/"stubby_test.yml").write <<~EOS
      resolution_type: GETDNS_RESOLUTION_STUB
      dns_transport_list:
        - GETDNS_TRANSPORT_TLS
        - GETDNS_TRANSPORT_UDP
        - GETDNS_TRANSPORT_TCP
      listen_addresses:
        - 127.0.0.1@5553
      idle_timeout: 0
      upstream_recursive_servers:
        - address_data: 8.8.8.8
        - address_data: 8.8.4.4
        - address_data: 1.1.1.1
    EOS
    output = shell_output("#{bin}/stubby -i -C stubby_test.yml")
    assert_match "bindata for 8.8.8.8", output

    fork do
      exec "#{bin}/stubby", "-C", testpath/"stubby_test.yml"
    end
    sleep 2

    assert_match "status: NOERROR", shell_output("dig @127.0.0.1 -p 5553 getdnsapi.net")
  end
end
