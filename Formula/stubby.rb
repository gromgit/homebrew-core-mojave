class Stubby < Formula
  desc "DNS privacy enabled stub resolver service based on getdns"
  homepage "https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/stubby.git", branch: "develop"

  stable do
    url "https://github.com/getdnsapi/stubby/archive/v0.4.1.tar.gz"
    sha256 "e195f278d16c861a2fb998f075f48b4b5b905b17fc0f33859da03f884b4a4cad"

    # Fix test yml reference issue, remove in next version
    patch do
      url "https://github.com/getdnsapi/stubby/commit/cf9e0f5d97e518f2edb1c21801f2ccf133467f2b.patch?full_index=1"
      sha256 "9d888aab5448b47e844731e640ef9fa9ec6085128247824b3bb2c949d92a1a8d"
    end
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/stubby"
    sha256 mojave: "c6d556e93836053dbe7b3f52e93642308aa9d94269cf196b12d068b4ef891b3c"
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
        - address_data: 145.100.185.15
        - address_data: 145.100.185.16
        - address_data: 185.49.141.37
    EOS
    output = shell_output("#{bin}/stubby -i -C stubby_test.yml")
    assert_match "bindata for 145.100.185.15", output

    fork do
      exec "#{bin}/stubby", "-C", testpath/"stubby_test.yml"
    end
    sleep 2

    assert_match "status: NOERROR", shell_output("dig @127.0.0.1 -p 5553 getdnsapi.net")
  end
end
